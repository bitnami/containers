#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami NATS library

# shellcheck disable=SC1090,SC1091

# Load generic libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libpersistence.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Check if NATS is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_nats_running() {
    local pid

    pid="$(get_pid_from_file "$NATS_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if NATS is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_nats_not_running() {
    ! is_nats_running
}

########################
# Stop NATS
# Arguments:
#   None
# Returns:
#   None
#########################
nats_stop() {
    is_nats_not_running && return
    info "Stopping NATS"
    stop_service_using_pid "$NATS_PID_FILE"
}

########################
# Start NATS in background
# Arguments:
#   None
# Returns:
#   None
#########################
nats_start_bg() {
    local -a args=("-c" "$NATS_CONF_FILE")
    local nats_cmd="nats-server"
    which "$nats_cmd" >/dev/null 2>&1 || nats_cmd="gnatsd"

    is_nats_running && return
    info "Starting NATS in background"
    if am_i_root; then
        run_as_user "$NATS_DAEMON_USER" "$nats_cmd" "${args[@]}" >/dev/null 2>&1 &
    else
        "$nats_cmd" "${args[@]}" >/dev/null 2>&1 &
    fi
    wait_for_log_entry "NATS is fully up and running" "$NATS_LOG_FILE" 36 10
}

########################
# Validate settings in NATS_* env vars
# Globals:
#   NATS_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
nats_validate() {
    debug "Validating settings in NATS_* environment variables..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    check_conflicting_ports() {
        local -r total="$#"
        for i in $(seq 1 "$((total - 1))"); do
            for j in $(seq "$((i + 1))" "$total"); do
                var_i="${!i}"
                var_j="${!j}"
                if [[ -n "${!var_i:-}" ]] && [[ -n "${!var_j:-}" ]] && [[ "${!var_i:-}" -eq "${!var_j:-}" ]]; then
                    print_validation_error "${var_i} and ${var_j} are bound to the same port"
                fi
            done
        done
    }
    check_resolved_hostname() {
        if ! is_hostname_resolved "$1"; then
            warn "Hostname ${1} could not be resolved, this could lead to connection issues"
        fi
    }
    check_empty_value() {
        if is_empty_value "${!1}"; then
            print_validation_error "${1} must be set"
        fi
    }
    check_yes_no_value() {
        if ! is_yes_no_value "${!1}" && ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for ${1} are: yes no"
        fi
    }
    check_valid_port() {
        local port_var="${1:?missing port variable}"
        local err
        if ! err="$(validate_port "${!port_var}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    # Validate bind addresses and ports
    ! is_empty_value "$NATS_BIND_ADDRESS" && ! validate_ipv4 "$NATS_BIND_ADDRESS" && check_resolved_hostname "$NATS_BIND_ADDRESS"
    for port in "NATS_CLIENT_PORT_NUMBER" "NATS_HTTP_PORT_NUMBER" "NATS_HTTPS_PORT_NUMBER" "NATS_CLUSTER_PORT_NUMBER"; do
        ! is_empty_value "${!port}" && check_valid_port "$port"
    done
    check_conflicting_ports "NATS_CLIENT_PORT_NUMBER" "NATS_HTTP_PORT_NUMBER" "NATS_HTTPS_PORT_NUMBER" "NATS_CLUSTER_PORT_NUMBER"

    # Validate NATS security settings
    check_yes_no_value "NATS_ENABLE_AUTH"
    check_yes_no_value "NATS_ENABLE_TLS"
    if is_boolean_yes "$NATS_ENABLE_AUTH" && [[ -z "$NATS_TOKEN" ]]; then
        for var in "NATS_USERNAME" "NATS_PASSWORD"; do
            check_empty_value "$var"
        done
    fi
    if is_boolean_yes "$NATS_ENABLE_TLS"; then
        if [[ ! -f "${NATS_MOUNTED_CONF_DIR}/certs/${NATS_TLS_CRT_FILENAME}" || ! -f "${NATS_MOUNTED_CONF_DIR}/certs/${NATS_TLS_KEY_FILENAME}" ]]; then
            print_validation_error "In order to configure TLS for NATS you must mount your server.crt and server.key certs to the ${NATS_MOUNTED_CONF_DIR}/certs directory."
        fi
    fi

    # Validate NATS cluster settings
    check_yes_no_value "NATS_ENABLE_CLUSTER"
    if is_boolean_yes "$NATS_ENABLE_CLUSTER" && is_boolean_yes "$NATS_ENABLE_AUTH" && [[ -z "$NATS_CLUSTER_TOKEN" ]]; then
        for var in "NATS_CLUSTER_USERNAME" "NATS_CLUSTER_PASSWORD"; do
            check_empty_value "$var"
        done
    fi

    # Validation configuration files
    if [[ -f "${NATS_MOUNTED_CONF_DIR}/${NATS_FILENAME}.conf" ]] || ! is_file_writable "$NATS_CONF_FILE"; then
        warn "A custom configuration file \"${NATS_FILENAME}.conf\" was found or the file is not writable. Configurations based on environment variables will not be applied for this file."
    fi

    return "$error_code"
}

