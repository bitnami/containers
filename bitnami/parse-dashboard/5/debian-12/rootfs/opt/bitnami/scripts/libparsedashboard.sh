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

########################
# Validate settings in PARSE_DASHBOARD_* env vars
# Globals:
#   PARSE_DASHBOARD_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
parse_dashboard_validate() {
    debug "Validating settings in parse_dashboard_* environment variables..."
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

    check_empty_value "PARSE_DASHBOARD_PARSE_APP_ID"
    check_empty_value "PARSE_DASHBOARD_APP_NAME"
    check_empty_value "PARSE_DASHBOARD_PARSE_MASTER_KEY"
    check_empty_value "PARSE_DASHBOARD_PARSE_MOUNT_PATH"
    check_multi_value "PARSE_DASHBOARD_PARSE_PROTOCOL" "http https"
    check_empty_value "PARSE_DASHBOARD_USERNAME"
    check_empty_value "PARSE_DASHBOARD_PASSWORD"
    ! is_empty_value "$PARSE_DASHBOARD_PARSE_HOST" && check_resolved_hostname "$PARSE_DASHBOARD_PARSE_HOST"
    ! is_empty_value "$PARSE_DASHBOARD_ENABLE_HTTPS" && check_yes_no_value "PARSE_DASHBOARD_ENABLE_HTTPS"
    ! is_empty_value "$PARSE_DASHBOARD_PORT_NUMBER" && check_valid_port "PARSE_DASHBOARD_PORT_NUMBER"
    ! is_empty_value "$PARSE_DASHBOARD_PARSE_PORT_NUMBER" && check_valid_port "PARSE_DASHBOARD_PARSE_PORT_NUMBER"
    ! is_empty_value "$PARSE_DASHBOARD_EXTERNAL_HTTPS_PORT_NUMBER" && check_valid_port "PARSE_DASHBOARD_EXTERNAL_HTTPS_PORT_NUMBER"
    ! is_empty_value "$PARSE_DASHBOARD_EXTERNAL_HTTP_PORT_NUMBER" && check_valid_port "PARSE_DASHBOARD_EXTERNAL_HTTP_PORT_NUMBER"

    return "$error_code"
}

########################
# Ensure Parse Dashboard is initialized
# Globals:
#   PARSE_DASHBOARD_*
# Arguments:
#   None
# Returns:
#   None
#########################
parse_dashboard_initialize() {
    local -r persisted_conf_file="/bitnami/parse-dashboard/config.json"
    if ! [[ -f "$persisted_conf_file" ]] || is_boolean_yes "$PARSE_DASHBOARD_FORCE_OVERWRITE_CONF_FILE"; then
        # Ensure Parse persisted directories exist (i.e. when a volume has been mounted to /bitnami)
        info "Ensuring Parse directories exist"
        ensure_dir_exists "$PARSE_DASHBOARD_VOLUME_DIR"
        # Use daemon:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$PARSE_DASHBOARD_VOLUME_DIR" -d "775" -f "664" -u "$PARSE_DASHBOARD_DAEMON_USER" -g "root"
        local -r parse_url="${PARSE_DASHBOARD_PARSE_PROTOCOL}://${PARSE_DASHBOARD_PARSE_HOST}:${PARSE_DASHBOARD_PARSE_PORT_NUMBER}${PARSE_DASHBOARD_PARSE_MOUNT_PATH}"
        # Configure Parse Dashboard using a configuration file
        # Based on https://github.com/parse-community/parse-dashboard#configuring-parse-dashboard
        info "Configuring Parse Dashboard with settings provided via environment variables"
        # We create a skeleton so jq works without issues when adding sections and values
        echo '{"apps": [{}], "users": [{}]}' >"$PARSE_DASHBOARD_CONF_FILE"
        parse_dashboard_conf_set "apps[0].serverURL" "$parse_url"
        parse_dashboard_conf_set "apps[0].masterKey" "$PARSE_DASHBOARD_PARSE_MASTER_KEY"
        parse_dashboard_conf_set "apps[0].appId" "$PARSE_DASHBOARD_PARSE_APP_ID"
        parse_dashboard_conf_set "apps[0].appName" "$PARSE_DASHBOARD_APP_NAME"
        parse_dashboard_conf_set "users[0].user" "$PARSE_DASHBOARD_USERNAME"
        parse_dashboard_conf_set "users[0].pass" "$PARSE_DASHBOARD_PASSWORD"
    else
        warn "Parse Dashboard config.json detected in persistence. Persisting configuration files is deprecated"
        cp "$persisted_conf_file" "$PARSE_DASHBOARD_CONF_FILE"
        local -r parse_url="$(parse_dashboard_conf_get "apps[0].serverURL")"
        info "Trying to connect to the Parse server ${parse_url}"
        parse_dashboard_wait_for_parse_connection "$parse_url"
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Add or modify an entry in the Parse Dashboard configuration file
# Globals:
#   PARSE_DASHBOARD_*
# Arguments:
#   $1 - Variable name
#   $2 - Value to assign to the variable
#   $3 - YAML type (string, int or bool)
# Returns:
#   None
#########################
parse_dashboard_conf_set() {
    local -r key="${1:?Missing key}"
    local -r value="${2:-}"
    local -r type="${3:-string}"
    local -r tempfile=$(mktemp)

    case "$type" in
    string)
        jq "(.${key}) |= \"${value}\"" "$PARSE_DASHBOARD_CONF_FILE" >"$tempfile"
        ;;
    int)
        jq "(.${key}) |= (\"${value}\" | tonumber)" "$PARSE_DASHBOARD_CONF_FILE" >"$tempfile"
        ;;
    bool)
        jq "(.${key}) |= (\"${value}\" | test(\"true\"))" "$PARSE_DASHBOARD_CONF_FILE" >"$tempfile"
        ;;
    *)
        error "Type unknown: ${type}"
        return 1
        ;;
    esac
    cp "$tempfile" "$PARSE_DASHBOARD_CONF_FILE"
}

