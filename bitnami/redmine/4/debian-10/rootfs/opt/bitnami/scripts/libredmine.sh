#!/bin/bash
#
# Bitnami Redmine library

# shellcheck disable=SC1091

# Load generic libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libpersistence.sh
. /opt/bitnami/scripts/libservice.sh

# Load database libraries
if [[ -f /opt/bitnami/scripts/libmysqlclient.sh ]]; then
    . /opt/bitnami/scripts/libmysqlclient.sh
elif [[ -f /opt/bitnami/scripts/libmysql.sh ]]; then
    . /opt/bitnami/scripts/libmysql.sh
elif [[ -f /opt/bitnami/scripts/libmariadb.sh ]]; then
    . /opt/bitnami/scripts/libmariadb.sh
fi
if [[ -f /opt/bitnami/scripts/libpostgresqlclient.sh ]]; then
    . /opt/bitnami/scripts/libpostgresqlclient.sh
elif [[ -f /opt/bitnami/scripts/libpostgresql.sh ]]; then
    . /opt/bitnami/scripts/libpostgresql.sh
fi

########################
# Validate settings in REDMINE_* env vars
# Globals:
#   REDMINE_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
redmine_validate() {
    debug "Validating settings in REDMINE_* environment variables..."
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
    ! is_empty_value "$REDMINE_SKIP_BOOTSTRAP" && check_yes_no_value "REDMINE_SKIP_BOOTSTRAP"

    # Support for MariaDB/MySQL and PostgreSQL
    if ! is_empty_value "${REDMINE_DB_POSTGRES:-}"; then
        warn "The environment variable REDMINE_DB_POSTGRES is set. This configuration will be deprecated soon. Please set REDMINE_DATABASE_TYPE=postgresql to avoid errors in the future."
        export REDMINE_DATABASE_TYPE="postgresql"
    elif ! is_empty_value "${REDMINE_DB_MYSQL:-}"; then
        warn "The environment variable REDMINE_DB_MYSQL is set. This configuration will be deprecated soon. Please set REDMINE_DATABASE_TYPE=mariadb to avoid errors in the future."
        export REDMINE_DATABASE_TYPE="mariadb"
    else
        check_multi_value "REDMINE_DATABASE_TYPE" "mariadb mysql postgresql"
    fi
    ! is_empty_value "$REDMINE_DATABASE_HOST" && check_resolved_hostname "$REDMINE_DATABASE_HOST"
    ! is_empty_value "$REDMINE_DATABASE_PORT_NUMBER" && check_valid_port "REDMINE_DATABASE_PORT_NUMBER"

    # Validate credentials
    if is_boolean_yes "${ALLOW_EMPTY_PASSWORD:-}"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD:-}. For safety reasons, do not use this flag in a production environment."
    else
        for empty_env_var in "REDMINE_DATABASE_PASSWORD" "REDMINE_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        done
    fi

    # Validate SMTP credentials
    if ! is_empty_value "$REDMINE_SMTP_HOST"; then
        for empty_env_var in "REDMINE_SMTP_USER" "REDMINE_SMTP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && warn "The ${empty_env_var} environment variable is empty or not set."
        done
        is_empty_value "$REDMINE_SMTP_PORT_NUMBER" && print_validation_error "The REDMINE_SMTP_PORT_NUMBER environment variable is empty or not set."
        ! is_empty_value "$REDMINE_SMTP_PORT_NUMBER" && check_valid_port "REDMINE_SMTP_PORT_NUMBER"
        check_multi_value "REDMINE_SMTP_AUTH" "plain login cram_md5"
        if ! is_empty_value "${SMTP_AUTH:-}"; then
            warn "The environment variable SMTP_TLS is set. This configuration will be deprecated soon. Please set REDMINE_PROTOCOL=tls to avoid errors in the future."
            export REDMINE_SMTP_PROTOCOL="tls"
        else
            ! is_empty_value "$REDMINE_SMTP_PROTOCOL" && check_multi_value "REDMINE_SMTP_PROTOCOL" "ssl tls"
        fi
    fi

    return "$error_code"
}

