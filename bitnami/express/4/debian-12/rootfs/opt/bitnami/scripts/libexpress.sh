#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Express library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh

########################
# Validate settings in EXPRESS_* env vars
# Globals:
#   EXPRESS_*
# Arguments:
#   None
# Returns:
#   None
#########################
express_validate() {
    info "Validating settings in EXPRESS_* environment variables..."
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
        if ! is_yes_no_value "${!1}" && ! is_true_false_value "${!1}" && ! is_1_0_value "${!1}"; then
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
    check_yes_no_value "EXPRESS_SKIP_DATABASE_WAIT"
    check_yes_no_value "EXPRESS_SKIP_DATABASE_MIGRATE"
    check_yes_no_value "EXPRESS_SKIP_SAMPLE_CODE"
    check_yes_no_value "EXPRESS_SKIP_NPM_INSTALL"
    check_yes_no_value "EXPRESS_SKIP_BOWER_INSTALL"

    # Autodetect database type and populate environment variables if they were not defined
    local -a supported_database_types=("mariadb" "mongodb" "mysql" "postgresql")
    if is_empty_value "$EXPRESS_DATABASE_TYPE"; then
        warn "EXPRESS_DATABASE_TYPE was not set, the database type will be detected automatically"
        for database_type in "${supported_database_types[@]}"; do
            if getent hosts "$database_type" >/dev/null; then
                debug "Detected database type ${database_type}"
                EXPRESS_DATABASE_TYPE="$database_type"
                EXPRESS_DATABASE_HOST="${EXPRESS_DATABASE_HOST:-"$database_type"}"
                local db_port_var="EXPRESS_DEFAULT_${database_type^^}_DATABASE_PORT_NUMBER"
                EXPRESS_DATABASE_PORT_NUMBER="${EXPRESS_DATABASE_PORT_NUMBER:-"${!db_port_var}"}"
                break
            fi
        done
    else
        check_multi_value "EXPRESS_DATABASE_TYPE" "${supported_database_types[*]}"
    fi

    if is_empty_value "$EXPRESS_DATABASE_TYPE"; then
        if is_empty_value "$EXPRESS_SKIP_DATABASE_WAIT"; then
            print_validation_error "Could not detect database type"
        else
            warn "Could not detect database type, database support will not be configured"
        fi
    else
        check_resolved_hostname "$EXPRESS_DATABASE_HOST"
        check_valid_port "EXPRESS_DATABASE_PORT_NUMBER"
    fi

    return "$error_code"
}

########################
# Ensure the Express app is initialized
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#########################
express_initialize() {
    # Developers use the /app mountpoint
    if is_dir_empty "/app"; then
        info "Creating Express application in /app"
        cd /app || return 1
        debug_execute express . -f
        mkdir tmp logs
        chmod og+rw -R tmp logs
        # Copy .gitignore sample
        cp /dist/.gitignore .gitignore

        if ! is_empty_value "$EXPRESS_DATABASE_TYPE"; then
            info "Adding database support"
            case "$EXPRESS_DATABASE_TYPE" in
                mariadb|mysql)
                    npm ls mysql >/dev/null || debug_execute npm install --save mysql
                    ;;
                mongodb)
                    npm ls mongodb >/dev/null || debug_execute npm install --save mongodb
                    ;;
                postgresql)
                    npm ls pg pg-hstore >/dev/null || debug_execute npm install --save pg pg-hstore
                    ;;
            esac
        fi

        if is_boolean_yes "$EXPRESS_SKIP_DATABASE_WAIT"; then
            info "Not waiting for the database to be available"
        else
            info "Trying to connect to the database server"
            if ! retry_while "debug_execute wait-for-port --timeout 5 --host ${EXPRESS_DATABASE_HOST} ${EXPRESS_DATABASE_PORT_NUMBER}"; then
                error "Could not connect to the database"
                return 1
            fi
        fi

        info "Configuring nodemon support"
        debug_execute npm install nodemon --save-dev
        replace_in_file package.json '"start".*' '"start": "node ./bin/www", "development": "nodemon ./bin/www"'

        if ! is_boolean_yes "$EXPRESS_SKIP_SAMPLE_CODE"; then
            info "Adding dist samples"
            cp -r /dist/samples .
        fi

        if [[ ! -f Dockerfile ]]; then
            info "Adding Dockerfile"
            cp /dist/Dockerfile.tpl Dockerfile
            sed -i 's/{{APP_VERSION}}/'"$APP_VERSION"'/g' Dockerfile
            [[ ! -f bower.json ]] && sed -i '/^RUN bower install/d' Dockerfile

            if [[ ! -f .dockerignore ]]; then
                cp /dist/.dockerignore .
            fi
        fi

        if ! is_boolean_yes "$EXPRESS_SKIP_NPM_INSTALL"; then
            info "Installing npm dependencies"
            debug_execute npm install
        fi

        if ! is_boolean_yes "$EXPRESS_SKIP_BOWER_INSTALL" && [[ -f bower.json ]]; then
            info "Installing bower dependencies"
            debug_execute bower install
        fi

        if ! is_boolean_yes "$EXPRESS_SKIP_DATABASE_MIGRATE" && [[ -f .sequelizerc ]]; then
            info "Applying database migrations (sequelize db:migrate)"
            debug_execute sequelize db:migrate
        fi
    else
        info "An existing project was detected, skipping project creation"
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}
