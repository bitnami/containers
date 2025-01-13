#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Parse library

# shellcheck disable=SC1091

# Load generic libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libpersistence.sh
. /opt/bitnami/scripts/libservice.sh

# Load database library
if [[ -f /opt/bitnami/scripts/libmongodbclient.sh ]]; then
    . /opt/bitnami/scripts/libmongodbclient.sh
elif [[ -f /opt/bitnami/scripts/libmongodb.sh ]]; then
    . /opt/bitnami/scripts/libmongodb.sh
fi

########################
# Validate settings in PARSE_* env vars
# Globals:
#   PARSE_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
parse_validate() {
    debug "Validating settings in PARSE_* environment variables..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
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
    check_multi_value() {
        if [[ " ${2} " != *" ${!1} "* ]]; then
            print_validation_error "The allowed values for ${1} are: ${2}"
        fi
    }
    check_resolved_hostname() {
        if ! is_hostname_resolved "$1"; then
            warn "Hostname ${1} could not be resolved, this could lead to connection issues"
        fi
    }
    check_valid_port() {
        local port_var="${1:?missing port variable}"
        local err
        if ! err="$(validate_port "${!port_var}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    # Validate user inputs
    check_empty_value "PARSE_BIND_HOST"
    check_empty_value "PARSE_APP_ID"
    check_empty_value "PARSE_MASTER_KEY"
    check_empty_value "PARSE_MOUNT_PATH"
    check_empty_value "PARSE_APP_NAME"
    ! is_empty_value "$PARSE_ENABLE_HTTPS" && check_yes_no_value "PARSE_ENABLE_HTTPS"
    ! is_empty_value "$PARSE_ENABLE_CLOUD_CODE" && check_yes_no_value "PARSE_ENABLE_CLOUD_CODE"
    ! is_empty_value "$PARSE_DATABASE_HOST" && check_resolved_hostname "$PARSE_DATABASE_HOST"
    ! is_empty_value "$PARSE_HOST" && check_resolved_hostname "$PARSE_HOST"
    ! is_empty_value "$PARSE_DATABASE_PORT_NUMBER" && check_valid_port "PARSE_DATABASE_PORT_NUMBER"

    # Validate credentials
    if is_boolean_yes "${ALLOW_EMPTY_PASSWORD:-}"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD:-}. For safety reasons, do not use this flag in a production environment."
    else
        is_empty_value "${PARSE_DATABASE_PASSWORD}" && print_validation_error "The PARSE_DATABASE_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
    fi

    return "$error_code"
}

