#!/bin/bash
#
# Bitnami DreamFactory library

# shellcheck disable=SC1091

# Load generic libraries
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libpersistence.sh
. /opt/bitnami/scripts/libwebserver.sh
. /opt/bitnami/scripts/libservice.sh

# Load MariaDB database library
if [[ -f /opt/bitnami/scripts/libmysqlclient.sh ]]; then
    . /opt/bitnami/scripts/libmysqlclient.sh
elif [[ -f /opt/bitnami/scripts/libmysql.sh ]]; then
    . /opt/bitnami/scripts/libmysql.sh
elif [[ -f /opt/bitnami/scripts/libmariadb.sh ]]; then
    . /opt/bitnami/scripts/libmariadb.sh
fi

# Load PostgreSQL database library
if [[ -f /opt/bitnami/scripts/libpostgresqlclient.sh ]]; then
    . /opt/bitnami/scripts/libpostgresqlclient.sh
elif [[ -f /opt/bitnami/scripts/libpostgresql.sh ]]; then
    . /opt/bitnami/scripts/libpostgresql.sh
fi

########################
# Validate settings in DREAMFACTORY_* env vars
# Globals:
#   DREAMFACTORY_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
dreamfactory_validate() {
    debug "Validating settings in DREAMFACTORY_* environment variables..."
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
    check_empty_password() {
        local empty_env_var="${1:?missing password variable}"
        if is_empty_value "${!empty_env_var}"; then
            print_validation_error "The ${empty_env_var} environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        fi
    }

    # Validate user inputs
    check_yes_no_value "DREAMFACTORY_SKIP_BOOTSTRAP"
    check_yes_no_value "DREAMFACTORY_CREATE_ADMIN_ACCOUNT"

    # Validate database configurations
    check_multi_value "DREAMFACTORY_DATABASE_TYPE" "mariadb postgresql"
    check_resolved_hostname "$DREAMFACTORY_DATABASE_HOST"
    check_valid_port "DREAMFACTORY_DATABASE_PORT_NUMBER"
    if is_boolean_yes "$DREAMFACTORY_ENABLE_MARIADB_SERVICE"; then
        check_resolved_hostname "$DREAMFACTORY_MARIADB_SERVICE_HOST"
        check_valid_port "DREAMFACTORY_MARIADB_SERVICE_PORT_NUMBER"
    fi
    if is_boolean_yes "$DREAMFACTORY_ENABLE_POSTGRESQL_SERVICE"; then
        check_resolved_hostname "$DREAMFACTORY_POSTGRESQL_SERVICE_HOST"
        check_valid_port "DREAMFACTORY_POSTGRESQL_SERVICE_PORT_NUMBER"
    fi
    if is_boolean_yes "$DREAMFACTORY_ENABLE_REDIS"; then
        check_resolved_hostname "$DREAMFACTORY_REDIS_HOST"
        check_valid_port "DREAMFACTORY_REDIS_PORT_NUMBER"
    fi
    if is_boolean_yes "$DREAMFACTORY_CREATE_ADMIN_ACCOUNT"; then
        check_empty_value "DREAMFACTORY_PASSWORD"
    fi

    # Validate database credentials
    if is_boolean_yes "${ALLOW_EMPTY_PASSWORD:-}"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD:-}. For safety reasons, do not use this flag in a production environment."
    else
        check_empty_password "DREAMFACTORY_DATABASE_PASSWORD"
        is_boolean_yes "$DREAMFACTORY_ENABLE_MARIADB_SERVICE" && check_empty_password "DREAMFACTORY_MARIADB_SERVICE_DATABASE_PASSWORD"
        is_boolean_yes "$DREAMFACTORY_ENABLE_POSTGRESQL_SERVICE" && check_empty_password "DREAMFACTORY_POSTGRESQL_SERVICE_DATABASE_PASSWORD"
        is_boolean_yes "$DREAMFACTORY_ENABLE_REDIS" && check_empty_password "DREAMFACTORY_REDIS_PASSWORD"
    fi

    # Validate SMTP credentials
    if ! is_empty_value "$DREAMFACTORY_SMTP_HOST"; then
        for empty_env_var in "DREAMFACTORY_SMTP_USER" "DREAMFACTORY_SMTP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && warn "The ${empty_env_var} environment variable is empty or not set."
        done
        is_empty_value "$DREAMFACTORY_SMTP_PORT_NUMBER" && print_validation_error "The DREAMFACTORY_SMTP_PORT_NUMBER environment variable is empty or not set."
        ! is_empty_value "$DREAMFACTORY_SMTP_PORT_NUMBER" && check_valid_port "DREAMFACTORY_SMTP_PORT_NUMBER"
        ! is_empty_value "$DREAMFACTORY_SMTP_PROTOCOL" && check_multi_value "DREAMFACTORY_SMTP_PROTOCOL" "ssl tls none"
    fi

    # Check that the web server is properly set up
    web_server_validate || print_validation_error "Web server validation failed"

    return "$error_code"
}