########################
# Ensure Redmine is initialized
# Globals:
#   REDMINE_*
# Arguments:
#   None
# Returns:
#   None
#########################
redmine_initialize() {
    # Check if Redmine has already been initialized and persisted in a previous run
    local -r app_name="redmine"
    if ! is_app_initialized "$app_name"; then
        local -a db_execute_args=("$REDMINE_DATABASE_HOST" "$REDMINE_DATABASE_PORT_NUMBER" "$REDMINE_DATABASE_NAME" "$REDMINE_DATABASE_USER" "$REDMINE_DATABASE_PASSWORD")

        # Ensure Redmine persisted directories exist (i.e. when a volume has been mounted to /bitnami)
        info "Ensuring Redmine directories exist"
        ensure_dir_exists "$REDMINE_VOLUME_DIR"
        # Use daemon:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$REDMINE_VOLUME_DIR" -d "775" -f "664" -u "$REDMINE_DAEMON_USER" -g "root"

        info "Trying to connect to the database server"
        local db_type="mysql"
        [[ "$REDMINE_DATABASE_TYPE" = "postgresql" ]] && db_type="postgresql"
        "redmine_wait_for_${db_type}_connection" "${db_execute_args[@]}"

        info "Configuring Redmine database connections"
        redmine_db_conf_set "${REDMINE_ENV}.host" "$REDMINE_DATABASE_HOST"
        redmine_db_conf_set "${REDMINE_ENV}.port" "$REDMINE_DATABASE_PORT_NUMBER"
        redmine_db_conf_set "${REDMINE_ENV}.database" "$REDMINE_DATABASE_NAME"
        redmine_db_conf_set "${REDMINE_ENV}.username" "$REDMINE_DATABASE_USER"
        redmine_db_conf_set "${REDMINE_ENV}.password" "$REDMINE_DATABASE_PASSWORD"
        if [[ "$db_type" = "mysql" ]]; then
            redmine_db_conf_set "${REDMINE_ENV}.adapter" "mysql2"
            redmine_db_conf_set "${REDMINE_ENV}.encoding" "utf8mb4"
        elif [[ "$db_type" = "postgresql" ]]; then
            redmine_db_conf_set "${REDMINE_ENV}.adapter" "postgresql"
            redmine_db_conf_set "${REDMINE_ENV}.encoding" "utf8"
        fi

        info "Configuring Redmine application with settings provided via environment variables"
        redmine_conf_set "default_language.default" "$REDMINE_LANGUAGE" "" "${REDMINE_CONF_DIR}/settings.yml"

        # SMTP configuration
        if ! is_empty_value "$REDMINE_SMTP_HOST"; then
            info "Configuring SMTP credentials"
            redmine_conf_set "default.email_delivery.delivery_method" ":smtp"
            redmine_conf_set "default.email_delivery.smtp_settings.address" "$REDMINE_SMTP_HOST"
            redmine_conf_set "default.email_delivery.smtp_settings.port" "$REDMINE_SMTP_PORT_NUMBER"
            redmine_conf_set "default.email_delivery.smtp_settings.authentication" "$REDMINE_SMTP_AUTH"
            redmine_conf_set "default.email_delivery.smtp_settings.user_name" "$REDMINE_SMTP_USER"
            redmine_conf_set "default.email_delivery.smtp_settings.password" "$REDMINE_SMTP_PASSWORD"
            # Remove 'USER@' part from e-mail address and use as domain
            redmine_conf_set "default.email_delivery.smtp_settings.domain" "${REDMINE_SMTP_USER//*@}"
            if [[ "$REDMINE_SMTP_PROTOCOL" = "tls" ]]; then
                redmine_conf_set "default.email_delivery.smtp_settings.enable_starttls_auto" "true"
            else
                redmine_conf_set "default.email_delivery.smtp_settings.enable_starttls_auto" "false"
            fi
        fi

        info "Executing database migrations"
        redmine_migrate_database

        if ! is_boolean_yes "$REDMINE_SKIP_BOOTSTRAP"; then
            # Redmine does not provide a way to update admin credentials via the CLI
            # and the default ones are hardcoded in the '001_setup.rb' migration
            local redmine_password_hash redmine_password_salt
            redmine_password_salt="$(generate_random_string -t alphanumeric -c 32)"
            # The password hashing algorithm consists of executing SHA1(salt + SHA1(password))
            # https://github.com/redmine/redmine/blob/a9aae29708b4c96dbe3756ab791e2c4319dcdfca/app/models/user.rb#L354
            redmine_password_hash="$(generate_sha_hash "${redmine_password_salt}$(generate_sha_hash "$REDMINE_PASSWORD")")"
            info "Updating admin user credentials"
            "${db_type}_remote_execute" "${db_execute_args[@]}" <<EOF
UPDATE users SET login = '${REDMINE_USERNAME}', hashed_password = '${redmine_password_hash}', salt = '${redmine_password_salt}', firstname = '${REDMINE_FIRST_NAME}', lastname = '${REDMINE_LAST_NAME}', must_change_passwd = '0' WHERE id = '1';
UPDATE email_addresses SET address = '${REDMINE_EMAIL}' WHERE id = '1';
EOF

            # This is required to load required configuration data to be able to create projects with issues, bug trackers, etc.
            # If not executed, a warning will appear in the admin panel:
            # "Roles, trackers, issue statuses and workflow have not been configured yet."
            # "It is highly recommended to load the default configuration. You will be able to modify it once loaded."
            if is_boolean_yes "$REDMINE_LOAD_DEFAULT_DATA"; then
                info "Loading default configuration data"
                REDMINE_LANG="$REDMINE_LANGUAGE" redmine_rake_execute "redmine:load_default_data"
            fi
        else
            info "An already initialized Redmine database was provided, skipping admin user creation and default data generation"
        fi

        info "Persisting Redmine installation"
        persist_app "$app_name" "$REDMINE_DATA_TO_PERSIST"
    else
        # Fix to make upgrades from old images work
        # Before, we were persisting 'conf' dir instead of 'config', causing errors when restoring persisted data
        if [[ ! -e "${REDMINE_VOLUME_DIR}/config" && -e "${REDMINE_VOLUME_DIR}/conf" ]]; then
            warn "Detected legacy configuration directory path ${REDMINE_VOLUME_DIR}/conf in volume"
            warn "Creating ${REDMINE_VOLUME_DIR}/config symlink pointing to ${REDMINE_VOLUME_DIR}/conf"
            ln -s "${REDMINE_VOLUME_DIR}/conf" "${REDMINE_VOLUME_DIR}/config"
        fi

        info "Restoring persisted Redmine installation"
        restore_persisted_app "$app_name" "$REDMINE_DATA_TO_PERSIST"

        info "Trying to connect to the database server"
        local db_host db_port db_name db_user db_pass db_adapter db_type
        db_host="$(redmine_db_conf_get "${REDMINE_ENV}.host")"
        db_port="$(redmine_db_conf_get "${REDMINE_ENV}.port")"
        db_name="$(redmine_db_conf_get "${REDMINE_ENV}.database")"
        db_user="$(redmine_db_conf_get "${REDMINE_ENV}.username")"
        db_pass="$(redmine_db_conf_get "${REDMINE_ENV}.password")"
        db_adapter="$(redmine_db_conf_get "${REDMINE_ENV}.adapter")"
        db_type="mysql"
        [[ "$db_adapter" = "postgresql" ]] && db_type="postgresql"
        "redmine_wait_for_${db_type}_connection" "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"

        info "Executing database migrations"
        redmine_migrate_database
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Add or modify an entry in a Redmine configuration file (by default configuration.yml)
# Globals:
#   REDMINE_*
# Arguments:
#   $1 - YAML key to set
#   $2 - Value to assign to the YAML key
#   $3 - YAML tag (e.g. !!int)
#   $4 - File to overwrite
# Returns:
#   None
#########################
redmine_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:-}"
    local -r tag="${3:-!!str}"
    local -r file="${4:-"${REDMINE_CONF_DIR}/configuration.yml"}"
    debug "Setting Redmine configuration value '${key}' to '${value}'"
    yq w --inplace "$file" "$key" --tag "$tag" "$value"
}

