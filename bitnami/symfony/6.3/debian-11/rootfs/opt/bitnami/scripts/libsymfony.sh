#!/bin/bash
#
# Bitnami Symfony library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh

# Load database library
.  /opt/bitnami/scripts/libmysqlclient.sh

########################
# Validate settings in SYMFONY_* env vars
# Globals:
#   SYMFONY_*
# Arguments:
#   None
# Returns:
#   None
#########################
symfony_validate() {
    info "Validating settings in SYMFONY_* environment variables..."
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
    check_yes_no_value "SYMFONY_SKIP_DATABASE"
    check_empty_value "SYMFONY_PROJECT_SKELETON"

    # Database configuration validations
    check_resolved_hostname "$SYMFONY_DATABASE_HOST"
    check_valid_port "SYMFONY_DATABASE_PORT_NUMBER"
    # Validate credentials
    if is_boolean_yes "${ALLOW_EMPTY_PASSWORD:-}"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD:-}. For safety reasons, do not use this flag in a production environment."
    else
        is_empty_value "$SYMFONY_DATABASE_PASSWORD" && print_validation_error "The SYMFONY_DATABASE_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
    fi

    return "$error_code"
}

########################
# Ensure the Symfony app is initialized
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#########################
symfony_initialize() {
    # Devlopers use the /app mountpoint
    if is_dir_empty "/app"; then
        if [[ -d "${SYMFONY_BASE_DIR}/$(basename "$SYMFONY_PROJECT_SKELETON")" ]]; then
            info "Copying ${SYMFONY_PROJECT_SKELETON} project files to /app"
            cp -Lr --preserve=links "${SYMFONY_BASE_DIR}/$(basename "$SYMFONY_PROJECT_SKELETON")"/. /app
        else
            info "Creating $SYMFONY_PROJECT_SKELETON project at /app"
            debug_execute composer create-project "$SYMFONY_PROJECT_SKELETON" /app
        fi
        # We skip the database configuration if it's explicitly mentioned or
        # the skeleton for microservices/API(s) was chosen
        if is_boolean_yes "$SYMFONY_SKIP_DATABASE"; then
            info "Skipping database configuration"
        else
            info "Trying to connect to the database server"
            symfony_wait_for_mysql_connection "$SYMFONY_DATABASE_HOST" "$SYMFONY_DATABASE_PORT_NUMBER" "$SYMFONY_DATABASE_NAME" "$SYMFONY_DATABASE_USER" "$SYMFONY_DATABASE_PASSWORD"
            # The 'symfony/website-skeleton' already includes the Doctrine libraries
            if [[ "$SYMFONY_PROJECT_SKELETON" != "symfony/website-skeleton" ]]; then
                info "Trying to install required Symfony packs"
                # Install Doctrine libraries, see https://symfony.com/doc/current/doctrine.html
                # The command below could fail if there are incompatibilities between the
                # symfony project and orm-pack, let's allow it to fail
                debug_execute composer require symfony/orm-pack -d /app || true
            fi
            local credentials="$SYMFONY_DATABASE_USER"
            [[ -n "$SYMFONY_DATABASE_PASSWORD" ]] && credentials+=":$SYMFONY_DATABASE_PASSWORD"
            echo "DATABASE_URL=mysql://${credentials}@${SYMFONY_DATABASE_HOST}:${SYMFONY_DATABASE_PORT_NUMBER}/${SYMFONY_DATABASE_NAME}" >> "/app/.env"
        fi
    else
        info "An existing project was detected, skipping project creation"
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
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
symfony_wait_for_mysql_connection() {
    local -r db_host="${1:?missing database host}"
    local -r db_port="${2:?missing database port}"
    local -r db_name="${3:?missing database name}"
    local -r db_user="${4:?missing database user}"
    local -r db_pass="${5:-}"
    debug "Tring to access MariaDB with this info: $db_host $db_port $db_name $db_user $db_pass"
    check_mysql_connection() {
        echo "SELECT 1" | mysql_remote_execute "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
    }
    if ! retry_while "check_mysql_connection"; then
        error "Could not connect to the database"
        return 1
    fi
}
