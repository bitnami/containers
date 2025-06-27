#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Laravel library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Validate settings in LARAVEL_* env vars
# Globals:
#   LARAVEL_*
# Arguments:
#   None
# Returns:
#   None
#########################
laravel_validate() {
    info "Validating settings in LARAVEL_* environment variables..."
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
    check_yes_no_value "LARAVEL_SKIP_COMPOSER_UPDATE"
    check_yes_no_value "LARAVEL_SKIP_DATABASE"

    # Database configuration validations
    check_resolved_hostname "$LARAVEL_DATABASE_HOST"
    check_valid_port "LARAVEL_DATABASE_PORT_NUMBER"

    return "$error_code"
}

########################
# Ensure the Laravel app is initialized
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#########################
laravel_initialize() {
    if is_dir_empty "/app"; then
        info "Creating Laravel application in /app"
        cp -r "${LARAVEL_BASE_DIR}/." .

        info "Regenerating APP_KEY"
        debug_execute php artisan key:generate --ansi

        if ! is_boolean_yes "$LARAVEL_SKIP_COMPOSER_UPDATE"; then
            log "Updating dependencies"
            debug_execute composer update
        fi

        info "Trying to connect to the database server"
        if ! retry_while "debug_execute wait-for-port --timeout 5 --host ${LARAVEL_DATABASE_HOST} ${LARAVEL_DATABASE_PORT_NUMBER}"; then
            error "Could not connect to the database"
            return 1
        fi

        info "Executing database migrations"
        debug_execute php artisan migrate
    else
        info "An existing project was detected, skipping project creation"
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}
