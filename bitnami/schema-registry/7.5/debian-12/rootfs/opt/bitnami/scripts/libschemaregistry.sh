#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Schema Registry library

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
# Return Authentication Protocol for brokers
# Globals:
#   SCHEMA_REGISTRY_KAFKA_BROKERS
# Arguments:
#   $1 - Bucket name
# Returns:
#   Boolean
#########################
schema_registry_brokers_auth_protocol() {
    local brokers_auth_protocols
    local unique_protocols

    if [[ -n "$SCHEMA_REGISTRY_KAFKA_BROKERS" ]]; then
        read -r -a brokers <<< "$(tr ',;' ' ' <<< "${SCHEMA_REGISTRY_KAFKA_BROKERS/%,/}")"
        for b in "${brokers[@]}"; do
            if [[ "$b" =~ ([_a-zA-Z]*)://.*:[0-9]* ]]; then
                brokers_auth_protocols+=("${BASH_REMATCH[1]}")
            fi
        done
        read -r -a unique_protocols <<< "$(echo "${brokers_auth_protocols[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' ')"
        if [[ "${#brokers_auth_protocols[@]}" -gt 1 ]] && [[ "${#unique_protocols[@]}" -gt 1 ]]; then
            return 1
        else
            echo "${brokers_auth_protocols[0]}"
        fi
    else
        echo "PLAINTEXT"
    fi
}

########################
# Return listeners ports
# Globals:
#   SCHEMA_REGISTRY_LISTENERS
# Arguments:
#   $1 - Bucket name
# Returns:
#   Boolean
#########################
schema_registry_ports() {
    local ports

    if [[ -n "$SCHEMA_REGISTRY_LISTENERS" ]]; then
        read -r -a listeners <<< "$(tr ',;' ' ' <<< "$SCHEMA_REGISTRY_LISTENERS")"
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
#   SCHEMA_REGISTRY_LISTENERS
# Arguments:
#   $1 - Bucket name
# Returns:
#   Boolean
#########################
schema_registry_protocols() {
    local protocols

    if [[ -n "$SCHEMA_REGISTRY_LISTENERS" ]]; then
        read -r -a listeners <<< "$(tr ',;' ' ' <<< "$SCHEMA_REGISTRY_LISTENERS")"
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
# Validate settings in SCHEMA_REGISTRY_* env vars
# Globals:
#   SCHEMA_REGISTRY_*
# Arguments:
#   None
# Returns:
#   None
#########################
schema_registry_validate() {
    info "Validating settings in SCHEMA_REGISTRY_* env vars"
    local error_code=0
    local ports
    local protocols
    local brokers_auth_protocol

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
            print_validation_error "An invalid port was specified in the environment variable SCHEMA_REGISTRY_LISTENERS: $err"
        fi
    }

    if [[ -n "$SCHEMA_REGISTRY_KAFKA_BROKERS" ]]; then
        if brokers_auth_protocol="$(schema_registry_brokers_auth_protocol)"; then
            if [[ "$brokers_auth_protocol" =~ SSL ]]; then
                if [[ ! -f ${SCHEMA_REGISTRY_CERTS_DIR}/schema-registry.keystore.jks ]] || [[ ! -f ${SCHEMA_REGISTRY_CERTS_DIR}/schema-registry.truststore.jks ]]; then
                    warn "In order to configure the TLS encryption for communication with Kafka brokers, most auth protocols require mounting your schema-registry.keystore.jks and schema-registry.truststore.jks certificates to the ${SCHEMA_REGISTRY_CERTS_DIR} directory."
                fi
            fi
            if [[ "$brokers_auth_protocol" =~ SASL ]]; then
                if [[ -z "$SCHEMA_REGISTRY_KAFKA_SASL_USERS" ]] || [[ -z "$SCHEMA_REGISTRY_KAFKA_SASL_PASSWORDS" ]]; then
                    warn "In order to configure SASL authentication for Kafka, most auth protocols require providing the SASL credentials. Set the environment variables SCHEMA_REGISTRY_KAFKA_SASL_USERS and SCHEMA_REGISTRY_KAFKA_SASL_PASSWORDS if your auth protocol requires it."
                fi
            fi
        else
            print_validation_error "Currently using different auth mechanisms on different Kafka brokers is not supported."
        fi
    fi

    if [[ -n "$SCHEMA_REGISTRY_LISTENERS" ]]; then
        read -r -a ports <<< "$(schema_registry_ports)"
        for port in "${ports[@]}"; do
            check_allowed_port "$port"
        done
        [[ "${#ports[@]}" -gt 1 ]] && check_conflicting_ports "${ports[@]}"
        read -r -a protocols <<< "$(schema_registry_protocols)"
        if [[ "${protocols[*]}" =~ https ]]; then
            if [[ ! -f ${SCHEMA_REGISTRY_CERTS_DIR}/ssl.keystore.jks ]]; then
                print_validation_error "In order to configure HTTPS access, you must mount your ssl.keystore.jks (and optionally the ssl.truststore.jks) to the ${SCHEMA_REGISTRY_CERTS_DIR} directory."
            fi
        fi
    fi

    if [[ -n "$SCHEMA_REGISTRY_CLIENT_AUTHENTICATION" ]]; then
        if ! [[ "$SCHEMA_REGISTRY_CLIENT_AUTHENTICATION" =~ ^(NONE|REQUESTED|REQUIRED)$ ]]; then
            print_validation_error "The allowed values for SCHEMA_REGISTRY_CLIENT_AUTHENTICATION are: NONE, REQUESTED, or REQUIRED."
        fi
    fi
    if [[ -n "$SCHEMA_REGISTRY_AVRO_COMPATIBILY_LEVEL" ]]; then
        if ! [[ "$SCHEMA_REGISTRY_AVRO_COMPATIBILY_LEVEL" =~ ^(none|backward|backward_transitive|forward|forward_transitive|full|full_transitive)$ ]]; then
            print_validation_error "The allowed values for SCHEMA_REGISTRY_AVRO_COMPATIBILY_LEVEL are: none, backward, backward_transitive, forward, forward_transitive, full or full_transitive"
        fi
    fi
    [[ -n "$SCHEMA_REGISTRY_DEBUG" ]] && check_true_false_value SCHEMA_REGISTRY_DEBUG

    [[ "$error_code" -eq 0 ]] || return "$error_code"
}

########################
# Determine the hostname advertised in ZooKeeper
# Globals:
#   SCHEMA_REGISTRY_*
# Returns:
#   String
########################
schema_registry_hostname() {
    echo "${SCHEMA_REGISTRY_ADVERTISED_HOSTNAME:-"$(get_machine_ip)"}"
}

########################
# Set a configuration setting value to the configuration file
# Globals:
#   SCHEMA_REGISTRY_*
# Arguments:
#   $1 - key
#   $2 - values (array)
# Returns:
#   None
#########################
schema_registry_conf_set() {
    local -r key="${1:?missing key}"
    shift
    local -r -a values=("$@")

    if [[ "${#values[@]}" -eq 0 ]]; then
        stderr_print "missing value"
        return 1
    elif [[ "${#values[@]}" -ne 1 ]]; then
        for i in "${!values[@]}"; do
            schema_registry_conf_set "${key[$i]}" "${values[$i]}"
        done
    else
        value="${values[0]}"
        # Check if the value was set before
        if grep -q "^[# ]*$key\s*=.*" "$SCHEMA_REGISTRY_CONF_FILE"; then
            # Update the existing key
            replace_in_file "$SCHEMA_REGISTRY_CONF_FILE" "^[# ]*${key}\s*=.*" "${key} = ${value}" false
        else
            # Add a new key
            printf '\n%s = %s' "$key" "$value" >>"$SCHEMA_REGISTRY_CONF_FILE"
        fi
    fi
}

########################
# Wait for Kafka brokers to be up
# Globals:
#   SCHEMA_REGISTRY_KAFKA_BROKERS
# Arguments:
#   None
# Returns:
#   None
#########################
schema_registry_for_kafka_brokers() {
    local host
    local port

    if [[ -n "$SCHEMA_REGISTRY_KAFKA_BROKERS" ]]; then
        info "Waiting for Kafka brokers to be up"
        read -r -a brokers <<< "$(tr ',;' ' ' <<< "${SCHEMA_REGISTRY_KAFKA_BROKERS/%,/}")"
        for b in "${brokers[@]}"; do
            if [[ "$b" =~ [_a-zA-Z]*://(.*):([0-9]*) ]]; then
                host="${BASH_REMATCH[1]}"
                port="${BASH_REMATCH[2]}"
                if ! retry_while "debug_execute nc -z ${host} ${port}" 10 10; then
                    error "Failed to connect to the broker at $host:$port"
                    return 1
                fi
            fi
        done
    fi
}

########################
# Initialize Schema Registry
# Globals:
#   SCHEMA_REGISTRY_*
# Arguments:
#   None
# Returns:
#   None
#########################
schema_registry_initialize() {
    info "Initializing Schema Registry"
    local protocols
    local brokers_auth_protocol

    # Check for mounted configuration files
    if ! is_dir_empty "$SCHEMA_REGISTRY_MOUNTED_CONF_DIR"; then
        cp -Lr "$SCHEMA_REGISTRY_MOUNTED_CONF_DIR"/* "$SCHEMA_REGISTRY_CONF_DIR"
    fi
    if [[ -f "$SCHEMA_REGISTRY_CONF_FILE" ]]; then
        debug "Injected configuration file found. Skipping default configuration"
    else
        info "No injected configuration files found, creating config file based on SCHEMA_REGISTRY_* env vars"
        mv "${SCHEMA_REGISTRY_CONF_DIR}/schema-registry/schema-registry.properties.default" "$SCHEMA_REGISTRY_CONF_FILE"

        # Authentication Settings
        brokers_auth_protocol="$(schema_registry_brokers_auth_protocol)"
        [[ -n "$SCHEMA_REGISTRY_KAFKA_BROKERS" ]] && schema_registry_conf_set "kafkastore.bootstrap.servers" "${SCHEMA_REGISTRY_KAFKA_BROKERS/%,/}"
        schema_registry_conf_set "kafkastore.security.protocol" "$brokers_auth_protocol"
        if [[ "$brokers_auth_protocol" =~ SASL ]]; then
            read -r -a users <<< "$(tr ',;' ' ' <<< "${SCHEMA_REGISTRY_KAFKA_SASL_USERS}")"
            read -r -a passwords <<< "$(tr ',;' ' ' <<< "${SCHEMA_REGISTRY_KAFKA_SASL_PASSWORDS}")"
            aux_string="org.apache.kafka.common.security.plain.PlainLoginModule required username=\"${users[0]:-}\" password=\"${passwords[0]:-}\";"
            if [[ "${SCHEMA_REGISTRY_KAFKA_SASL_MECHANISM:-}" =~ SCRAM  ]]; then
                schema_registry_conf_set "kafkastore.sasl.mechanism" "${SCHEMA_REGISTRY_KAFKA_SASL_MECHANISM}"
                aux_string="org.apache.kafka.common.security.scram.ScramLoginModule required username=\"${users[0]:-}\" password=\"${passwords[0]:-}\";"
            fi
            schema_registry_conf_set "kafkastore.sasl.jaas.config" "$aux_string"
        fi

        # TLS setup
        [[ -f "${SCHEMA_REGISTRY_CERTS_DIR}/schema-registry.keystore.jks" ]] && schema_registry_conf_set "kafkastore.ssl.keystore.location" "${SCHEMA_REGISTRY_CERTS_DIR}/schema-registry.keystore.jks"
        [[ -n "$SCHEMA_REGISTRY_KAFKA_KEYSTORE_PASSWORD" ]] && schema_registry_conf_set "kafkastore.ssl.keystore.password" "$SCHEMA_REGISTRY_KAFKA_KEYSTORE_PASSWORD"
        [[ -f "${SCHEMA_REGISTRY_CERTS_DIR}/schema-registry.truststore.jks" ]] && schema_registry_conf_set "kafkastore.ssl.truststore.location" "${SCHEMA_REGISTRY_CERTS_DIR}/schema-registry.truststore.jks"
        [[ -n "$SCHEMA_REGISTRY_KAFKA_KEY_PASSWORD" ]] && schema_registry_conf_set "kafkastore.ssl.key.password" "$SCHEMA_REGISTRY_KAFKA_KEY_PASSWORD"
        [[ -n "$SCHEMA_REGISTRY_KAFKA_TRUSTSTORE_PASSWORD" ]] && schema_registry_conf_set "kafkastore.ssl.truststore.password" "$SCHEMA_REGISTRY_KAFKA_TRUSTSTORE_PASSWORD"
        [[ -n "$SCHEMA_REGISTRY_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM" ]] && schema_registry_conf_set "kafkastore.ssl.endpoint.identification.algorithm" "$SCHEMA_REGISTRY_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM"

        # Listeners settings
        if [[ -n "$SCHEMA_REGISTRY_LISTENERS" ]]; then
            schema_registry_conf_set "listeners" "$SCHEMA_REGISTRY_LISTENERS"
            read -r -a protocols <<< "$(schema_registry_protocols)"
            if [[ "${protocols[*]}" =~ https ]]; then
                schema_registry_conf_set "ssl.keystore.location" "${SCHEMA_REGISTRY_CERTS_DIR}/ssl.keystore.jks"
                [[ -n "$SCHEMA_REGISTRY_SSL_KEYSTORE_PASSWORD" ]] && schema_registry_conf_set "ssl.keystore.password" "$SCHEMA_REGISTRY_SSL_KEYSTORE_PASSWORD"
                [[ -n "$SCHEMA_REGISTRY_SSL_KEY_PASSWORD" ]] && schema_registry_conf_set "ssl.key.password" "$SCHEMA_REGISTRY_SSL_KEY_PASSWORD"
                [[ -f "${SCHEMA_REGISTRY_CERTS_DIR}/ssl.truststore.jks" ]] && schema_registry_conf_set "ssl.truststore.location" "${SCHEMA_REGISTRY_CERTS_DIR}/ssl.truststore.jks"
                [[ -n "$SCHEMA_REGISTRY_SSL_TRUSTSTORE_PASSWORD" ]] && schema_registry_conf_set "ssl.truststore.password" "$SCHEMA_REGISTRY_SSL_TRUSTSTORE_PASSWORD"
            fi
            [[ -n "$SCHEMA_REGISTRY_CLIENT_AUTHENTICATION" ]] && schema_registry_conf_set "ssl.client.authentication" "$SCHEMA_REGISTRY_CLIENT_AUTHENTICATION"
        fi

        # Other settings
        [[ -n "$SCHEMA_REGISTRY_AVRO_COMPATIBILY_LEVEL" ]] && schema_registry_conf_set "schema.compatibility.level" "$SCHEMA_REGISTRY_AVRO_COMPATIBILY_LEVEL"
        [[ -n "$SCHEMA_REGISTRY_DEBUG" ]] && schema_registry_conf_set "debug" "$SCHEMA_REGISTRY_DEBUG"
        schema_registry_conf_set "host.name" "$(schema_registry_hostname)"
    fi
    schema_registry_for_kafka_brokers
}