########################
# Ensure DreamFactory is initialized
# Globals:
#   DREAMFACTORY_*
# Arguments:
#   None
# Returns:
#   None
#########################
dreamfactory_initialize() {
    # Check if DreamFactory has already been initialized and persisted in a previous run
    local -r app_name="dreamfactory"
    if ! is_app_initialized "$app_name"; then
        # Ensure DreamFactory persisted directories exist (i.e. when a volume has been mounted to /bitnami)
        info "Ensuring DreamFactory directories exist"
        ensure_dir_exists "$DREAMFACTORY_VOLUME_DIR"
        # Use daemon:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$DREAMFACTORY_VOLUME_DIR" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"

        # Connect to the main database
        local -a db_execute_args=("$DREAMFACTORY_DATABASE_HOST" "$DREAMFACTORY_DATABASE_PORT_NUMBER" "$DREAMFACTORY_DATABASE_USER" "$DREAMFACTORY_DATABASE_PASSWORD" "$DREAMFACTORY_DATABASE_NAME")
        if [[ "$DREAMFACTORY_DATABASE_TYPE" = "mariadb" ]]; then
            info "Trying to connect to the MariaDB database server"
            dreamfactory_wait_for_mysql_connection "${db_execute_args[@]}"
        elif [[ "$DREAMFACTORY_DATABASE_TYPE" = "postgresql" ]]; then
            info "Trying to connect to the PostgreSQL database server"
            dreamfactory_wait_for_postgresql_connection "${db_execute_args[@]}"
        fi

        # Connect to optional extra services
        if is_boolean_yes "$DREAMFACTORY_ENABLE_MARIADB_SERVICE"; then
            info "Trying to connect to the extra MariaDB database service"
            dreamfactory_wait_for_mysql_connection "$DREAMFACTORY_MARIADB_SERVICE_HOST" "$DREAMFACTORY_MARIADB_SERVICE_PORT_NUMBER" "$DREAMFACTORY_MARIADB_SERVICE_DATABASE_USER" "$DREAMFACTORY_MARIADB_SERVICE_DATABASE_PASSWORD" "$DREAMFACTORY_MARIADB_SERVICE_DATABASE_NAME"
        fi
        if is_boolean_yes "$DREAMFACTORY_ENABLE_POSTGRESQL_SERVICE"; then
            info "Trying to connect to the PostgreSQL database service"
            dreamfactory_wait_for_postgresql_connection "$DREAMFACTORY_POSTGRESQL_SERVICE_HOST" "$DREAMFACTORY_POSTGRESQL_SERVICE_PORT_NUMBER" "$DREAMFACTORY_POSTGRESQL_SERVICE_DATABASE_USER" "$DREAMFACTORY_POSTGRESQL_SERVICE_DATABASE_PASSWORD" "$DREAMFACTORY_POSTGRESQL_SERVICE_DATABASE_NAME"
        fi

        # Connect to the optional cache services
        if is_boolean_yes "$DREAMFACTORY_ENABLE_REDIS"; then
            # Note: Redis is not supported as a configuration database for DreamFactory, nor as a service
            info "Trying to connect to the Redis server"
            dreamfactory_wait_for_redis_connection "$DREAMFACTORY_REDIS_HOST" "$DREAMFACTORY_REDIS_PORT_NUMBER" "$DREAMFACTORY_REDIS_PASSWORD"
        fi

        # Define database credentials
        local db_host db_port db_name db_user db_pass

        # DreamFactory installation steps
        # Based on https://wiki.dreamfactory.com/DreamFactory/Installation#Installing_and_Configuring_DreamFactory

        # Configure DreamFactory based on environment variables
        info "Configuring DreamFactory with settings provided via environment variables"
        local db_connection
        [[ "$DREAMFACTORY_DATABASE_TYPE" = "mariadb" ]] && db_connection="mysql"
        [[ "$DREAMFACTORY_DATABASE_TYPE" = "postgresql" ]] && db_connection="pgsql"
        local -a df_env_args=(
            "--df_install" "Bitnami"
            "--db_connection" "$db_connection"
            "--db_host" "$DREAMFACTORY_DATABASE_HOST"
            "--db_port" "$DREAMFACTORY_DATABASE_PORT_NUMBER"
            "--db_database" "$DREAMFACTORY_DATABASE_NAME"
            "--db_username" "$DREAMFACTORY_DATABASE_USER"
            "--db_password" "$DREAMFACTORY_DATABASE_PASSWORD"
        )
        if is_boolean_yes "$DREAMFACTORY_ENABLE_REDIS"; then
            debug "Configuring Redis as cache server"
            df_env_args+=(
                "--cache_driver" "redis"
                "--redis_host" "$DREAMFACTORY_REDIS_HOST"
                "--redis_port" "$DREAMFACTORY_REDIS_PORT_NUMBER"
                "--redis_database" "0"
            )
            ! is_empty_value "$DREAMFACTORY_REDIS_PASSWORD" && df_env_args+=("--redis_password" "$DREAMFACTORY_REDIS_PASSWORD")
        fi
        # Create .env file
        debug "Creating .env file"
        dreamfactory_execute "df:env" "${df_env_args[@]}"

        # Additional configuration
        # Unfortunately it is not possible to set these options with 'df:env'

        # HACK: Set Redis cache server configuration in '.env'
        # The logic to set Redis configuration in '.env' via 'df:env' does not update the default credentials, remove once fixed
        if is_boolean_yes "$DREAMFACTORY_ENABLE_REDIS"; then
            dreamfactory_conf_set "CACHE_HOST" "$DREAMFACTORY_REDIS_HOST"
            dreamfactory_conf_set "CACHE_PORT" "$DREAMFACTORY_REDIS_PORT_NUMBER"
            dreamfactory_conf_set "CACHE_DATABASE" "0"
            ! is_empty_value "$DREAMFACTORY_REDIS_PASSWORD" && dreamfactory_conf_set "CACHE_PASSWORD" "$DREAMFACTORY_REDIS_PASSWORD"
        fi

        if [[ "$DREAMFACTORY_DATABASE_TYPE" = "mariadb" ]]; then
            # In the future, we should consider changing to utf8mb4 (current defaults)
            debug "Setting UTF-8 charset"
            dreamfactory_conf_set "DB_CHARSET" "utf8"
            dreamfactory_conf_set "DB_COLLATION" "utf8_unicode_ci"
        fi

        if ! is_empty_value "$DREAMFACTORY_SMTP_HOST"; then
            info "Configuring SMTP"
            # SMTP configuration is not documented in '.env-dist', but is still supported by the application
            # https://github.com/dreamfactorysoftware/dreamfactory/blob/master/config/mail.php
            # See .env-dist: https://github.com/dreamfactorysoftware/dreamfactory/blob/master/.env-dist
            # See SwiftMailer SMTP docs: https://swiftmailer.symfony.com/docs/sending.html#the-smtp-transport
            cat >>"$DREAMFACTORY_CONF_FILE" <<EOF

##------------------------------------------------------------------------------
## Mail Settings
##------------------------------------------------------------------------------
MAIL_DRIVER=smtp
MAIL_HOST=${DREAMFACTORY_SMTP_HOST}
MAIL_PORT=${DREAMFACTORY_SMTP_PORT_NUMBER}
MAIL_USERNAME=${DREAMFACTORY_SMTP_USER}
MAIL_PASSWORD=${DREAMFACTORY_SMTP_PASSWORD}
MAIL_ENCRYPTION=${DREAMFACTORY_SMTP_PROTOCOL}
EOF
        fi

        if ! is_boolean_yes "$DREAMFACTORY_SKIP_BOOTSTRAP"; then
            if is_boolean_yes "$DREAMFACTORY_CREATE_ADMIN_ACCOUNT"; then
                local -a df_setup_args=(
                    "--admin_email" "$DREAMFACTORY_EMAIL"
                    "--admin_password" "$DREAMFACTORY_PASSWORD"
                    "--admin_first_name" "$DREAMFACTORY_FIRST_NAME"
                    "--admin_last_name" "$DREAMFACTORY_LAST_NAME"
                    "--admin_phone" "$DREAMFACTORY_PHONE"
                )
                dreamfactory_execute "df:setup" "${df_setup_args[@]}"
            else
                # If user credentials were not defined, setup DreamFactory without creating an initial user
                # This is still a long-standing use-case that we still want to support
                # Based on steps from 'df:setup': https://github.com/dreamfactorysoftware/df-core/blob/master/src/Commands/Setup.php
                info "Installing DreamFactory"
                dreamfactory_execute "key:generate"
                dreamfactory_execute "migrate"
                dreamfactory_execute "db:seed"
            fi

            if is_boolean_yes "$DREAMFACTORY_ENABLE_MARIADB_SERVICE"; then
                info "Adding MariaDB service"
                dreamfactory_add_service --name "mariadb" --type "mysql" --label "MariaDB Database" --description "A MySQL database service."
            fi

            if is_boolean_yes "$DREAMFACTORY_ENABLE_POSTGRESQL_SERVICE"; then
                info "Adding PostgreSQL service"
                dreamfactory_add_service --name "postgresql" --type "pgsql" --label "PostgreSQL Database" --description "A PostgreSQL database service."
            fi

        else
            info "An already initialized DreamFactory database was provided, configuration will be skipped"
            info "Running database migrations"
            dreamfactory_execute "migrate"
        fi

        info "Persisting DreamFactory installation"
        persist_app "$app_name" "$DREAMFACTORY_DATA_TO_PERSIST"
    else
        info "Restoring persisted DreamFactory installation"
        restore_persisted_app "$app_name" "$DREAMFACTORY_DATA_TO_PERSIST"
        info "Trying to connect to the database server"
        local db_type db_host db_port db_user db_pass
        db_type="$(dreamfactory_conf_get "DB_CONNECTION")"
        db_host="$(dreamfactory_conf_get "DB_HOST")"
        db_port="$(dreamfactory_conf_get "DB_PORT")"
        db_user="$(dreamfactory_conf_get "DB_USERNAME")"
        db_pass="$(dreamfactory_conf_get "DB_PASSWORD")"
        if [[ "$db_type" = "mysql" ]]; then
            dreamfactory_wait_for_mysql_connection "$db_host" "$db_port" "$db_user" "$db_pass"
        elif [[ "$db_type" = "pgsql" ]]; then
            dreamfactory_wait_for_mysql_connection "$db_host" "$db_port" "$db_user" "$db_pass"
        else
            warn "Unsupported database type ${db_type}, will not wait for it to come online"
        fi
        info "Running database migrations"
        dreamfactory_execute "migrate"
    fi

    info "Clearing cache"
    dreamfactory_execute "config:clear"
    dreamfactory_execute "cache:clear"

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Execute a DreamFactory command via 'artisan'
# Globals:
#   DREAMFACTORY_*
# Arguments:
#   $1..$n - Command arguments
# Returns:
#   None
#########################
dreamfactory_execute() {
    # Using 'env -i' to avoid conflict between 'mysql-env.sh' DB_* envvars and Laravel DB configuration
    local -a args=("env" "-i" "${PHP_BIN_DIR}/php" "artisan" "--no-ansi" "--no-interaction" "$@")
    (
        cd "$DREAMFACTORY_BASE_DIR" || false
        if am_i_root; then
            debug_execute gosu "$WEB_SERVER_DAEMON_USER" "${args[@]}"
        else
            debug_execute "${args[@]}"
        fi
    )
}

########################
# Get an entry from the DreamFactory configuration file
# Globals:
#   DREAMFACTORY_*
# Arguments:
#   $1 - Variable name
# Returns:
#   None
#########################
dreamfactory_conf_get() {
    local -r key="${1:?key missing}"
    debug "Getting ${key} from DreamFactory configuration"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(#\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")=(.*)"
    grep -E "$sanitized_pattern" "$DREAMFACTORY_CONF_FILE" | sed -E "s|${sanitized_pattern}|\2|" | tr -d "\"' "
}

########################
# Add or modify an entry in the DreamFactory configuration file
# Globals:
#   DREAMFACTORY_*
# Arguments:
#   $1 - Variable name
#   $2 - Value to assign to the variable
# Returns:
#   None
#########################
dreamfactory_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:?value missing}"
    debug "Setting ${key} to '${value}' in DreamFactory configuration"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(#\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")=.*"
    local entry="${key}=${value}"
    # Check if the configuration exists in the file
    if grep -q -E "$sanitized_pattern" "$DREAMFACTORY_CONF_FILE"; then
        # It exists, so replace the line
        replace_in_file "$DREAMFACTORY_CONF_FILE" "$sanitized_pattern" "$entry"
    else
        # The DreamFactory configuration file includes all supported keys, but because of its format,
        # we cannot append contents to the end. We can assume this should never happen.
        error "Could not set the DreamFactory '${key}' configuration. Check that the file has not been modified externally."
        return 1
    fi
}

########################
# Add a service to DreamFactory
# Globals:
#   DREAMFACTORY_*
# Flags:
#   --name - Service name
#   --label - Service label
#   --description - Service description
#   --is-active - Whether the service should be active
#   --type - Service type
# Returns:
#   None
#########################
dreamfactory_add_service() {
    local name type label description is_active
    # Default values
    is_active="true"
    # Validate arguments
    local var_name
    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            # Common flags
            --name \
            | --type \
            | --label \
            | --description)
                var_name="$(echo "$1" | sed -e "s/^--//" -e "s/-/_/g")"
                shift
                declare "${var_name}"="$1"
                ;;
            --is-active)
                shift
                is_active="$(is_boolean_yes "$1" && echo "true" || echo "false")"
                ;;
            *)
                error "Invalid command line flag ${1}" >&2
                return 1
                ;;
        esac
        shift
    done
    # Define resource request
    local resource_prefix=".resource[0]"
    local -a service_config=(
        # Add values
        "${resource_prefix}.name=\"${name}\""
        "${resource_prefix}.type=\"${type}\""
        "${resource_prefix}.label=\"${label}\""
        "${resource_prefix}.description=\"${description}\""
        "${resource_prefix}.is_active=${is_active}"
    )
    # Define resource configuration (i.e. database configuration)
    local config_prefix="${resource_prefix}.config"
    case "$type" in
        mysql)
            service_config+=(
                "${config_prefix}.host=\"${DREAMFACTORY_MARIADB_SERVICE_HOST}\""
                "${config_prefix}.port=\"${DREAMFACTORY_MARIADB_SERVICE_PORT_NUMBER}\""
                "${config_prefix}.database=\"${DREAMFACTORY_MARIADB_SERVICE_DATABASE_NAME}\""
                "${config_prefix}.username=\"${DREAMFACTORY_MARIADB_SERVICE_DATABASE_USER}\""
                "${config_prefix}.password=\"${DREAMFACTORY_MARIADB_SERVICE_DATABASE_PASSWORD}\""
            )
            ;;
        pgsql)
            service_config+=(
                "${config_prefix}.host=\"${DREAMFACTORY_POSTGRESQL_SERVICE_HOST}\""
                "${config_prefix}.port=\"${DREAMFACTORY_POSTGRESQL_SERVICE_PORT_NUMBER}\""
                "${config_prefix}.database=\"${DREAMFACTORY_POSTGRESQL_SERVICE_DATABASE_NAME}\""
                "${config_prefix}.username=\"${DREAMFACTORY_POSTGRESQL_SERVICE_DATABASE_USER}\""
                "${config_prefix}.password=\"${DREAMFACTORY_POSTGRESQL_SERVICE_DATABASE_PASSWORD}\""
            )
            ;;
        *)
            error "Unsupported service type '${type}'"
            return 1
            ;;
    esac
    # Create JSON object from the service configuration array
    local service_json="{}"
    for entry in "${service_config[@]}"; do
        service_json="$(jq -c "$entry" <<< "$service_json")"
    done
    debug "Creating ${name} service"
    debug "$(jq . "$service_json")"
    # Populate the service
    dreamfactory_execute "df:request" "--verb=POST" "--service=system" "--resource=service" "$(jq -c . <<< "$service_json")"
}

