#!/bin/bash
#
# Bitnami PrestaShop library

# shellcheck disable=SC1091

# Load generic libraries
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libpersistence.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load database library
if [[ -f /opt/bitnami/scripts/libmysqlclient.sh ]]; then
    . /opt/bitnami/scripts/libmysqlclient.sh
elif [[ -f /opt/bitnami/scripts/libmysql.sh ]]; then
    . /opt/bitnami/scripts/libmysql.sh
elif [[ -f /opt/bitnami/scripts/libmariadb.sh ]]; then
    . /opt/bitnami/scripts/libmariadb.sh
fi

########################
# Validate settings in PRESTASHOP_* env vars
# Globals:
#   PRESTASHOP_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
prestashop_validate() {
    debug "Validating settings in PRESTASHOP_* environment variables..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
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
    check_valid_port() {
        local port_var="${1:?missing port variable}"
        local err
        if ! err="$(validate_port "${!port_var}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    # Validate credentials
    if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    else
        for empty_env_var in "PRESTASHOP_DATABASE_PASSWORD" "PRESTASHOP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        done
    fi

    # Validate SMTP credentials
    if ! is_empty_value "$PRESTASHOP_SMTP_HOST"; then
        for empty_env_var in "PRESTASHOP_SMTP_USER" "PRESTASHOP_SMTP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && warn "The ${empty_env_var} environment variable is empty or not set."
        done
        is_empty_value "$PRESTASHOP_SMTP_PORT_NUMBER" && print_validation_error "The PRESTASHOP_SMTP_PORT_NUMBER environment variable is empty or not set."
        ! is_empty_value "$PRESTASHOP_SMTP_PORT_NUMBER" && check_valid_port "PRESTASHOP_SMTP_PORT_NUMBER"
        ! is_empty_value "$PRESTASHOP_SMTP_PROTOCOL" && check_multi_value "PRESTASHOP_SMTP_PROTOCOL" "ssl tls"
    fi

    # Check that the web server is properly set up
    web_server_validate || print_validation_error "Web server validation failed"

    return "$error_code"
}

########################
# Ensure PrestaShop is initialized
# Globals:
#   PRESTASHOP_*
# Arguments:
#   None
# Returns:
#   None
#########################
prestashop_initialize() {
    # Check if PrestaShop has already been initialized and persisted in a previous run
    local -r app_name="prestashop"
    if ! is_app_initialized "$app_name"; then
        # Ensure PrestaShop persisted directories exist (i.e. when a volume has been mounted to /bitnami)
        info "Ensuring PrestaShop directories exist"
        ensure_dir_exists "$PRESTASHOP_VOLUME_DIR"
        # Use daemon:root ownership for compatibility when running as a non-root user
        if am_i_root; then
            configure_permissions_ownership "$PRESTASHOP_VOLUME_DIR" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
            # PrestaShop CLI explicitly checks for the "var" and "modules" directories to belong to the web server user
            for dir in "${PRESTASHOP_BASE_DIR}/var" "${PRESTASHOP_BASE_DIR}/modules"; do
                configure_permissions_ownership "$dir" -u "$WEB_SERVER_DAEMON_USER"
            done
        fi
        info "Trying to connect to the database server"
        local db_host db_port db_name db_user db_pass
        db_host="$PRESTASHOP_DATABASE_HOST"
        db_port="$PRESTASHOP_DATABASE_PORT_NUMBER"
        db_name="$PRESTASHOP_DATABASE_NAME"
        db_user="$PRESTASHOP_DATABASE_USER"
        db_pass="$PRESTASHOP_DATABASE_PASSWORD"
        local -a mysql_execute_args=("$db_host" "$db_port" "$db_name" "$db_user" "$db_pass")
        prestashop_wait_for_db_connection "${mysql_execute_args[@]}"
        local -a prestashop_install_args=(
            "php"
            "${PRESTASHOP_BASE_DIR}/install/index_cli.php"
            "--db_user=${db_user}"
            "--db_password=${db_pass}"
            "--db_server=${db_host}:${db_port}"
            "--db_name=${db_name}"
            "--prefix=${PRESTASHOP_DATABASE_PREFIX}"
            "--domain=${PRESTASHOP_HOST}"
            "--firstname=${PRESTASHOP_FIRST_NAME}"
            "--lastname=${PRESTASHOP_LAST_NAME}"
            "--password=${PRESTASHOP_PASSWORD}"
            "--email=${PRESTASHOP_EMAIL}"
            "--timezone=${PRESTASHOP_TIMEZONE}"
            "--country=${PRESTASHOP_COUNTRY}"
            "--language=${PRESTASHOP_LANGUAGE}"
            "--newsletter=0"
        )
        is_boolean_yes "$PRESTASHOP_ENABLE_HTTPS" && prestashop_install_args+=("--ssl=1")
        # Ensure new files get created with web server write access, by running the installation command as the web server user
        am_i_root && prestashop_install_args=("gosu" "$WEB_SERVER_DAEMON_USER" "${prestashop_install_args[@]}")
        if ! is_boolean_yes "$PRESTASHOP_SKIP_BOOTSTRAP"; then
            info "Running install script"
            debug_execute "${prestashop_install_args[@]}"
            info "Updating store settings"
            local -a settings_to_update=(
                # Force URL rewriting (required because of emptied .htaccess file)
                "PS_REWRITING_SETTINGS=1"
                # Enable cache and avoid per-request recompilation
                # See: https://devdocs.prestashop.com/1.7/basics/installation/configuration/#disabling-the-cache-and-forcing-smarty-compilation
                "PS_SMARTY_CACHE=1"
                "PS_SMARTY_FORCE_COMPILE=0"
            )
            if ! is_boolean_yes "$PRESTASHOP_COOKIE_CHECK_IP"; then
                info "Disabling IP address check for cookies"
                settings_to_update+=("PS_COOKIE_CHECKIP=0")
            fi
            if ! is_empty_value "$PRESTASHOP_SMTP_HOST"; then
                info "Configuring SMTP"
                settings_to_update+=(
                    "PS_MAIL_SERVER=${PRESTASHOP_SMTP_HOST}"
                    "PS_MAIL_USER=${PRESTASHOP_SMTP_USER}"
                    "PS_MAIL_PASSWD=${PRESTASHOP_SMTP_PASSWORD}"
                    "PS_MAIL_SMTP_ENCRYPTION=${PRESTASHOP_SMTP_PROTOCOL}"
                    "PS_MAIL_SMTP_PORT=${PRESTASHOP_SMTP_PORT_NUMBER}"
                    # The '2' value stands for SMTP
                    "PS_MAIL_METHOD=2"
                    # Domain name of the store (i.e. to show 'via example.com' in the e-mail app)
                    "PS_MAIL_DOMAIN=${PRESTASHOP_HOST}"
                )
            fi
            for setting in "${settings_to_update[@]}"; do
                # We split the key and value with the '=' delimiter via native Bash functionality to simplify the logic
                mysql_remote_execute "${mysql_execute_args[@]}" <<< "UPDATE ${PRESTASHOP_DATABASE_PREFIX}configuration SET value='${setting#*=}' WHERE name='${setting%=*}';"
            done
        else
            info "An already initialized PrestaShop database was provided, configuration will be skipped"
            # Generate configuration file (this command is forced to fail by overriding DB name, to generate the file and exit)
            # Unfortunately PrestaShop does not provide a mechanism to generate the configuration file without populating the database via CLI
            # For more info, refer to 'install/controllers/console/process.php': Calls to 'processGenerateSettingsFile' only happen during the 'database' step
            info "Generating configuration file"
            debug "Running install script to generate the configuration file (this command is expected to fail)"
            debug_execute "${prestashop_install_args[@]}" "--db_user=@@DB_USER@@" || true
            if [[ ! -f "$PRESTASHOP_CONF_FILE" ]]; then
                error "Configuration file did not get created"
                exit 1
            fi
            replace_in_file "$PRESTASHOP_CONF_FILE" "@@DB_USER@@" "$db_user"
            # Run the installation for everything except DB
            info "Running install script (skipping database population)"
            debug_execute "${prestashop_install_args[@]}" --steps="fixtures,theme,modules,addons_modules"
        fi

        # Make admin panel available at a consistent /administration URL, for documentation and metadata purposes
        # If left at the default /admin, a random and installation-specific suffix is added to it (i.e. /admin146hug18d)
        mv "${PRESTASHOP_BASE_DIR}/admin" "${PRESTASHOP_BASE_DIR}/administration"
        # Remove installation scripts (for security purposes) - Access to the admin panel will be denied until it is removed
        rm -rf "${PRESTASHOP_BASE_DIR}/install"

        info "Persisting PrestaShop installation"
        persist_app "$app_name" "$PRESTASHOP_DATA_TO_PERSIST"
    else
        info "Restoring persisted PrestaShop installation"
        restore_persisted_app "$app_name" "$PRESTASHOP_DATA_TO_PERSIST"
        info "Trying to connect to the database server"
        local -a db_args
        read -r -a db_args <<< "$(prestashop_db_args)"
        prestashop_wait_for_db_connection "${db_args[@]}"
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Add or modify an entry in the PrestaShop configuration file (config.inc.php)
# Globals:
#   PRESTASHOP_*
# Arguments:
#   $1 - PHP variable name
#   $2 - Value to assign to the PHP variable
#   $3 - Whether the value is a literal, or if instead it should be quoted (default: no)
# Returns:
#   None
#########################
prestashop_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:?value missing}"
    local -r is_literal="${3:-no}"
    debug "Setting ${key} to '${value}' in PrestaShop configuration (literal: ${is_literal})"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(//\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")\s*=.*"
    local entry
    is_boolean_yes "$is_literal" && entry="${key} = $value;" || entry="${key} = '$value';"
    # Check if the configuration exists in the file
    if grep -q -E "$sanitized_pattern" "$PRESTASHOP_CONF_FILE"; then
        # It exists, so replace the line
        replace_in_file "$PRESTASHOP_CONF_FILE" "$sanitized_pattern" "$entry"
    else
        # The PrestaShop configuration file includes all supported keys, but because of its format,
        # we cannot append contents to the end. We can assume thi
        warn "Could not set the PrestaShop '${key}' configuration. Check that the file has not been modified externally."
    fi
}

########################
# Get an entry from the PrestaShop configuration file (config.inc.php)
# Globals:
#   PRESTASHOP_*
# Arguments:
#   $1 - PHP variable name
# Returns:
#   None
#########################
prestashop_conf_get() {
    local -r key="${1:?key missing}"
    debug "Getting ${key} from PrestaShop configuration"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(//\s*)?['\"]?$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")['\"]?\s*=>?([^;,]+)[;,]"
    debug "$sanitized_pattern"
    grep -E "$sanitized_pattern" "$PRESTASHOP_CONF_FILE" | sed -E "s|${sanitized_pattern}|\2|" | tr -d "\"' "
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
prestashop_wait_for_db_connection() {
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
# Print PrestaShop database connection args for use with mysql_execute
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   true if the wizard succeeded, false otherwise
#########################
prestashop_db_args() {
    local db_host db_port db_name db_user db_pass
    db_host="$(prestashop_conf_get "database_host")"
    db_port="$(prestashop_conf_get "database_port")"
    db_name="$(prestashop_conf_get "database_name")"
    db_user="$(prestashop_conf_get "database_user")"
    db_pass="$(prestashop_conf_get "database_password")"
    echo "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
}
