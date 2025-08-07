#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Keycloak library

# shellcheck disable=SC1090,SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Validate settings in KEYCLOAK_*,KC_* env. variables
# Globals:
#   KEYCLOAK_*,KC_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_validate() {
    info "Validating settings in KEYCLOAK_*,KC_* env vars..."
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
    check_allowed_port() {
        local port_var="${1:?missing port variable}"
        local -a validate_port_args=()
        ! am_i_root && validate_port_args+=("-unprivileged")
        validate_port_args+=("${!port_var}")
        if ! err=$(validate_port "${validate_port_args[@]}"); then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }
    check_conflicting_ports() {
        local -r total="$#"
        for i in $(seq 1 "$((total - 1))"); do
            for j in $(seq "$((i + 1))" "$total"); do
                if (("${!i}" == "${!j}")); then
                    print_validation_error "${!i} and ${!j} are bound to the same port"
                fi
            done
        done
    }

    check_true_false_value KEYCLOAK_ENABLE_HTTPS
    if is_boolean_yes "$KEYCLOAK_ENABLE_HTTPS"; then
        if is_boolean_yes "$KEYCLOAK_HTTPS_USE_PEM"; then
            if is_empty_value "$KC_HTTPS_CERTIFICATE_FILE"; then
                print_validation_error "Path to the TLS certificate not defined. Please set the KC_HTTPS_CERTIFICATE_FILE variable to the mounted PEM certificate"
            fi
            if is_empty_value "$KC_HTTPS_CERTIFICATE_KEY_FILE"; then
                print_validation_error "Path to the TLS key not defined. Please set the KC_HTTPS_CERTIFICATE_KEY_FILE variable to the mounted PEM key"
            fi
        else
            if is_empty_value "$KC_HTTPS_TRUST_STORE_FILE"; then
                print_validation_error "Path to the TLS truststore file not defined. Please set the KC_HTTPS_TRUST_STORE_FILE variable to the mounted truststore"
            fi
            if is_empty_value "$KC_HTTPS_KEY_STORE_FILE"; then
                print_validation_error "Path to the TLS keystore file not defined. Please set the KC_HTTPS_KEY_STORE_FILE variable to the mounted keystore"
            fi
        fi
    fi

    check_conflicting_ports KC_HTTP_PORT KC_HTTPS_PORT KC_HTTP_MANAGEMENT_PORT
    for var in KC_HTTP_PORT KC_HTTPS_PORT KC_HTTP_MANAGEMENT_PORT; do
        check_allowed_port "$var"
    done

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Add or modify an entry in the Keycloak configuration file
# Globals:
#   KEYCLOAK_CONF_*
# Arguments:
#   $1 - Variable name
#   $2 - Value to assign to the variable
# Returns:
#   None
#########################
keycloak_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:-}"

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
#   KEYCLOAK_*,KC_DB_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_configure_database() {
    local jdbc_params
    jdbc_params="$(echo "$KEYCLOAK_JDBC_PARAMS" | sed -E '/^$|^\&.+$/!s/^/\&/;s/\&/\\&/g')"

    info "Configuring database settings"
    if [[ "$KC_DB" = "postgres" ]]; then
        # Backwards compatibility with old environment variables
        if [[ -z "${KC_DB_URL:-}" ]]; then
            keycloak_conf_set "db-url" "jdbc:${KEYCLOAK_JDBC_DRIVER}://${KEYCLOAK_DATABASE_HOST}:${KEYCLOAK_DATABASE_PORT}/${KEYCLOAK_DATABASE_NAME}?currentSchema=${KC_DB_SCHEMA}${jdbc_params}"
        fi
    fi
}

########################
# Initialize keycloak installation
# Globals:
#   KEYCLOAK_*,KC_*
# Arguments:
#   None
# Returns:
#   None
#########################
keycloak_initialize() {
    # Clean to avoid issues when running docker restart
    if [[ "$KC_DB" = "postgres" ]]; then
        local db_host db_port
        if [[ -z "${KC_DB_URL:-}" ]]; then
            db_host="$KEYCLOAK_DATABASE_HOST"
            db_port="$KEYCLOAK_DATABASE_PORT"
        else
            # Extract host and port from KC_DB_URL
            db_host="$(echo "$KC_DB_URL" | sed -E 's/.*\/\/([^:]+):([0-9]+).*/\1/')"
            db_port="$(echo "$KC_DB_URL" | sed -E 's/.*\/\/[^:]+:([0-9]+).*/\1/')"
        fi
        # Wait for database
        info "Trying to connect to PostgreSQL server $db_host..."
        if ! retry_while "wait-for-port --host $db_host --timeout 10 $db_port" "$KEYCLOAK_INIT_MAX_RETRIES"; then
            error "Unable to connect to host $db_host"
            exit 1
        else
            info "Found PostgreSQL server listening at $db_host:$db_port"
        fi
    fi
    if ! is_dir_empty "$KEYCLOAK_MOUNTED_CONF_DIR"; then
        cp -Lr "$KEYCLOAK_MOUNTED_CONF_DIR"/* "$KEYCLOAK_CONF_DIR"
        # Add new line to the end of the file to avoid issues when mounting
        # config files with no new line at the end
        echo >> "${KEYCLOAK_CONF_DIR}/${KEYCLOAK_CONF_FILE}"
    fi

    keycloak_configure_database
    true
}

########################
# Run custom initialization scripts
# Globals:
#   KEYCLOAK_INITSCRIPTS_DIR,KEYCLOAK_VOLUME_DIR
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
        touch "${KEYCLOAK_VOLUME_DIR}/.user_scripts_initialized"
    fi
}
