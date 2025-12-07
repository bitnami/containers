#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Solr library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Check if ActiveMQ is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_activemq_running() {
    local pid
    pid="$(get_pid_from_file "$ACTIVEMQ_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if ActiveMQ is running
# Arguments:
#   None
# Returns:
#   Whether ActiveMQ is not running
########################
is_activemq_not_running() {
    ! is_activemq_running
}

########################
# Stop ActiveMQ
# Globals:
#   ACTIVEMQ_*
# Arguments:
#   None
# Returns:
#   None
#########################
activemq_stop() {
    info "Stopping ActiveMQ..."
    ! is_activemq_running && return
    stop_service_using_pid "$ACTIVEMQ_PID_FILE"
}

########################
# Validate settings in ACTIVEMQ_* env vars
# Globals:
#   ACTIVEMQ_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
activemq_validate() {
    debug "Validating settings in ACTIVEMQ_* environment variables..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    check_valid_port() {
        local -r port_var="${1:?missing port variable}"
        local err
        if ! err="$(validate_port "${!port_var}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    for port_to_check in "ACTIVEMQ_OPENWIRE_PORT_NUMBER" "ACTIVEMQ_AQMQ_PORT_NUMBER" "ACTIVEMQ_STOMP_PORT_NUMBER" "ACTIVEMQ_MQTT_PORT_NUMBER" "ACTIVEMQ_WEBSOCKET_PORT_NUMBER" "ACTIVEMQ_HTTP_PORT_NUMBER"; do
        check_valid_port "$port_to_check"
    done

    for empty_env_var in "ACTIVEMQ_USERNAME" "ACTIVEMQ_PASSWORD" "ACTIVEMQ_SECRET"; do
        is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set."
    done

    return "$error_code"
}

########################
# Ensure ActiveMQ is initialized
# Globals:
#   ACTIVEMQ_*
# Arguments:
#   $1- password
#   $2- secret
# Returns:
#   None
#########################
activemq_set_password() {
    local -r password="${1:?password is required}"
    local -r secret="${2:?secret is requires}"
    local encryptedPasswordMatch

    replace_in_file "$ACTIVEMQ_CONF_FILE" "name=\"password\" value=\"\"" "name=\"password\" value=\"${secret}\""

    local -a cmd=("activemq" "encrypt" "--password" "$secret" "--input" "$password")
    am_i_root && cmd=("run_as_user" "$ACTIVEMQ_DAEMON_USER" "${cmd[@]}")
    encryptedPasswordMatch=$("${cmd[@]}" | grep "Encrypted text:")

    is_empty_value "$encryptedPasswordMatch" && error "Execution of activemq encrypt failed" && exit 1

    local -r encryptedPassword="${encryptedPasswordMatch#"Encrypted text: "}"

    replace_in_file "${ACTIVEMQ_CONF_DIR}/users.properties" "admin=.*" "admin=${password}"
    replace_in_file "${ACTIVEMQ_CONF_DIR}/credentials-enc.properties" "activemq.password=.*" "activemq.password=ENC(${encryptedPassword})"
    replace_in_file "${ACTIVEMQ_CONF_DIR}/jmx.password" "admin.*" "admin ${password}"
}

########################
# Ensure ActiveMQ is initialized
# Globals:
#   ACTIVEMQ_*
# Arguments:
#   None
# Returns:
#   None
#########################
activemq_initialize() {
    info "Initializing ActiveMQ ..."

    # Configuring permissions for data folder
    am_i_root && configure_permissions_ownership "$ACTIVEMQ_DATA_DIR" -u "$ACTIVEMQ_DAEMON_USER" -g "$ACTIVEMQ_DAEMON_GROUP" -d "755" -f "644"

    if ! is_mounted_dir_empty "$ACTIVEMQ_MOUNTED_CONF_DIR"; then
        cp -Lr "$ACTIVEMQ_MOUNTED_CONF_DIR"/* "$ACTIVEMQ_CONF_DIR"
    fi

    if [[ -f "${ACTIVEMQ_MOUNTED_CONF_DIR}/activemq.xml" ]]; then
        info "ActiveMQ configuration ${ACTIVEMQ_MOUNTED_CONF_DIR}/activemq.xml detected!"
        info "Deploying ActiveMQ with persisted data"
    else
        info "Creating config file"
        # File obtained from http://svn.apache.org/repos/asf/activemq/trunk/assembly/src/release/conf/activemq.xml
        render-template "${BITNAMI_ROOT_DIR}/scripts/activemq/files/activemq.xml.tpl" > "$ACTIVEMQ_CONF_FILE"

        info "Configuring the admin password"
        activemq_set_password "$ACTIVEMQ_PASSWORD" "$ACTIVEMQ_SECRET"
    fi
}