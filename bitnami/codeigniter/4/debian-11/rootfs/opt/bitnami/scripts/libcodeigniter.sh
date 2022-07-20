#!/bin/bash
#
# Bitnami CodeIgniter library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh

# Load database library
.  /opt/bitnami/scripts/libmysqlclient.sh

########################
# Validate settings in CODEIGNITER_* env vars
# Globals:
#   CODEIGNITER_*
# Arguments:
#   None
# Returns:
#   None
#########################
codeigniter_validate() {
    info "Validating settings in CODEIGNITER_* environment variables..."
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
    check_empty_value "CODEIGNITER_PROJECT_NAME"
    check_yes_no_value "CODEIGNITER_SKIP_DATABASE"

    # Database configuration validations
    check_resolved_hostname "$CODEIGNITER_DATABASE_HOST"
    check_valid_port "CODEIGNITER_DATABASE_PORT_NUMBER"
    # Validate credentials
    if is_boolean_yes "${ALLOW_EMPTY_PASSWORD:-}"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD:-}. For safety reasons, do not use this flag in a production environment."
    else
        is_empty_value "$CODEIGNITER_DATABASE_PASSWORD" && print_validation_error "The CODEIGNITER_DATABASE_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
    fi

    return "$error_code"
}

########################
# Ensure the CodeIgniter app is initialized
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   None
#########################
codeigniter_initialize() {
    local project_dir="/app${CODEIGNITER_PROJECT_NAME:+"/${CODEIGNITER_PROJECT_NAME}"}"
    if is_dir_empty "$project_dir"; then
        ensure_dir_exists "$project_dir"
        cd "$project_dir" || return 1

        info "Creating Codeigniter application in ${project_dir}"
        cp -r "${CODEIGNITER_BASE_DIR}/." .

        # We skip the database configuration if it's explicitly mentioned or
        # the skeleton for microservices/API(s) was chosen
        if is_boolean_yes "$CODEIGNITER_SKIP_DATABASE"; then
            info "Skipping database configuration"
        else
            info "Trying to connect to the database server"
            codeigniter_wait_for_mysql_connection "$CODEIGNITER_DATABASE_HOST" "$CODEIGNITER_DATABASE_PORT_NUMBER" "$CODEIGNITER_DATABASE_NAME" "$CODEIGNITER_DATABASE_USER" "$CODEIGNITER_DATABASE_PASSWORD"
            info "Configuring database credentials"
            codeigniter_conf_set "database.default.hostname" "$CODEIGNITER_DATABASE_HOST"
            codeigniter_conf_set "database.default.port" "$CODEIGNITER_DATABASE_PORT_NUMBER"
            codeigniter_conf_set "database.default.database" "$CODEIGNITER_DATABASE_USER"
            codeigniter_conf_set "database.default.username" "$CODEIGNITER_DATABASE_USER"
            codeigniter_conf_set "database.default.password" "$CODEIGNITER_DATABASE_PASSWORD"
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
codeigniter_wait_for_mysql_connection() {
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

########################
# Add or modify an entry in the 'env' configuration file
# Globals:
#   None
# Arguments:
#   $1 - Variable name
#   $2 - Value to assign to the variable
# Returns:
#   None
#########################
codeigniter_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:-}"
    debug "Setting ${key} to '${value}' in the CodeIgniter project 'env' configuration file"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(#\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")=.*"
    local entry="${key}=${value}"
    # Check if the configuration exists in the file
    local conf_file="env"
    if grep -q -E "$sanitized_pattern" "$conf_file"; then
        # It exists, so replace the line
        replace_in_file "$conf_file" "$sanitized_pattern" "$entry"
    else
        # It doesn't exist, so add it as a new line
        cat >> "$conf_file" <<< "$entry"
    fi
}
