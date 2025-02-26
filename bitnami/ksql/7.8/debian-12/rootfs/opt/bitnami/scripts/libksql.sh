#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Confluent KSQL library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh

# Functions

########################
# Return listeners ports
# Globals:
#   KSQL_LISTENERS
# Arguments:
#   $1 - Bucket name
# Returns:
#   Boolean
#########################
ksql_ports() {
    local ports

    if [[ -n "$KSQL_LISTENERS" ]]; then
        read -r -a listeners <<< "$(tr ',;' ' ' <<< "$KSQL_LISTENERS")"
        for l in "${listeners[@]}"; do
            if [[ "$l" =~ [a-zA-Z]*://.*:([0-9]*) ]]; then
                ports+=("${BASH_REMATCH[1]}")
            fi
        done
        echo "${ports[@]}"
    else
        echo "8081"
    fi
}

########################
# Return listeners protocols
# Globals:
#   KSQL_LISTENERS
# Arguments:
#   $1 - Bucket name
# Returns:
#   Boolean
#########################
ksql_protocols() {
    local protocols

    if [[ -n "$KSQL_LISTENERS" ]]; then
        read -r -a listeners <<< "$(tr ',;' ' ' <<< "$KSQL_LISTENERS")"
        for l in "${listeners[@]}"; do
            if [[ "$l" =~ ([a-zA-Z]*)://.*:[0-9]* ]]; then
                protocols+=("${BASH_REMATCH[1]}")
            fi
        done
        echo "${protocols[@]}"
    else
        echo "http"
    fi
}

########################
# Validate settings in KSQL_* env vars
# Globals:
#   KSQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
ksql_validate() {
    info "Validating settings in KSQL_* env vars"
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    check_true_false_value() {
        if ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for $1 are [true, false]"
        fi
    }
    check_conflicting_ports() {
        local -r total="$#"
        for i in $(seq 1 "$((total - 1))"); do
            for j in $(seq "$((i + 1))" "$total"); do
                if (( "${!i}" == "${!j}" )); then
                    print_validation_error "There are listeners bound to the same port"
                fi
            done
        done
    }
    check_allowed_port() {
        local validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        if ! err=$(validate_port "${validate_port_args[@]}" "$1"); then
            print_validation_error "An invalid port was specified in the environment variable KSQL_LISTENERS: $err"
        fi
    }

    if [[ -n "$KSQL_LISTENERS" ]]; then
        read -r -a ports <<< "$(ksql_ports)"
        for port in "${ports[@]}"; do
            check_allowed_port "$port"
        done
        [[ "${#ports[@]}" -gt 1 ]] && check_conflicting_ports "${ports[@]}"
        read -r -a protocols <<< "$(ksql_protocols)"
        if [[ "${protocols[*]}" =~ https ]]; then
            if [[ ! -f ${KSQL_CERTS_DIR}/ssl.keystore.jks ]]; then
                print_validation_error "In order to configure HTTPS access, you must mount your ssl.keystore.jks (and optionally the ssl.truststore.jks) to the ${KSQL_CERTS_DIR} directory."
            fi
        fi
    fi
    [[ -z "$KSQL_BOOTSTRAP_SERVERS" && ! -f "$KSQL_CONF_FILE" ]] && warn "KSQL_BOOTSTRAP_SERVERS should be provided"

    [[ "$error_code" -eq 0 ]] || return "$error_code"
}

########################
# Set a configuration setting value to the configuration file
# Globals:
#   KSQL_*
# Arguments:
#   $1 - key
#   $2 - values (array)
# Returns:
#   None
#########################
ksql_conf_set() {
    local -r key="${1:?missing key}"
    shift
    local -r -a values=("$@")

    if [[ "${#values[@]}" -eq 0 ]]; then
        stderr_print "missing value"
        return 1
    elif [[ "${#values[@]}" -ne 1 ]]; then
        for i in "${!values[@]}"; do
            ksql_conf_set "${key[$i]}" "${values[$i]}"
        done
    else
        value="${values[0]}"
        # Check if the value was set before
        if grep -q "^[# ]*$key\s*=.*" "$KSQL_CONF_FILE"; then
            # Update the existing key
            replace_in_file "$KSQL_CONF_FILE" "^[# ]*${key}\s*=.*" "${key} = ${value}" false
        else
            # Add a new key
            printf '\n%s = %s' "$key" "$value" >>"$KSQL_CONF_FILE"
        fi
    fi
}

########################
# Wait for Kafka brokers to be up
# Globals:
#   KSQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
ksql_wait_for_kafka_brokers() {
    local kafka_brokers
    local host
    local port

    info "Waiting for Kafka brokers to be up"
    kafka_brokers="$(grep "^bootstrap.servers" "$KSQL_CONF_FILE" | cut -d '=' -f 2)"
    read -r -a brokers <<< "$(tr ',;' ' ' <<< "${kafka_brokers/%,/}")"
    for b in "${brokers[@]}"; do
        if [[ "$b" =~ [_a-zA-Z]*://(.*):([0-9]*) ]]; then
            host="${BASH_REMATCH[1]}"
            port="${BASH_REMATCH[2]}"
            if ! retry_while "debug_execute nc -w $KSQL_CONNECTION_ATTEMPT_TIMEOUT -z ${host} ${port}" 10 10; then
                error "Failed to connect to the broker at $host:$port"
                return 1
            fi
        fi
    done
}

########################
# Initialize Confluent KSQL
# Globals:
#   KSQL_*
# Arguments:
#   None
# Returns:
#   None
#########################
ksql_initialize() {
    info "Initializing Confluent KSQL"

    # Check for mounted configuration files
    if ! is_dir_empty "$KSQL_MOUNTED_CONF_DIR"; then
        cp -Lr "$KSQL_MOUNTED_CONF_DIR"/* "$KSQL_CONF_DIR"
    fi
    if [[ -f "$KSQL_CONF_FILE" ]]; then
        info "Injected configuration file found. Skipping default configuration"
    else
        info "No injected configuration files found, creating default config file."
        mv "${KSQL_CONF_FILE}.default" "$KSQL_CONF_FILE"

        # Kafka boostrap settings
        [[ -n "$KSQL_BOOTSTRAP_SERVERS" ]] && ksql_conf_set "bootstrap.servers" "$KSQL_BOOTSTRAP_SERVERS"
        # Listeners settings
        if [[ -n "$KSQL_LISTENERS" ]]; then
            ksql_conf_set "listeners" "$KSQL_LISTENERS"
            read -r -a protocols <<< "$(ksql_protocols)"
            if [[ "${protocols[*]}" =~ https ]]; then
                ksql_conf_set "ssl.keystore.location" "${KSQL_CERTS_DIR}/ssl.keystore.jks"
                [[ -n "$KSQL_SSL_KEYSTORE_PASSWORD" ]] && ksql_conf_set "ssl.keystore.password" "$KSQL_SSL_KEYSTORE_PASSWORD"
                [[ -f "${KSQL_CERTS_DIR}/ssl.truststore.jks" ]] && ksql_conf_set "ssl.truststore.location" "${KSQL_CERTS_DIR}/ssl.truststore.jks"
                [[ -n "$KSQL_SSL_TRUSTSTORE_PASSWORD" ]] && ksql_conf_set "ssl.truststore.password" "$KSQL_SSL_TRUSTSTORE_PASSWORD"
            fi
            [[ -n "$KSQL_CLIENT_AUTHENTICATION" ]] && ksql_conf_set "ssl.client.authentication" "$KSQL_CLIENT_AUTHENTICATION"
        fi
    fi
    ksql_wait_for_kafka_brokers
}