########################
# Ensure NATS is initialized
# Globals:
#   NATS_*
# Arguments:
#   None
# Returns:
#   None
#########################
nats_initialize() {
    info "Initializing NATS"

    # Generate sample certs in case they do not exist
    # Generate SSL certs (without a passphrase)
    if [[ ! -f "$NATS_CONF_DIR/certs/server.crt" ]]; then
        info "Generating sample certificates"
        ensure_dir_exists "${NATS_CONF_DIR}/certs"
        SSL_KEY_FILE="${NATS_CONF_DIR}/certs/server.key"
        SSL_CERT_FILE="${NATS_CONF_DIR}/certs/server.crt"
        SSL_CSR_FILE="${NATS_CONF_DIR}/certs/server.csr"
        SSL_SUBJ="/CN=example.com"
        SSL_EXT="subjectAltName=DNS:example.com,DNS:www.example.com,IP:127.0.0.1"
        rm -f "$SSL_KEY_FILE" "$SSL_CERT_FILE"
        openssl genrsa -out "$SSL_KEY_FILE" 4096
        # OpenSSL version 1.0.x does not use the same parameters as OpenSSL >= 1.1.x
        if [[ "$(openssl version | grep -oE "[0-9]+\.[0-9]+")" == "1.0" ]]; then
            openssl req -new -sha256 -out "$SSL_CSR_FILE" -key "$SSL_KEY_FILE" -nodes -subj "$SSL_SUBJ"
        else
            openssl req -new -sha256 -out "$SSL_CSR_FILE" -key "$SSL_KEY_FILE" -nodes -subj "$SSL_SUBJ" -addext "$SSL_EXT"
        fi
        openssl x509 -req -sha256 -in "$SSL_CSR_FILE" -signkey "$SSL_KEY_FILE" -out "$SSL_CERT_FILE" -days 1825 -extfile <(echo -n "$SSL_EXT")
        rm -f "$SSL_CSR_FILE"
    fi

    # Ensure NATS daemon user has proper permissions on data directory when runnint container as "root"
    if am_i_root; then
        info "Configuring file permissions for NATS"
        is_mounted_dir_empty "$NATS_DATA_DIR" && configure_permissions_ownership "$NATS_DATA_DIR" -d "755" -f "644" -u "$NATS_DAEMON_USER" -g "$NATS_DAEMON_GROUP"
    fi

    # Check for mounted configuration files and cert files
    if ! is_dir_empty "$NATS_MOUNTED_CONF_DIR"; then
        info "Custom configuration files detected, using them"
        cp -Lr "$NATS_MOUNTED_CONF_DIR"/* "$NATS_CONF_DIR"
    fi

    if [[ ! -f "${NATS_MOUNTED_CONF_DIR}/${NATS_FILENAME}.conf" ]] && is_file_writable "$NATS_CONF_FILE"; then
        local -a routes
        read -r -a routes <<< "$(tr ',;' ' ' <<< "${NATS_CLUSTER_ROUTES}")"
        [[ -n "$NATS_CLUSTER_SEED_NODE" ]] && routes+=("nats://${NATS_CLUSTER_USERNAME}:${NATS_CLUSTER_PASSWORD}@${NATS_CLUSTER_SEED_NODE}:${NATS_CLUSTER_PORT_NUMBER}")
        info "Generating config file based one environment variables settings"
        # ref: https://docs.nats.io/nats-streaming-server/configuring/cfgfile
        enable_auth="$(is_boolean_yes "$NATS_ENABLE_AUTH" && echo true)" \
            token="$([[ -n "$NATS_TOKEN" ]] && echo true)" \
            enable_tls="$(is_boolean_yes "$NATS_ENABLE_TLS" && echo true)" \
            enable_cluster="$(is_boolean_yes "$NATS_ENABLE_CLUSTER" && echo true)" \
            cluster_token="$([[ -n "$NATS_CLUSTER_TOKEN" ]] && echo true)" \
            cluster_routes="$([[ "${#routes[@]}" -gt 0 ]] && printf '%s\n' "${routes[@]}")" \
            render-template "${BITNAMI_ROOT_DIR}/scripts/nats/bitnami-templates/server.conf.tpl" > "$NATS_CONF_FILE"
    fi

    true
}

########################
# Run custom initialization scripts
# Globals:
#   NATS_*
# Arguments:
#   None
# Returns:
#   None
#########################
nats_custom_init_scripts() {
    if [[ -n $(find "${NATS_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh") ]] && [[ ! -f "${NATS_VOLUME_DIR}/.user_scripts_initialized" ]] ; then
        info "Loading user's custom files from \"${NATS_INITSCRIPTS_DIR}\"";
        local -r tmp_file="/tmp/filelist"
        find "${NATS_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh" | sort >"$tmp_file"
        while read -r f; do
            case "$f" in
            *.sh)
                if [[ -x "$f" ]]; then
                    debug "Executing $f"
                    "$f"
                else
                    debug "Sourcing $f"
                    . "$f"
                fi
                ;;
            *) debug "Ignoring $f" ;;
            esac
        done <"$tmp_file"
        rm -f "$tmp_file"
        touch "${NATS_VOLUME_DIR}/.user_scripts_initialized"
    fi
}
