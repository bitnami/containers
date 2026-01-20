#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami WildFly library

# shellcheck disable=SC1091

# Load generic libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libpersistence.sh

########################
# Check if WildFly is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_wildfly_running() {
    local pid
    pid="$(get_pid_from_file "$WILDFLY_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if WildFly is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_wildfly_not_running() {
    ! is_wildfly_running
}

########################
# Stop WildFly
# Arguments:
#   None
# Returns:
#   None
#########################
wildfly_stop() {
    is_wildfly_not_running && return
    info "Stopping WildFly"
    stop_service_using_pid "$WILDFLY_PID_FILE"
}

########################
# Validate settings in WILDFLY_* env vars
# Globals:
#   WILDFLY_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
wildfly_validate() {
    debug "Validating settings in WILDFLY_* environment variables..."
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
    check_empty_value() {
        if is_empty_value "${!1}"; then
            print_validation_error "${1} must be set"
        fi
    }
    check_valid_port() {
        local port_var="${1:?missing port variable}"
        local err
        if ! err="$(validate_port "${!port_var}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    # Warn users in case the configuration file is not writable
    is_file_writable "$WILDFLY_CONF_FILE" || warn "The WildFly configuration file '${WILDFLY_CONF_FILE}' is not writable. Configurations based on environment variables will not be applied for this file."

    # Validate user inputs
    ! is_empty_value "$WILDFLY_HTTP_PORT_NUMBER" && check_valid_port "WILDFLY_HTTP_PORT_NUMBER"
    ! is_empty_value "$WILDFLY_AJP_PORT_NUMBER" && check_valid_port "WILDFLY_AJP_PORT_NUMBER"
    ! is_empty_value "$WILDFLY_MANAGEMENT_PORT_NUMBER" && check_valid_port "WILDFLY_MANAGEMENT_PORT_NUMBER"
    check_conflicting_ports "WILDFLY_HTTP_PORT_NUMBER" "WILDFLY_AJP_PORT_NUMBER" "WILDFLY_MANAGEMENT_PORT_NUMBER"

    # Validate credentials
    check_empty_value "WILDFLY_PASSWORD"

    if [[ "${#WILDFLY_PASSWORD}" -lt 8 ]]; then
        print_validation_error "The admin password must be at least 8 characters long. Set the environment variable WILDFLY_PASSWORD with a longer value"
    fi

    return "$error_code"
}

########################
# Set a configuration setting value to standalone.xml
# Globals:
#   WILDFLY_CONF_FILE
# Arguments:
#   $1 - key
#   $2 - value
# Returns:
#   None
#########################
wildfly_conf_set() {
    local key="${1:?missing key}"
    local value="${2:?missing value}"

    replace_in_file "$WILDFLY_CONF_FILE" "\{${key}:.*\}" "\{${key}:${value}\}"
}

########################
# Uses the add-user utility to add WildFLy user
# ref: https://docs.wildfly.org/23/Admin_Guide.html#add-user-utility
# Globals:
#   WILDFLY_*_DIR
# Arguments:
#   $1 - user
#   $2 - password
# Returns:
#   None
#########################
wildfly_add_user() {
    local user="${1:?missing user}"
    local password="${2:?missing password}"

    args=(
        "-cw"                              # Automatically confirm warning in interactive mode
        "-u" "$user"                       # Name of the user
        "-p" "$password"                   # Password of the user
        "-sc" "$WILDFLY_CONF_DIR"          # Location of the server config directory
    )
    if am_i_root; then
        debug_execute run_as_user "$WILDFLY_DAEMON_USER" "${WILDFLY_BIN_DIR}/add-user.sh" "${args[@]}"
    else
        debug_execute "${WILDFLY_BIN_DIR}/add-user.sh" "${args[@]}"
    fi
}

########################
# Ensure WildFly is initialized
# Globals:
#   WILDFLY_*
# Arguments:
#   None
# Returns:
#   None
#########################
wildfly_initialize() {
    local -r server_addr="${WILDFLY_SERVER_LISTEN_ADDRESS:-"$WILDFLY_DEFAULT_SERVER_LISTEN_ADDRESS"}"
    local -r mgm_addr="${WILDFLY_MANAGEMENT_LISTEN_ADDRESS:-"$WILDFLY_DEFAULT_MANAGEMENT_LISTEN_ADDRESS"}"
    local -r http_port="${WILDFLY_HTTP_PORT_NUMBER:-"$WILDFLY_DEFAULT_HTTP_PORT_NUMBER"}"
    local -r https_port="${WILDFLY_HTTPS_PORT_NUMBER:-"$WILDFLY_DEFAULT_HTTPS_PORT_NUMBER"}"
    local -r ajp_port="${WILDFLY_AJP_PORT_NUMBER:-"$WILDFLY_DEFAULT_AJP_PORT_NUMBER"}"
    local -r mgm_port="${WILDFLY_MANAGEMENT_PORT_NUMBER:-"$WILDFLY_DEFAULT_MANAGEMENT_PORT_NUMBER"}"

    if am_i_root; then
        # Ensure WildFly daemon user has proper permissions on required directories
        info "Configuring file permissions for WildFly"
        for dir in "${WILDFLY_BASE_DIR}/domain" "${WILDFLY_BASE_DIR}/standalone"; do
            is_mounted_dir_empty "$dir" && configure_permissions_ownership "$dir" -d "755" -f "644" -u "$WILDFLY_DAEMON_USER" -g "$WILDFLY_DAEMON_GROUP"
        done
    fi

    if ! is_mounted_dir_empty "$WILDFLY_MOUNTED_CONF_DIR"; then
        cp -Lr "$WILDFLY_MOUNTED_CONF_DIR"/* "$WILDFLY_CONF_DIR"
    fi

    if [[ -f "${WILDFLY_MOUNTED_CONF_DIR}/standalone.xml" ]]; then
        debug "Injected configuration file found. Skipping default configuration"
    else
        info "Adapting WildFly configuration file"
        wildfly_conf_set "jboss.bind.address" "${server_addr}"
        wildfly_conf_set "jboss.http.port" "${http_port}"
        wildfly_conf_set "jboss.https.port" "${https_port}"
        wildfly_conf_set "jboss.ajp.port" "${ajp_port}"
        wildfly_conf_set "jboss.management.http.port" "${mgm_port}"
        wildfly_conf_set "jboss.bind.address.management" "${mgm_addr}"
    fi

    if [[ -f "${WILDFLY_MOUNTED_CONF_DIR}/mgmt-users.properties" ]]; then
        debug "Injected mgmt-user.properties file found. Skipping admin user creation"
    else
        info "Creating WildFly admin user"
        wildfly_add_user "$WILDFLY_USERNAME" "$WILDFLY_PASSWORD"
    fi
    if ! grep -q "JBOSS_PIDFILE" "${WILDFLY_BIN_DIR}/standalone.conf"; then
        info "Configuring WildFly environment"
        cat >> "${WILDFLY_BIN_DIR}/standalone.conf" << EOF
JAVA_HOME=${JAVA_HOME}
JRE_HOME=${JAVA_HOME}
JAVA_OPTS="\$JAVA_OPTS ${JAVA_OPTS}"
JBOSS_PIDFILE=${WILDFLY_PID_FILE}
EOF
    fi
    true
}