########################
# Ensure Parse is initialized
# Globals:
#   PARSE_*
# Arguments:
#   None
# Returns:
#   None
#########################
parse_initialize() {
    # In order to maintain backwards compatibility, we check if the config.json is mounted
    local -r persisted_conf_file="/bitnami/parse/config.json"
    if ! [[ -f "$persisted_conf_file" ]] || is_boolean_yes "$PARSE_FORCE_OVERWRITE_CONF_FILE"; then
        # Create configuration file.
        # Based on https://github.com/parse-community/parse-server/blob/master/bootstrap.sh
        info "Ensuring Parse directories exist"
        ensure_dir_exists "$PARSE_VOLUME_DIR"
        # Use daemon:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$PARSE_VOLUME_DIR" -d "775" -f "664" -u "$PARSE_DAEMON_USER" -g "root"
        info "Trying to connect to the database server"
        local -r connection_string="mongodb://${PARSE_DATABASE_USER}:${PARSE_DATABASE_PASSWORD}@${PARSE_DATABASE_HOST}:${PARSE_DATABASE_PORT_NUMBER}/${PARSE_DATABASE_NAME}"
        parse_wait_for_mongodb_connection "$connection_string"

        info "Configuring Parse with settings provided via environment variables"
        echo "{}" >"$PARSE_CONF_FILE"
        parse_conf_set "appId" "$PARSE_APP_ID"
        parse_conf_set "masterKey" "$PARSE_MASTER_KEY"
        parse_conf_set "appName" "$PARSE_APP_NAME"
        parse_conf_set "mountPath" "$PARSE_MOUNT_PATH"
        parse_conf_set "port" "$PARSE_PORT_NUMBER"
        parse_conf_set "host" "$PARSE_BIND_HOST"
        local server_url=""
        if is_boolean_yes "$PARSE_ENABLE_HTTPS"; then
            server_url+="https://"
        else
            server_url+="http://"
        fi
        server_url+="${PARSE_HOST}:${PARSE_PORT_NUMBER}${PARSE_MOUNT_PATH}"

        parse_conf_set "serverURL" "$server_url"
        parse_conf_set "databaseURI" "$connection_string"
        is_boolean_yes "$PARSE_ENABLE_CLOUD_CODE" && parse_conf_set "cloud" "${PARSE_BASE_DIR}/cloud/main.js"
    else
        warn "Parse config.json detected in persistence. Persisting configuration files is deprecated"
        cp "$persisted_conf_file" "$PARSE_CONF_FILE"
        info "Trying to connect to the database server"
        local -r connection_string="$(parse_conf_get "databaseURI")"
        parse_wait_for_mongodb_connection "$connection_string"
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Add or modify an entry in the Parse configuration file
# Globals:
#   PARSE_*
# Arguments:
#   $1 - Variable name
#   $2 - Value to assign to the variable
#   $3 - YAML type (string, int or bool)
# Returns:
#   None
#########################
parse_conf_set() {
    local -r key="${1:?Missing key}"
    local -r value="${2:-}"
    local -r type="${3:-string}"
    local -r tempfile=$(mktemp)

    case "$type" in
    string)
        jq "(.${key}) |= \"${value}\"" "$PARSE_CONF_FILE" >"$tempfile"
        ;;
    int)
        jq "(.${key}) |= (\"${value}\" | tonumber)" "$PARSE_CONF_FILE" >"$tempfile"
        ;;
    bool)
        jq "(.${key}) |= (\"${value}\" | test(\"true\"))" "$PARSE_CONF_FILE" >"$tempfile"
        ;;
    *)
        error "Type unknown: ${type}"
        return 1
        ;;
    esac
    cp "$tempfile" "$PARSE_CONF_FILE"
}

########################
# Get an entry from the Parse configuration file
# Globals:
#   PARSE_*
# Arguments:
#   $1 - Variable name
# Returns:
#   None
#########################
parse_conf_get() {
    local -r key="${1:?key missing}"
    debug "Getting ${key} from Parse configuration"
    jq -r ".${key}" "$PARSE_CONF_FILE"
}

########################
# Wait until the database is accessible with the currently-known credentials
# Globals:
#   *
# Arguments:
#   $1 - connection string
# Returns:
#   true if the database connection succeeded, false otherwise
#########################
parse_wait_for_mongodb_connection() {
    local -r connection_string="${1:?missing connection string}"
    check_mongodb_connection() {
        local -r mongo_args=("$connection_string" "--eval" "db.stats()")
        local -r res=$(mongosh "${mongo_args[@]}")
        debug "$res"
        echo "$res" | grep -q 'ok: 1'
    }
    if ! retry_while "check_mongodb_connection"; then
        error "Could not connect to the database"
        return 1
    fi
}

########################
# Check if Parse is running
# Globals:
#   PARSE_PID_FILE
# Arguments:
#   None
# Returns:
#   Whether Parse is running
########################
is_parse_running() {
    local pid
    pid="$(get_pid_from_file "$PARSE_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if Parse is not running
# Globals:
#   PARSE_PID_FILE
# Arguments:
#   None
# Returns:
#   Whether Parse is not running
########################
is_parse_not_running() {
    ! is_parse_running
}

########################
# Stop Parse daemon
# Arguments:
#   None
# Returns:
#   None
#########################
parse_stop() {
    ! is_parse_running && return
    info "Stopping Parse"
    stop_service_using_pid "$PARSE_PID_FILE"
}
