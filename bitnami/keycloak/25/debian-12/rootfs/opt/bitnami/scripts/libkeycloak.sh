#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Keycloak library

# shellcheck disable=SC1090,SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Validate settings in KEYCLOAK_* env. variables
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_validate() {
    info "Validating settings in KEYCLOAK_* env vars..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    check_allowed_port() {
        local port_var="${1:?missing port variable}"
        local -a validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        validate_port_args+=("${!port_var}")
        if ! err=$(validate_port "${validate_port_args[@]}"); then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    if ! is_empty_value "$KEYCLOAK_PROXY_HEADERS" && ! [[ "$KEYCLOAK_PROXY_HEADERS" =~ ^(forwarded|xforwarded)$ ]]; then
        print_validation_error "The value of KEYCLOAK_PROXY_HEADERS should be either empty, 'forwarded' or 'xforwarded'"
    fi

    if is_boolean_yes "$KEYCLOAK_ENABLE_HTTPS"; then
        if is_boolean_yes "$KEYCLOAK_HTTPS_USE_PEM"; then
            if is_empty_value "$KEYCLOAK_HTTPS_CERTIFICATE_FILE"; then
                print_validation_error "Path to the TLS certificate not defined. Please set the KEYCLOAK_HTTPS_CERTIFICATE_FILE variable to the mounted PEM certificate"
            fi
            if is_empty_value "$KEYCLOAK_HTTPS_CERTIFICATE_KEY_FILE"; then
                print_validation_error "Path to the TLS key not defined. Please set the KEYCLOAK_HTTPS_CERTIFICATE_KEY_FILE variable to the mounted PEM key"
            fi
        else
            if is_empty_value "$KEYCLOAK_HTTPS_TRUST_STORE_FILE"; then
                print_validation_error "Path to the TLS truststore file not defined. Please set the KEYCLOAK_HTTPS_TRUST_STORE_FILE variable to the mounted truststore"
            fi
            if is_empty_value "$KEYCLOAK_HTTPS_KEY_STORE_FILE"; then
                print_validation_error "Path to the TLS keystore file not defined. Please set the KEYCLOAK_HTTPS_KEY_STORE_FILE variable to the mounted keystore"
            fi
        fi
    fi

    if ! validate_ip "${KEYCLOAK_BIND_ADDRESS}"; then
        if ! is_hostname_resolved "${KEYCLOAK_BIND_ADDRESS}"; then
            print_validation_error print_validation_error "The value for KEYCLOAK_BIND_ADDRESS ($KEYCLOAK_BIND_ADDRESS) should be an IPv4 or IPv6 address, or it must be a resolvable hostname"
        fi
    fi

    if [[ "$KEYCLOAK_HTTP_PORT" -eq "$KEYCLOAK_HTTPS_PORT" ]]; then
        print_validation_error "KEYCLOAK_HTTP_PORT and KEYCLOAK_HTTPS_PORT are bound to the same port!"
    fi
    check_allowed_port KEYCLOAK_HTTP_PORT
    check_allowed_port KEYCLOAK_HTTPS_PORT

    for var in KEYCLOAK_ENABLE_HTTPS KEYCLOAK_ENABLE_STATISTICS KEYCLOAK_ENABLE_HEALTH_ENDPOINTS; do
        if ! is_true_false_value "${!var}"; then
            print_validation_error "The allowed values for $var are [true, false]"
        fi
    done

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Add or modify an entry in the Discourse configuration file
# Globals:
#   KEYCLOAK_*
# Arguments:
#   $1 - Variable name
#   $2 - Value to assign to the variable
# Returns:
#   None
#########################
keycloak_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:-}"
    # Redact sensitive values before outputting to debug log
    local redacted_value="${value}"
    if [[ "${key}" =~ ^(db|https-key-store|https-trust-store|spi-truststore-file)-password$ ]]; then
        redacted_value="_redacted_"
    fi
    debug "Setting ${key} to '${redacted_value}' in Keycloak configuration"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(#\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<<"$key")\s*=\s*(.*)"
    local entry="${key} = ${value}"
    # Check if the configuration exists in the file
    if grep -q -E "$sanitized_pattern" "${KEYCLOAK_CONF_DIR}/${KEYCLOAK_CONF_FILE}"; then
        # It exists, so replace the line
        replace_in_file "${KEYCLOAK_CONF_DIR}/${KEYCLOAK_CONF_FILE}" "$sanitized_pattern" "$entry"
    else
        echo "$entry" >>"${KEYCLOAK_CONF_DIR}/${KEYCLOAK_CONF_FILE}"
    fi
}

