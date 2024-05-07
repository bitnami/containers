#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh

#######################
# Wait until the database is accessible with the currently-known credentials
# Globals:
#   *
# Arguments:
#   $1 - database host
#   $2 - database port
#   $3 - database name
#   $4 - database username
#   $5 - database user password (optional)
# Returns:
#   true if the database connection succeeded, false otherwise
#########################
wait_for_connection() {
    local -r host="${1:?missing database host}"
    local -r port="${2:?missing database port}"
    check_connection() {
        (echo > /dev/tcp/"$host"/"$port") >/dev/null 2>&1
    }
    if ! retry_while "check_connection"; then
        error "Could not connect to the ${host}:${port}"
        return 1
    fi
}

harbor_exporter_validate() {
    debug "Validating settings in HARBOR_* environment variables..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    check_not_empty_value() {
        if is_empty_value "${!1}"; then
            print_validation_error "${1} must be set"
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

    local mandatory=(
        "HARBOR_DATABASE_DBNAME"
        "HARBOR_DATABASE_HOST"
        "HARBOR_DATABASE_USERNAME"
        "HARBOR_DATABASE_SSLMODE"
        "HARBOR_REDIS_NAMESPACE"
        "HARBOR_REDIS_URL"
        "HARBOR_SERVICE_HOST"
    )

    for parameter in "${mandatory[@]}"; do
        check_not_empty_value "$parameter"
    done

    check_resolved_hostname "$HARBOR_DATABASE_HOST"
    check_valid_port "HARBOR_DATABASE_PORT"

    check_multi_value "HARBOR_SERVICE_SCHEME" "http https"
    check_resolved_hostname "$HARBOR_SERVICE_HOST"
    check_valid_port "HARBOR_SERVICE_PORT"

    check_resolved_hostname "$(parse_uri "$HARBOR_REDIS_URL" "host")"

    check_valid_port "HARBOR_EXPORTER_PORT"

    return "$error_code"
}

########################
# Print harbor-exporter runtime environment
# Arguments:
#   None
# Returns:
#   Boolean
#########################
harbor_exporter_print_env() {
    for var in "${!HARBOR_EXPORTER_CFG_@}"; do
        echo "${var/HARBOR_EXPORTER_CFG_/}=${!var}"
    done
}

########################
# Check if harbor-exporter is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_harbor_exporter_running() {
    # harbor-exporter does not create any PID file
    # We regenerate the PID file for each time we query it to avoid getting outdated
    pgrep -f "harbor_exporter" > "$HARBOR_EXPORTER_PID_FILE"

    pid="$(get_pid_from_file "$HARBOR_EXPORTER_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if harbor-exporter is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_harbor_exporter_not_running() {
    ! is_harbor_exporter_running
}

########################
# Stop harbor-exporter
# Arguments:
#   None
# Returns:
#   None
#########################
harbor_exporter_stop() {
    ! is_harbor_exporter_running && return
    stop_service_using_pid "$HARBOR_EXPORTER_PID_FILE"
}