########################
# Get an entry from the Parse Dashboard configuration file
# Globals:
#   PARSE_DASHBOARD_*
# Arguments:
#   $1 - Variable name
# Returns:
#   None
#########################
parse_dashboard_conf_get() {
    local -r key="${1:?key missing}"
    debug "Getting ${key} from Parse configuration"
    jq ".${key}" "$PARSE_DASHBOARD_CONF_FILE"
}

########################
# Wait until Parse is accessible with the currently-known credentials
# Globals:
#   *
# Arguments:
#   $1 - Parse URL
# Returns:
#   true if the database connection succeeded, false otherwise
#########################
parse_dashboard_wait_for_parse_connection() {
    local -r host="${1:?missing connection string}"
    # Using the health API endpoint to check that Parse works
    # https://github.com/parse-community/parse-server/blob/release/src/ParseServer.js#L168
    check_parse_connection() {
        local -r curl_args=("-k" "--header" "X-Parse-Application-Id: ${PARSE_DASHBOARD_PARSE_APP_ID}" "${host}/health")
        local -r res="$(curl "${curl_args[@]}" 2>&1)"
        debug "$res"
        echo "$res"
    }
    if ! retry_while "check_parse_connection"; then
        error "Could not connect to Parse"
        return 1
    fi
}

########################
# Check if Parse Dashboard is running
# Globals:
#   PARSE_DASHBOARD_PID_FILE
# Arguments:
#   None
# Returns:
#   Whether Parse Dashboard is running
########################
is_parse_dashboard_running() {
    local pid
    pid="$(get_pid_from_file "$PARSE_DASHBOARD_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if Parse Dashboard is not running
# Globals:
#   PARSE_DASHBOARD_PID_FILE
# Arguments:
#   None
# Returns:
#   Whether Parse Dashboard is not running
########################
is_parse_dashboard_not_running() {
    ! is_parse_dashboard_running
}

########################
# Stop Parse Dashboard daemon
# Arguments:
#   None
# Returns:
#   None
#########################
parse_dashboard_stop() {
    ! is_parse_dashboard_running && return
    info "Stopping Parse Dashboard"
    stop_service_using_pid "$PARSE_DASHBOARD_PID_FILE"
}
