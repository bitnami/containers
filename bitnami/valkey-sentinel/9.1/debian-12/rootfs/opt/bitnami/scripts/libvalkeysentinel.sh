#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Valkey Sentinel library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

# Functions

########################
# Set a configuration setting value
# Globals:
#   VALKEY_SENTINEL_CONF_FILE
# Arguments:
#   $1 - key
#   $2 - value
# Returns:
#   None
#########################
valkey_conf_set() {
    local key="${1:?missing key}"
    local value="${2:-}"

    # Sanitize inputs
    value="${value//\\/\\\\}"
    value="${value//&/\\&}"
    value="${value//\?/\\?}"
    [[ "$value" = "" ]] && value="\"$value\""

    if grep -q "^\s*$key .*" "$VALKEY_SENTINEL_CONF_FILE"; then
        replace_in_file "$VALKEY_SENTINEL_CONF_FILE" "^\s*${key} .*" "${key} ${value}" false
    else
        printf '\n%s %s' "$key" "$value" >>"$VALKEY_SENTINEL_CONF_FILE"
    fi
}

########################
# Validate settings in VALKEY_* env vars
# Globals:
#   VALKEY_*
# Arguments:
#   None
# Returns:
#   None
#########################
valkey_validate() {
    debug "Validating settings in VALKEY_* env vars.."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    check_resolved_hostname() {
        if ! is_hostname_resolved "$1"; then
            warn "Hostname ${1} could not be resolved, this could lead to connection issues"
        fi
    }

    check_allowed_port() {
        local validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        if ! err="$(validate_port "${validate_port_args[@]}" "${!1}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${1}: ${err}"
        fi
    }

    [[ -w "$VALKEY_SENTINEL_CONF_FILE" ]] || print_validation_error "The configuration file ${VALKEY_SENTINEL_CONF_FILE} is not writable"

    is_positive_int "$VALKEY_SENTINEL_QUORUM" || print_validation_error "Invalid quorum value (only positive integers allowed)"
    is_positive_int "$VALKEY_SENTINEL_DOWN_AFTER_MILLISECONDS" || print_validation_error "Invalid down-after-milliseconds value (only positive integers allowed)"
    is_positive_int "$VALKEY_SENTINEL_FAILOVER_TIMEOUT" || print_validation_error "Invalid failover-timeout value (only positive integers allowed)"

    if ! is_boolean_yes "$VALKEY_SENTINEL_TLS_ENABLED" || [[ "$VALKEY_SENTINEL_PORT_NUMBER" != "0" ]]; then
        check_allowed_port VALKEY_SENTINEL_PORT_NUMBER
    fi
    check_resolved_hostname "$VALKEY_PRIMARY_HOST"

    if is_boolean_yes "$VALKEY_SENTINEL_TLS_ENABLED"; then
        if [[ "$VALKEY_SENTINEL_PORT_NUMBER" == "$VALKEY_SENTINEL_TLS_PORT_NUMBER" ]] && [[ "$VALKEY_SENTINEL_PORT_NUMBER" != "26379" ]]; then
            # If both ports are assigned the same numbers and they are different to the default settings
            print_validation_error "Environment variables VALKEY_SENTINEL_PORT_NUMBER and VALKEY_SENTINEL_TLS_PORT_NUMBER point to the same port number (${VALKEY_SENTINEL_PORT_NUMBER}). Change one of them or disable non-TLS traffic by setting VALKEY_SENTINEL_PORT_NUMBER=0"
        fi
        if [[ -z "$VALKEY_SENTINEL_TLS_CERT_FILE" ]]; then
            print_validation_error "You must provide a X.509 certificate in order to use TLS"
        elif [[ ! -f "$VALKEY_SENTINEL_TLS_CERT_FILE" ]]; then
            print_validation_error "The X.509 certificate file in the specified path ${VALKEY_SENTINEL_TLS_CERT_FILE} does not exist"
        fi
        if [[ -z "$VALKEY_SENTINEL_TLS_KEY_FILE" ]]; then
            print_validation_error "You must provide a private key in order to use TLS"
        elif [[ ! -f "$VALKEY_SENTINEL_TLS_KEY_FILE" ]]; then
            print_validation_error "The private key file in the specified path ${VALKEY_SENTINEL_TLS_KEY_FILE} does not exist"
        fi
        if [[ -z "$VALKEY_SENTINEL_TLS_CA_FILE" ]]; then
            print_validation_error "You must provide a CA X.509 certificate in order to use TLS"
        elif [[ ! -f "$VALKEY_SENTINEL_TLS_CA_FILE" ]]; then
            print_validation_error "The CA X.509 certificate file in the specified path ${VALKEY_SENTINEL_TLS_CA_FILE} does not exist"
        fi
        if [[ -n "$VALKEY_SENTINEL_TLS_DH_PARAMS_FILE" ]] && [[ ! -f "$VALKEY_SENTINEL_TLS_DH_PARAMS_FILE" ]]; then
            print_validation_error "The DH param file in the specified path ${VALKEY_SENTINEL_TLS_DH_PARAMS_FILE} does not exist"
        fi
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Get Valkey version
# Arguments:
#   None
# Flags:
#   --major - Whether to return only the major version (optional)
#   --minor - Whether to return only the minor version (optional)
#   --patch - Whether to return only the patch version (optional)
# Returns:
#   Valkey version
#########################
valkey_version() {
    local complete_version="true"
    local version

    # Parse optional CLI flags
    if [[ "$#" -gt 0 ]]; then
        case "$1" in
        --major)
            version="1"
            ;;
        --minor)
            version="2"
            ;;
        --patch)
            version="3"
            ;;
        *)
            echo "Invalid command line flag ${1}" >&2
            return 1
            ;;
        esac
        complete_version="false"
    fi
    if "$complete_version"; then
        "${VALKEY_SENTINEL_BIN_DIR}/valkey-cli" --version | grep -E -o "[0-9]+.[0-9]+.[0-9]+"
    else
        "${VALKEY_SENTINEL_BIN_DIR}/valkey-cli" --version | grep -E -o "[0-9]+.[0-9]+.[0-9]+" | grep -E -o "[0-9]" | awk "NR==${version}"
    fi
}