########################
# Add or modify an entry in the Redmine database configuration file (database.yml)
# Globals:
#   REDMINE_*
# Arguments:
#   $1 - YAML key to set
#   $2 - Value to assign to the YAML key
#   $3 - YAML tag (e.g. !!int)
# Returns:
#   None
#########################
redmine_db_conf_set() {
    redmine_conf_set "${1:-}" "${2:-}" "${3:-}" "${REDMINE_CONF_DIR}/database.yml"
}

########################
# Get an entry from a Redmine configuration file (by default configuration.yml)
# Globals:
#   REDMINE_*
# Arguments:
#   $1 - Variable name
#   $2 - Configuration file to read
# Returns:
#   None
#########################
redmine_conf_get() {
    local -r key="${1:?key missing}"
    local -r file="${2:-"${REDMINE_CONF_DIR}/configuration.yml"}"
    debug "Getting ${key} from Redmine configuration"
    yq r "$file" "$key"
}

########################
# Get an entry from the Redmine database configuration file
# Globals:
#   REDMINE_*
# Arguments:
#   $1 - Variable name
# Returns:
#   None
#########################
redmine_db_conf_get() {
    redmine_conf_get "${1:-}" "${REDMINE_CONF_DIR}/database.yml"
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
redmine_wait_for_mysql_connection() {
    local -r db_host="${1:?missing database host}"
    local -r db_port="${2:?missing database port}"
    local -r db_name="${3:?missing database name}"
    local -r db_user="${4:?missing database user}"
    local -r db_pass="${5:-}"
    check_mysql_connection() {
        echo "SELECT 1" | mysql_remote_execute "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
    }
    if ! retry_while "check_mysql_connection"; then
        error "Could not connect to the database"
        return 1
    fi
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
redmine_wait_for_postgresql_connection() {
    local -r db_host="${1:?missing database host}"
    local -r db_port="${2:?missing database port}"
    local -r db_name="${3:?missing database name}"
    local -r db_user="${4:?missing database user}"
    local -r db_pass="${5:-}"
    check_postgresql_connection() {
        echo "SELECT 1" | postgresql_remote_execute "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
    }
    if ! retry_while "check_postgresql_connection"; then
        error "Could not connect to the database"
        return 1
    fi
}

########################
# Executes Bundler with the proper environment and the specified arguments and print result to stdout
# Globals:
#   REDMINE_*
# Arguments:
#   $1..$n - Arguments to pass to the CLI call
# Returns:
#   None
#########################
redmine_bundle_execute_print_output() {
    # Avoid creating unnecessary cache files at initialization time
    local -a cmd=("bundle" "exec" "$@")
    # Run as application user to avoid having to change permissions/ownership afterwards
    am_i_root && cmd=("gosu" "$REDMINE_DAEMON_USER" "${cmd[@]}")
    (
        export RAILS_ENV="$REDMINE_ENV"
        cd "$REDMINE_BASE_DIR" || false
        "${cmd[@]}"
    )
}

########################
# Executes Bundler with the proper environment and the specified arguments
# Globals:
#   REDMINE_*
# Arguments:
#   $1..$n - Arguments to pass to the CLI call
# Returns:
#   None
#########################
redmine_bundle_execute() {
    debug_execute redmine_bundle_execute_print_output "$@"
}

########################
# Executes the 'rake' CLI with the proper Bundler environment and the specified arguments and print result to stdout
# Globals:
#   REDMINE_*
# Arguments:
#   $1..$n - Arguments to pass to the CLI call
# Returns:
#   None
#########################
redmine_rake_execute_print_output() {
    redmine_bundle_execute_print_output "rake" "$@"
}

########################
# Executes the 'rake' CLI with the proper Bundler environment and the specified arguments
# Globals:
#   REDMINE_*
# Arguments:
#   $1..$n - Arguments to pass to the CLI call
# Returns:
#   None
#########################
redmine_rake_execute() {
    debug_execute redmine_rake_execute_print_output "$@"
}

########################
# Executes Redmine database migrations
# Globals:
#   REDMINE_*
# Arguments:
#   None
# Returns:
#   None
#########################
redmine_migrate_database() {
    # Secret tokens need to be generated or the migration will fail
    # "Missing `secret_key_base` for 'production' environment, set this string with `rails credentials:edit`"
    # And since we are not persisting that file, they will always need to be generated
    debug "Generating secret tokens"
    redmine_rake_execute "generate_secret_token"

    redmine_rake_execute "db:migrate"
    redmine_rake_execute "redmine:plugins:migrate"
}