########################
# Configure database settings
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_configure_database() {
    local jdbc_params
    jdbc_params="$(echo "$KEYCLOAK_JDBC_PARAMS" | sed -E '/^$|^\&.+$/!s/^/\&/;s/\&/\\&/g')"

    info "Configuring database settings"
    if [[ "${KEYCLOAK_DATABASE_VENDOR}" == "postgresql" ]]; then
        keycloak_conf_set "db" "postgres"
        keycloak_conf_set "db-username" "$KEYCLOAK_DATABASE_USER"
        keycloak_conf_set "db-password" "$KEYCLOAK_DATABASE_PASSWORD"
        keycloak_conf_set "db-url" "jdbc:${KEYCLOAK_JDBC_DRIVER}://${KEYCLOAK_DATABASE_HOST}:${KEYCLOAK_DATABASE_PORT}/${KEYCLOAK_DATABASE_NAME}?currentSchema=${KEYCLOAK_DATABASE_SCHEMA}${jdbc_params}"
    else
        keycloak_conf_set "db" "$KEYCLOAK_DATABASE_VENDOR"
    fi
}

########################
# Configure cluster caching
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_configure_cache() {
    info "Configuring cache count"
    ! is_empty_value "$KEYCLOAK_CACHE_STACK" && keycloak_conf_set "cache-stack" "${KEYCLOAK_CACHE_STACK}"
    ! is_empty_value "$KEYCLOAK_CACHE_CONFIG_FILE" && keycloak_conf_set "cache-config-file" "${KEYCLOAK_CACHE_CONFIG_FILE}"
    keycloak_conf_set "cache" "$KEYCLOAK_CACHE_TYPE"
}

########################
# Enable statistics
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_configure_metrics() {
    info "Enabling statistics"
    keycloak_conf_set "metrics-enabled" "$KEYCLOAK_ENABLE_STATISTICS"
}

########################
# Enable health endpoints
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_configure_health_endpoints() {
    info "Enabling health endpoints"
    keycloak_conf_set "health-enabled" "$KEYCLOAK_ENABLE_HEALTH_ENDPOINTS"
}

########################
# Configure hostname
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_configure_hostname() {
    info "Configuring hostname settings"
    ! is_empty_value "$KEYCLOAK_HOSTNAME" && keycloak_conf_set "hostname" "${KEYCLOAK_HOSTNAME}"
    ! is_empty_value "$KEYCLOAK_HOSTNAME_ADMIN" && keycloak_conf_set "hostname-admin" "${KEYCLOAK_HOSTNAME_ADMIN}"
    keycloak_conf_set "hostname-strict" "${KEYCLOAK_HOSTNAME_STRICT}"
}

########################
# Configure http
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_configure_http() {
    info "Configuring http settings"
    keycloak_conf_set "http-enabled" "true"
    keycloak_conf_set "http-relative-path" "${KEYCLOAK_HTTP_RELATIVE_PATH}"
    keycloak_conf_set "http-port" "${KEYCLOAK_HTTP_PORT}"
    keycloak_conf_set "https-port" "${KEYCLOAK_HTTPS_PORT}"
}

########################
# Configure logging settings
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_configure_loglevel() {
    info "Configuring log level"
    keycloak_conf_set "log-level" "${KEYCLOAK_LOG_LEVEL}"
    keycloak_conf_set "log-console-output" "${KEYCLOAK_LOG_OUTPUT}"
}

########################
# Configure proxy settings using JBoss CLI
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_configure_proxy() {
    info "Configuring proxy"
    keycloak_conf_set "proxy-headers" "${KEYCLOAK_PROXY_HEADERS}"
}

