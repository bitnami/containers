#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# Bitnami Superset library

# shellcheck disable=SC1091,SC2153

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libpersistence.sh

# Functions

########################
# Validate Superset inputs
# Globals:
#   SUPERSET_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
superset_validate() {
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    check_multi_value() {
        if [[ " ${2} " != *" ${!1} "* ]]; then
            print_validation_error "The allowed values for ${1} are: ${2}"
        fi
    }
    check_valid_port() {
        local port_var="${1:?missing port variable}"
        local err
        if ! err="$(validate_port "${!port_var}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    # Check postgresql host
    is_empty_value "$SUPERSET_DATABASE_HOST" && print_validation_error "Missing SUPERSET_DATABASE_HOST"

    # Check ports are valid
    ! is_empty_value "$SUPERSET_HTTP_PORT_NUMBER" && check_valid_port "SUPERSET_HTTP_PORT_NUMBER"
    ! is_empty_value "$SUPERSET_WEBSERVER_PORT_NUMBER" && check_valid_port "SUPERSET_WEBSERVER_PORT_NUMBER"
    ! is_empty_value "$SUPERSET_DATABASE_PORT_NUMBER" && check_valid_port "SUPERSET_DATABASE_PORT_NUMBER"
    ! is_empty_value "$REDIS_PORT_NUMBER" && check_valid_port "REDIS_PORT_NUMBER"

    # Check Superset secret key
    if [[ -z "$SUPERSET_SECRET_KEY" ]]; then
        print_validation_error "SUPERSET_SECRET_KEY must be set"
    fi

    # Check Superset node role
    check_multi_value "SUPERSET_ROLE" "webserver celery-worker celery-beat celery-flower init"

    return "$error_code"
}

########################
# Ensure Superset is initialized
# Globals:
#   SUPERSET_*
# Arguments:
#   None
# Returns:
#   None
#########################
superset_initialize() {
    info "Initializing Superset ..."

    # Change permissions if running as root
    for dir in "$SUPERSET_TMP_DIR" "$SUPERSET_LOGS_DIR"; do
        ensure_dir_exists "$dir"
        am_i_root && chown "$SUPERSET_DAEMON_USER:$SUPERSET_DAEMON_GROUP" "$dir"
    done

    true
}

########################
# Run Superset init commands
# Globals:
#   SUPERSET_*
# Arguments:
#   None
# Returns:
#   None
#########################
superset_run_init() {
    # Initialize the database
    info "Applying DB migrations"
    superset_execute db upgrade

    # Initialize database
    info "Setting up roles and perms"
    superset_execute init

    # Create an admin user
    superset_create_admin_user

    if is_boolean_yes "${SUPERSET_LOAD_EXAMPLES}"; then
        info "Loading examples"
        superset_execute load_examples
    fi

    if [[ -f "${SUPERSET_IMPORT_DATASOURCES}" ]]; then
        info "Importing datasources"
        superset_execute import_datasources -p "${SUPERSET_IMPORT_DATASOURCES}"
    fi
}

########################
# Create Superset admin user
# Arguments:
#   None
# Returns:
#   None
#########################
superset_create_admin_user() {
    info "Creating Superset admin user"
    superset_execute fab create-admin --username "${SUPERSET_USERNAME}" --firstname "${SUPERSET_FIRSTNAME}" --lastname "${SUPERSET_LASTNAME}" --email "${SUPERSET_EMAIL}" --password "${SUPERSET_PASSWORD}"
}

########################
# Executes the 'superset' CLI with the specified arguments and print result to stdout/stderr
# Globals:
#   SUPERSET_*
# Arguments:
#   $1..$n - Arguments to pass to the CLI call
# Returns:
#   None
#########################
superset_execute_print_output() {
    # Run as web server user to avoid having to change permissions/ownership afterwards
    if am_i_root; then
        run_as_user "$SUPERSET_DAEMON_USER" superset "$@"
    else
        superset "$@"
    fi
}

########################
# Executes the 'superset' CLI with the specified arguments
# Globals:
#   SUPERSET_*
# Arguments:
#   $1..$n - Arguments to pass to the CLI call
# Returns:
#   None
#########################
superset_execute() {
    debug_execute superset_execute_print_output "$@"
}