########################
# Wait until the database is accessible with the currently-known credentials
# Globals:
#   *
# Arguments:
#   $1 - database host
#   $2 - database port
#   $3 - database username
#   $4 - database user password (optional)
#   $5 - database name (optional)
# Returns:
#   true if the database connection succeeded, false otherwise
#########################
dreamfactory_wait_for_mysql_connection() {
    local -r db_host="${1:?missing database host}"
    local -r db_port="${2:?missing database port}"
    local -r db_user="${3:?missing database user}"
    local -r db_pass="${4:-}"
    local -r db_name="${5:-}"
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
#   $3 - database username
#   $4 - database user password (optional)
#   $5 - database name (optional)
# Returns:
#   true if the database connection succeeded, false otherwise
#########################
discourse_wait_for_postgresql_connection() {
    local -r db_host="${1:?missing database host}"
    local -r db_port="${2:?missing database port}"
    local -r db_user="${3:?missing database user}"
    local -r db_pass="${4:-}"
    local -r db_name="${5:-}"
    check_postgresql_connection() {
        echo "SELECT 1" | postgresql_remote_execute "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
    }
    if ! retry_while "check_postgresql_connection"; then
        error "Could not connect to the database"
        return 1
    fi
}

########################
# Wait until Redis is accessible
# Globals:
#   *
# Arguments:
#   $1 - Redis host
#   $2 - Redis port
#   $3 - Redis password
# Returns:
#   true if the Redis connection succeeded, false otherwise
#########################
dreamfactory_wait_for_redis_connection() {
    local -r redis_host="${1:?missing Redis host}"
    local -r redis_port="${2:?missing Redis port}"
    local -r redis_pass="${3:-}"
    local -a redis_cli_args=("redis-cli" "-h" "$redis_host" "-p" "$redis_port")
    ! is_empty_value "$redis_pass" && redis_cli_args+=("-a" "$redis_pass")
    if ! retry_while "debug_execute ${redis_cli_args[*]}"; then
        error "Could not connect to Redis"
        return 1
    fi
}