########################
# Configure HTTPS settings
# Globals:
#   KEYCLOAK_*
# Arguments:
# Returns:
#   None
#########################
keycloak_configure_https() {
    info "Configuring Keycloak HTTPS settings"
    if is_boolean_yes "$KEYCLOAK_HTTPS_USE_PEM"; then
        keycloak_conf_set "https-certificate-file" "${KEYCLOAK_HTTPS_CERTIFICATE_FILE}"
        keycloak_conf_set "https-certificate-key-file" "${KEYCLOAK_HTTPS_CERTIFICATE_KEY_FILE}"
    else
        ! is_empty_value "$KEYCLOAK_HTTPS_KEY_STORE_PASSWORD" && keycloak_conf_set "https-key-store-password" "${KEYCLOAK_HTTPS_KEY_STORE_PASSWORD}"
        ! is_empty_value "$KEYCLOAK_HTTPS_TRUST_STORE_PASSWORD" && keycloak_conf_set "https-trust-store-password" "${KEYCLOAK_HTTPS_TRUST_STORE_PASSWORD}"
        keycloak_conf_set "https-key-store-file" "${KEYCLOAK_HTTPS_KEY_STORE_FILE}"
        keycloak_conf_set "https-trust-store-file" "${KEYCLOAK_HTTPS_TRUST_STORE_FILE}"
    fi
}

########################
# Configure SPI TLS settings
# Globals:
#   KEYCLOAK_*
# Arguments:
# Returns:
#   None
#########################
keycloak_configure_spi_tls() {
    info "Configuring Keycloak SPI TLS settings"
    ! is_empty_value "$KEYCLOAK_SPI_TRUSTSTORE_PASSWORD" && keycloak_conf_set "spi-truststore-file-password" "${KEYCLOAK_SPI_TRUSTSTORE_PASSWORD}"
    ! is_empty_value "$KEYCLOAK_SPI_TRUSTSTORE_FILE_HOSTNAME_VERIFICATION_POLICY" && keycloak_conf_set "spi-truststore-file-hostname-verification-policy" "${KEYCLOAK_SPI_TRUSTSTORE_FILE_HOSTNAME_VERIFICATION_POLICY}"
    keycloak_conf_set "spi-truststore-file-file" "${KEYCLOAK_SPI_TRUSTSTORE_FILE}"

}

########################
# Initialize keycloak installation
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_initialize() {
    # Clean to avoid issues when running docker restart
    if [[ "${KEYCLOAK_DATABASE_VENDOR}" == "postgresql" ]]; then
        # Wait for database
        info "Trying to connect to PostgreSQL server $KEYCLOAK_DATABASE_HOST..."
        if ! retry_while "wait-for-port --host $KEYCLOAK_DATABASE_HOST --timeout 10 $KEYCLOAK_DATABASE_PORT" "$KEYCLOAK_INIT_MAX_RETRIES"; then
            error "Unable to connect to host $KEYCLOAK_DATABASE_HOST"
            exit 1
        else
            info "Found PostgreSQL server listening at $KEYCLOAK_DATABASE_HOST:$KEYCLOAK_DATABASE_PORT"
        fi

        if ! is_dir_empty "$KEYCLOAK_MOUNTED_CONF_DIR"; then
            cp -Lr "$KEYCLOAK_MOUNTED_CONF_DIR"/* "$KEYCLOAK_CONF_DIR"
        fi
    fi
    keycloak_configure_database
    keycloak_configure_metrics
    keycloak_configure_health_endpoints
    keycloak_configure_http
    keycloak_configure_hostname
    keycloak_configure_cache
    keycloak_configure_loglevel
    ! is_empty_value "$KEYCLOAK_PROXY_HEADERS" && keycloak_configure_proxy
    is_boolean_yes "$KEYCLOAK_ENABLE_HTTPS" && keycloak_configure_https
    ! is_empty_value "$KEYCLOAK_SPI_TRUSTSTORE_FILE" && keycloak_configure_spi_tls
    true
}

########################
# Run custom initialization scripts
# Globals:
#   KEYCLOAK_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_custom_init_scripts() {
    if [[ -n $(find "${KEYCLOAK_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh") ]] && [[ ! -f "${KEYCLOAK_INITSCRIPTS_DIR}/.user_scripts_initialized" ]]; then
        info "Loading user's custom files from ${KEYCLOAK_INITSCRIPTS_DIR} ..."
        local -r tmp_file="/tmp/filelist"
        find "${KEYCLOAK_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh" | sort >"$tmp_file"
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
        done <$tmp_file
        rm -f "$tmp_file"
        touch "$KEYCLOAK_VOLUME_DIR"/.user_scripts_initialized
    fi
}