########################
# Check if valkey is running
# Globals:
#   VALKEY_BASE_DIR
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_valkey_sentinel_running() {
    local pid
    pid="$(get_pid_from_file "$VALKEY_SENTINEL_PID_FILE")"

    if [[ -z "$pid" ]]; then
        false
    else
        is_service_running "$pid"
    fi
}

########################
# Check if valkey is not running
# Globals:
#   VALKEY_BASE_DIR
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_valkey_sentinel_not_running() {
    ! is_valkey_sentinel_running
}

########################
# Ensure Valkey is initialized
# Globals:
#   VALKEY_*
# Arguments:
#   None
# Returns:
#   None
#########################
valkey_initialize() {
    info "Initializing Valkey Sentinel..."

    # Give the daemon user appropriate permissions
    if am_i_root; then
        for dir in "$VALKEY_SENTINEL_CONF_DIR" "$VALKEY_SENTINEL_LOG_DIR" "$VALKEY_SENTINEL_TMP_DIR" "$VALKEY_SENTINEL_VOLUME_DIR"; do
            chown -R "${VALKEY_SENTINEL_DAEMON_USER}:${VALKEY_SENTINEL_DAEMON_GROUP}" "$dir"
        done
    fi

    if [[ ! -f "${VALKEY_SENTINEL_VOLUME_DIR}/conf/sentinel.conf" ]]; then
        info "Configuring Valkey Sentinel..."

        [[ -z "$VALKEY_SENTINEL_PASSWORD" ]] || valkey_conf_set "requirepass" "$VALKEY_SENTINEL_PASSWORD"

        # Primary set
        # shellcheck disable=SC2153
        valkey_conf_set "sentinel monitor" "${VALKEY_PRIMARY_SET} ${VALKEY_PRIMARY_HOST} ${VALKEY_PRIMARY_PORT_NUMBER} ${VALKEY_SENTINEL_QUORUM}"
        valkey_conf_set "sentinel down-after-milliseconds" "${VALKEY_PRIMARY_SET} ${VALKEY_SENTINEL_DOWN_AFTER_MILLISECONDS}"
        valkey_conf_set "sentinel failover-timeout" "${VALKEY_PRIMARY_SET} ${VALKEY_SENTINEL_FAILOVER_TIMEOUT}"
        valkey_conf_set "sentinel parallel-syncs" "${VALKEY_PRIMARY_SET} 1"
        [[ -z "$VALKEY_PRIMARY_PASSWORD" ]] || valkey_conf_set "sentinel auth-pass" "${VALKEY_PRIMARY_SET} ${VALKEY_PRIMARY_PASSWORD}"
        [[ -z "$VALKEY_PRIMARY_USER" ]] || valkey_conf_set "sentinel auth-user" "${VALKEY_PRIMARY_SET} ${VALKEY_PRIMARY_USER}"
        [[ -z "$VALKEY_SENTINEL_ANNOUNCE_IP" ]] || valkey_conf_set "sentinel announce-ip" "${VALKEY_SENTINEL_ANNOUNCE_IP}"
        [[ -z "$VALKEY_SENTINEL_ANNOUNCE_PORT" ]] || valkey_conf_set "sentinel announce-port" "${VALKEY_SENTINEL_ANNOUNCE_PORT}"
        # Sentinel's configuration was refactored for Valkey 6.2 and hostname's support now has to be enabled using a configuration parameter
        if { [[ $(valkey_version --major) -ge 6 ]] && [[ $(valkey_version --minor) -ge 2 ]]; } || [[ $(valkey_version --major) -ge 7 ]]; then
            valkey_conf_set "sentinel resolve-hostnames" "${VALKEY_SENTINEL_RESOLVE_HOSTNAMES}"
            valkey_conf_set "sentinel announce-hostnames" "${VALKEY_SENTINEL_ANNOUNCE_HOSTNAMES}"
        fi
        # This directive is only available in Valkey 7
        [[ $(valkey_version --major) -eq 7 ]] && valkey_conf_set "SENTINEL master-reboot-down-after-period" "${VALKEY_PRIMARY_SET} ${VALKEY_SENTINEL_PRIMARY_REBOOT_DOWN_AFTER_PERIOD}"
        [[ $(valkey_version --major) -ge 8 ]] && valkey_conf_set "SENTINEL primary-reboot-down-after-period" "${VALKEY_PRIMARY_SET} ${VALKEY_SENTINEL_PRIMARY_REBOOT_DOWN_AFTER_PERIOD}"

        # Sentinel Configuration (maybe overwritten by more specific init blocks like TLS configuration)
        valkey_conf_set port "$VALKEY_SENTINEL_PORT_NUMBER"

        # TLS configuration
        if is_boolean_yes "$VALKEY_SENTINEL_TLS_ENABLED"; then
            if { [[ "$VALKEY_SENTINEL_PORT_NUMBER" == "26379" ]] || [[ "$VALKEY_SENTINEL_PORT_NUMBER" == "0" ]]; } && [[ "$VALKEY_SENTINEL_TLS_PORT_NUMBER" == "26379" ]]; then
                # If both ports are set to default values, enable TLS traffic only
                valkey_conf_set port 0
                valkey_conf_set tls-port "$VALKEY_SENTINEL_TLS_PORT_NUMBER"
            else
                # Different ports were specified
                valkey_conf_set port "$VALKEY_SENTINEL_PORT_NUMBER"
                valkey_conf_set tls-port "$VALKEY_SENTINEL_TLS_PORT_NUMBER"
            fi
            valkey_conf_set tls-cert-file "$VALKEY_SENTINEL_TLS_CERT_FILE"
            valkey_conf_set tls-key-file "$VALKEY_SENTINEL_TLS_KEY_FILE"
            valkey_conf_set tls-ca-cert-file "$VALKEY_SENTINEL_TLS_CA_FILE"
            [[ -n "$VALKEY_SENTINEL_TLS_DH_PARAMS_FILE" ]] && valkey_conf_set tls-dh-params-file "$VALKEY_SENTINEL_TLS_DH_PARAMS_FILE"
            valkey_conf_set tls-auth-clients "$VALKEY_SENTINEL_TLS_AUTH_CLIENTS"
            valkey_conf_set tls-replication yes
        fi

        cp -pf "$VALKEY_SENTINEL_CONF_FILE" "${VALKEY_SENTINEL_VOLUME_DIR}/conf/sentinel.conf"
    else
        info "Persisted files detected, restoring..."
    fi

    rm -rf "$VALKEY_SENTINEL_CONF_DIR"
    ln -sf "${VALKEY_SENTINEL_VOLUME_DIR}/conf" "$VALKEY_SENTINEL_CONF_DIR"
}
