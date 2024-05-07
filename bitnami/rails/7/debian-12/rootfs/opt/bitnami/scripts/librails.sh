#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Rails library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Validate settings in RAILS_* env vars
# Globals:
#   RAILS_SKIP_ACTIVE_RECORD
#   RAILS_SKIP_DB_SETUP
#   RAILS_SKIP_DB_WAIT
#   RAILS_RETRY_ATTEMPTS
# Arguments:
#   None
# Returns:
#   None
#########################
rails_validate() {
    debug "Validating settings in RAILS_* environment variables..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    check_yes_no_value() {
        if ! is_yes_no_value "${!1}" && ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for $1 are [yes, no]"
        fi
    }
    check_positive_value() {
        if ! is_positive_int "${!1}"; then
            print_validation_error "The variable $1 must be positive integer"
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

    check_yes_no_value RAILS_SKIP_ACTIVE_RECORD
    check_yes_no_value RAILS_SKIP_DB_SETUP
    check_yes_no_value RAILS_SKIP_DB_WAIT
    check_positive_value RAILS_RETRY_ATTEMPTS

    # Skip database intialization
    if is_boolean_yes "$RAILS_SKIP_ACTIVE_RECORD"; then
        RAILS_SKIP_DB_WAIT="yes"
        RAILS_SKIP_DB_SETUP="yes"
    fi

    # Validate database type
    [[ "$RAILS_DATABASE_TYPE" = "mariadb" ]] && RAILS_DATABASE_TYPE=mysql

    # Database configuration validations
    if ! is_boolean_yes "$RAILS_SKIP_DB_WAIT" && ! is_boolean_yes "$RAILS_SKIP_DB_SETUP" && [[ "$RAILS_DATABASE_TYPE" != "sqlite3" ]]; then
        check_resolved_hostname "$RAILS_DATABASE_HOST"
        check_valid_port "RAILS_DATABASE_PORT_NUMBER"
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Ensure the Rails app is initialized
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#########################
rails_initialize() {
    # Initialize Rails project
    if [[ -f "config.ru" ]]; then
        info "Rails project found, skipping creation"
        info "Installing dependencies"
        bundle install
    else
        info "Creating new Rails project"
        if is_boolean_yes "$RAILS_SKIP_ACTIVE_RECORD"; then
            rails new "." --skip-active-record
        else
            rails new "." --database "$RAILS_DATABASE_TYPE"
            # Set up database configuration
            local database_path="$RAILS_DATABASE_NAME"
            [[ "$RAILS_DATABASE_TYPE" = "sqlite3" ]] && database_path="db/${RAILS_DATABASE_NAME}.sqlite3"
            info "Configuring database host to ${RAILS_DATABASE_HOST}"
            replace_in_file "config/database.yml" "host:.*$" "host: ${RAILS_DATABASE_HOST}"
            info "Configuring database name to ${RAILS_DATABASE_NAME}"
            replace_in_file "config/database.yml" "database:.*$" "database: ${database_path}" "1,/test:/ "
        fi
    fi

    # Wait for database and initialize
    is_boolean_yes "$RAILS_SKIP_DB_WAIT" || wait_for_db
    is_boolean_yes "$RAILS_SKIP_DB_SETUP" || initialize_db
}

########################
# Wait for database to be ready
# Globals:
#   RAILS_RETRY_ATTEMPTS
#   RAILS_DATABASE_HOST
#   RAILS_DATABASE_TYPE
#   RAILS_DATABASE_PORT_NUMBER
# Arguments:
#   None
# Returns:
#   None
#########################
wait_for_db() {
    [[ "$RAILS_DATABASE_TYPE" = *"sqlite3"* ]] && return
    info "Connecting to the database at ${RAILS_DATABASE_HOST} (type: ${RAILS_DATABASE_TYPE})"
    if ! retry_while "debug_execute wait-for-port --timeout 5 --host ${RAILS_DATABASE_HOST} ${RAILS_DATABASE_PORT_NUMBER}" "$RAILS_RETRY_ATTEMPTS"; then
        error "Failed to connect to the database at ${RAILS_DATABASE_HOST}"
        return 1
    fi
}

########################
# Initialize database
# Globals:
#   RAILS_RETRY_ATTEMPTS
# Arguments:
#   None
# Returns:
#   None
#########################
initialize_db() {
    # The db:prepare command performs db:create, db:migrate and db:seed only when needed
    # If the database already exists, only db:migrate is run
    info "Initializing database (db:prepare)"
    if ! retry_while "bundle exec rails db:prepare" "$RAILS_RETRY_ATTEMPTS"; then
        error "Failed to create database"
        return 1
    fi
    info "Database was successfully initialized"
}
