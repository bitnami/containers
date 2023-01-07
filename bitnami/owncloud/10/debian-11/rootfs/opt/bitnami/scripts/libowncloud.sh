#!/bin/bash

# Bitnami ownCloud library

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

# Load database library
if [[ -f /opt/bitnami/scripts/libmysqlclient.sh ]]; then
    . /opt/bitnami/scripts/libmysqlclient.sh
elif [[ -f /opt/bitnami/scripts/libmysql.sh ]]; then
    . /opt/bitnami/scripts/libmysql.sh
elif [[ -f /opt/bitnami/scripts/libmariadb.sh ]]; then
    . /opt/bitnami/scripts/libmariadb.sh
fi

########################
# Validate settings in OWNCLOUD_* env vars
# Globals:
#   OWNCLOUD_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
owncloud_validate() {
    debug "Validating settings in OWNCLOUD_* environment variables"
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
    check_mounted_file() {
        if [[ -n "${!1:-}" ]] && ! [[ -f "${!1:-}" ]]; then
            print_validation_error "${1} is defined but the file ${!1} is not accessible or does not exist"
        fi
    }
    check_valid_port() {
        local port_var="${1:?missing port variable}"
        local err
        if ! err="$(validate_port "${!port_var}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    # Warn users in case the configuration file is not writable
    is_file_writable "$OWNCLOUD_CONF_FILE" || warn "The ownCloud configuration file '${OWNCLOUD_CONF_FILE}' is not writable. Configurations based on environment variables will not be applied for this file."

    # Validate credentials
    if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    else
        for empty_env_var in "OWNCLOUD_DATABASE_PASSWORD" "OWNCLOUD_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        done
    fi

    # Validate user inputs
    check_empty_value "OWNCLOUD_HOST"
    check_empty_value "OWNCLOUD_PASSWORD"
    check_multi_value "OWNCLOUD_DATABASE_TYPE" "sqlite mysql"
    check_yes_no_value "OWNCLOUD_SKIP_BOOTSTRAP"

    # Database configuration validations
    check_resolved_hostname "$OWNCLOUD_DATABASE_HOST"
    validate_port "$OWNCLOUD_DATABASE_PORT_NUMBER"

    # Validate SMTP credentials
    if ! is_empty_value "$OWNCLOUD_SMTP_HOST"; then
        for empty_env_var in "OWNCLOUD_SMTP_USER" "OWNCLOUD_SMTP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && warn "The ${empty_env_var} environment variable is empty or not set."
        done
        is_empty_value "OWNCLOUD_SMTP_PORT_NUMBER" && print_validation_error "The OWNCLOUD_SMTP_PORT_NUMBER environment variable is empty or not set."
        ! is_empty_value "OWNCLOUD_SMTP_PORT_NUMBER" && check_valid_port "OWNCLOUD_SMTP_PORT_NUMBER"
        ! is_empty_value "$OWNCLOUD_SMTP_PROTOCOL" && check_multi_value "OWNCLOUD_SMTP_PROTOCOL" "ssl tls"
    fi

    # Check that the web server is properly set up
    web_server_validate || print_validation_error "Web server validation failed"

    return "$error_code"
}

########################
# Ensure ownCloud is initialized
# Globals:
#   OWNCLOUD_*
# Arguments:
#   None
# Returns:
#   None
#########################
owncloud_initialize() {
    # Check if ownCloud has already been initialized and persisted in a previous run
    local db_type db_host db_port db_name db_user db_pass
    local -r app_name="owncloud"
    if ! is_app_initialized "$app_name"; then
        info "Trying to connect to the database server"
        db_type="$OWNCLOUD_DATABASE_TYPE"
        db_host="$OWNCLOUD_DATABASE_HOST"
        db_port="$OWNCLOUD_DATABASE_PORT_NUMBER"
        db_name="$OWNCLOUD_DATABASE_NAME"
        db_user="$OWNCLOUD_DATABASE_USER"
        db_pass="$OWNCLOUD_DATABASE_PASSWORD"
        [[ "$db_type" = "mysql" ]] && owncloud_wait_for_db_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"

        # Ensure ownCloud persisted directories exist (i.e. when a volume has been mounted to /bitnami)
        info "Ensuring ownCloud directories exist"
        ensure_dir_exists "$OWNCLOUD_VOLUME_DIR"
        # Use daemon:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$OWNCLOUD_VOLUME_DIR" -u "$WEB_SERVER_DAEMON_USER" -g "root"

        local -a owncloud_cli_args=(
            "--database" "$db_type"
            "--database-host" "${db_host}:${db_port}"
            "--database-name" "$db_name"
            "--database-user" "$db_user"
            "--database-pass" "$db_pass"
            "--data-dir" "$OWNCLOUD_DATA_DIR"
            "--admin-user" "$OWNCLOUD_USERNAME"
            "--admin-pass" "$OWNCLOUD_PASSWORD"
        )
        if ! is_boolean_yes "$OWNCLOUD_SKIP_BOOTSTRAP"; then
            info "Running installation script"
            owncloud_execute_occ maintenance:install "${owncloud_cli_args[@]}"
            # Update e-mail address of the admin user (it cannot be set via 'maintenance:install')
            owncloud_execute_occ user:modify "$OWNCLOUD_USERNAME" email "$OWNCLOUD_EMAIL"
            # Ensure that the web server user cannot write to the .htaccess files
            configure_permissions_ownership "${OWNCLOUD_DATA_DIR}/.htaccess" -f "440"
        else
            info "An already initialized ownCloud database was provided, configuration will be skipped"
            # ownCloud does not have any support for providing any existing database
            # However, it does support SQLite as database, which is enabled by default in our ownCloud images
            # Therefore we will install ownCloud with SQLite, then manually change the configuration to use the appropriate DB
            info "Running installation script to create configuration (using local SQLite database)"
            local data_dir
            # If the data directory was not provided / is empty, populate it as if it were a new installation
            if is_mounted_dir_empty "$OWNCLOUD_DATA_DIR"; then
                data_dir="$OWNCLOUD_DATA_DIR"
            else
                data_dir="$(mktemp -d)"
                # When running mktemp as 'root' it sets 700 permissions, we need more permissions
                am_i_root && configure_permissions_ownership "$data_dir" -d "770" -u "$WEB_SERVER_DAEMON_USER" -g "root"
            fi
            owncloud_execute_occ maintenance:install "${owncloud_cli_args[@]}" --database sqlite --data-dir "$data_dir"
            # Update configuration file
            # These differences can be generated manually by installing with SQLite and comparing configuration files
            info "Updating configuration file with values provided via environment variables"
            owncloud_conf_set "mysql.utf8mb4" "true" "boolean"
            owncloud_conf_set "dbhost" "${OWNCLOUD_DATABASE_HOST}:${OWNCLOUD_DATABASE_PORT_NUMBER}"
            owncloud_conf_set "dbuser" "$OWNCLOUD_DATABASE_USER"
            owncloud_conf_set "dbpassword" "$OWNCLOUD_DATABASE_PASSWORD"
            # NOTE: These options must be last and in a *very specific order*, or 'occ config:system:set' calls will fail
            # - 'dbname' will cause ownCloud not to recognize the SQLite db, failing to set any options
            # - same with 'dbtableprefix', but its default value for non-SQLite dbs is 'oc_' (it's a cosmetic change)
            # - Due to 'occ' not working after changing the above fields, we must manually set the DB type via a 'sed' substitution
            # - 'datadirectory' stores the SQLite database, if it is changed before the DB is configured, 'occ' will fail
            owncloud_conf_set "dbname" "$OWNCLOUD_DATABASE_NAME"
            replace_in_file "$OWNCLOUD_CONF_FILE" "('dbtype'\s*=>\s*)'[^']*'" "\1'mysql'"
            owncloud_conf_set "dbtableprefix" "oc_"
            owncloud_conf_set "datadirectory" "$OWNCLOUD_DATA_DIR"
            owncloud_upgrade_database_schema
        fi

        # Remove wrong data directory created by the installation script to avoid confusion
        rm -rf "${OWNCLOUD_BASE_DIR}/data"

        owncloud_configure_trusted_domains "${OWNCLOUD_HOST:-localhost}"
        ! is_empty_value "$OWNCLOUD_SMTP_HOST" && owncloud_configure_smtp

        info "Persisting ownCloud installation"
        persist_app "$app_name" "$OWNCLOUD_DATA_TO_PERSIST"
    else
        info "Restoring persisted ownCloud installation"
        restore_persisted_app "$app_name" "$OWNCLOUD_DATA_TO_PERSIST"
        info "Trying to connect to the database server"
        db_type="$(owncloud_conf_get "dbtype")"
        # Separate 'host:port' with native Bash split functions (fallback to default port number if not specified)
        db_host_port="$(owncloud_conf_get "dbhost")"
        db_host="${db_host_port%:*}"
        if [[ "$db_host_port" =~ :[0-9]+$ ]]; then
            # Use '##' to extract only the part after the last colon, to avoid any possible issues with IPv6 addresses
            db_port="${db_host_port##*:}"
        else
            db_port="$OWNCLOUD_DATABASE_PORT_NUMBER"
        fi
        db_name="$(owncloud_conf_get "dbname")"
        db_user="$(owncloud_conf_get "dbuser")"
        db_pass="$(owncloud_conf_get "dbpassword")"
        [[ "$db_type" = "mysql" ]] && owncloud_wait_for_db_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
        owncloud_upgrade_database_schema
    fi

    # Regenerate .htaccess file(s) to include 'ErrorDocument 403/404' lines, not present by default
    # Need to set 660 permissions in case of it already being present with 440 permissions (i.e. after a restart)
    am_i_root && configure_permissions_ownership "${OWNCLOUD_BASE_DIR}/.htaccess" -f "660"
    owncloud_execute_occ "maintenance:update:htaccess"
    # Ensure that the .htaccess and files cannot be written to by the web server user
    am_i_root && configure_permissions_ownership "${OWNCLOUD_BASE_DIR}/.htaccess" -f "440"

    # Configure PHP options provided via envvars in .user.ini (which overrides configuration in php.ini)
    am_i_root && configure_permissions_ownership "${OWNCLOUD_BASE_DIR}/.user.ini" -f "660"
    php_set_runtime_config "${OWNCLOUD_BASE_DIR}/.user.ini"
    # Ensure that the .user.ini files cannot be written to by the web server user
    # This file allows for PHP-FPM to set application-specific PHP settings, and could be a security risk if left writable
    am_i_root && configure_permissions_ownership "${OWNCLOUD_BASE_DIR}/.user.ini" -f "440"

    # Ensure ownCloud cron jobs are created when running setup with a root user
    # https://doc.owncloud.com/server/admin_manual/configuration/server/background_jobs_configuration.html#cron
    local -a cron_cmd=("${PHP_BIN_DIR}/php" "${OWNCLOUD_BASE_DIR}/occ" "system:cron")
    if am_i_root; then
        generate_cron_conf "owncloud" "${cron_cmd[*]}" --run-as "$WEB_SERVER_DAEMON_USER" --schedule "*/1 * * * *"
    else
        warn "Skipping cron configuration for ownCloud because of running as a non-root user"
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Execute ownCloud command line tool "occ" printing output to stdout
# Globals:
#   OWNCLOUD_*
# Arguments:
#   $@ - Arguments list for occ
# Returns:
#   None
#########################
owncloud_execute_occ_print_stdout() {
    local args=("${@:?missing args}")
    local -r -a cmd=("php" "${OWNCLOUD_BASE_DIR}/occ" "${args[@]}")
    if am_i_root; then
        gosu "$WEB_SERVER_DAEMON_USER" "${cmd[@]}"
    else
        "${cmd[@]}"
    fi
}

########################
# Execute ownCloud command line tool "occ"
# Globals:
#   OWNCLOUD_*
# Arguments:
#   $@ - Arguments list for occ
# Returns:
#   None
#########################
owncloud_execute_occ() {
    debug_execute owncloud_execute_occ_print_stdout "$@"
}

########################
# Set a configuration parameter on the ownCloud configuration
# Globals:
#   OWNCLOUD_*
# Arguments:
#   $1 - Configuration parameter to set
#   $2 - Value to assign to the configuration parameter
# Returns:
#   None
#########################
owncloud_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:-}"
    local -r type="${3:-}"
    local -a args=("config:system:set" "$key" "--value" "$value")
    [[ -n "$type" ]] && args+=("--type" "$type")
    debug "Setting key ${key} to '${value}' in ownCloud configuration"
    owncloud_execute_occ "${args[@]}"
}

########################
# Get an entry from the ownCloud configuration
# Globals:
#   OWNCLOUD_*
# Arguments:
#   $1 - configuration parameter name
# Returns:
#   None
#########################
owncloud_conf_get() {
    local -r key="${1:?key missing}"
    # This function is only being used to obtain database credentials
    # But unfortunately, when the DB is not accessible, OCC fails so we have cannot make use of it
    debug "Getting ${key} from ownCloud configuration"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(//\s*)?['\"]?$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")['\"]?\s*=>?([^;,]+)[;,]"
    debug "$sanitized_pattern"
    grep -E "$sanitized_pattern" "$OWNCLOUD_CONF_FILE" | sed -E "s|${sanitized_pattern}|\2|" | tr -d "\"' "
}

########################
# Upgrade database schema based on user inputs using the ownCloud CLI
# Globals:
#   OWNCLOUD_*
# Arguments:
#   None
# Returns:
#   None
#########################
owncloud_upgrade_database_schema() {
    local next_migration current_version installed_version
    next_migration="$(owncloud_execute_occ_print_stdout migrations:status core | grep "Next Version")"
    # Based on the logic that ownCloud uses to decide whether to print upgrade page in 'printUpgradePage' (lib/base.php)
    current_version="$(php_execute_print_output <<< "require('${OWNCLOUD_BASE_DIR}/config/config.php'); echo \$CONFIG['version'];")"
    installed_version="$(php_execute_print_output <<< "require('${OWNCLOUD_BASE_DIR}/version.php'); echo implode(\$OC_Version, '.');")"

    debug "Checking if database schema needs to be upgraded"

    # Upgrade database schema if we are not using the latest app version, or if migrations are pending
    if [[ "$current_version" != "$installed_version" || ! "$next_migration" =~ "Already at latest migration step" ]]; then
        info "Upgrading database schema"
        # Enable maintenance mode
        debug "Enabling maintenance mode"
        owncloud_execute_occ maintenance:mode --on

        # Disable apps before schema upgrade
        local app_list_file database_app_list_file
        app_list_file="$(mktemp)"
        database_app_list_file="$(mktemp)"
        # Get all enabled apps
        jq -r '.enabled | keys[]' <<< "$(owncloud_execute_occ_print_stdout app:list --no-warnings --output json)" >> "$app_list_file"
        # Get database enabled apps
        jq -r '.apps | to_entries[] | select(.value.enabled=="yes") | .key' <<< "$(owncloud_execute_occ_print_stdout config:list --no-warnings --output json)" >> "$database_app_list_file"
        # Disable apps that do not exist on the new version
        comm -13 "$app_list_file" "$database_app_list_file" | while read -r app; do
            owncloud_execute_occ app:disable "$app" --no-warnings
        done
        rm -f "$app_list_file" "$database_app_list_file"

        # Get all enabled non-shipped apps
        local -a non_shipped_app_list
        read -r -a non_shipped_app_list <<< "$(jq -r -j '.enabled | keys[] + " "' <<< "$(owncloud_execute_occ_print_stdout app:list --no-warnings --shipped=false --output json)")"
        # Disable non-shipped apps before the upgrade
        for app in "${non_shipped_app_list[@]}"; do
            # Disable all the apps except market since we use it to update the rest
            if [[ "$app" != "market" ]]; then
               owncloud_execute_occ app:disable "$app" --no-warnings
            fi
        done

        # Perform schema upgrade
        owncloud_execute_occ upgrade --no-warnings

        # Enable back non-shipped apps
        for app in "${non_shipped_app_list[@]}"; do
            owncloud_execute_occ app:enable "$app" --no-warnings
        done

        info "Database schema upgraded correctly"

        # Disable maintenance mode
        debug "Disabling maintenance mode"
        owncloud_execute_occ maintenance:mode --off
    else
        debug "Database schema is already at latest version"
    fi
}

########################
# Configure trusted domains using the ownCloud CLI
# Globals:
#   OWNCLOUD_*
# Arguments:
#   None
# Returns:
#   None
#########################
owncloud_configure_trusted_domains() {
    info "Configuring trusted domains"
    local host="${1:?missing host}"
    # We cannot use here the owncloud_conf_set because this is setting an array, not supported by the function
    # Setting host #0 to 'localhost' for ownCloud CLI access via Cron jobs
    owncloud_execute_occ config:system:delete trusted_domains
    owncloud_execute_occ config:system:set trusted_domains 0 --value "localhost"
    [[ "$host" = "localhost" ]] || owncloud_execute_occ config:system:set trusted_domains 1 --value "$host"
}

########################
# Configure SMTP using the ownCloud CLI
# Globals:
#   OWNCLOUD_*
# Arguments:
#   None
# Returns:
#   None
#########################
owncloud_configure_smtp() {
    info "Configuring SMTP"
    owncloud_conf_set mail_domain "${OWNCLOUD_EMAIL/*@}"
    owncloud_conf_set mail_from_address "${OWNCLOUD_EMAIL/@*}"
    owncloud_conf_set mail_smtpmode "smtp"
    owncloud_conf_set mail_smtphost "$OWNCLOUD_SMTP_HOST"
    owncloud_conf_set mail_smtpport "$OWNCLOUD_SMTP_PORT_NUMBER"
    if ! is_empty_value "$OWNCLOUD_SMTP_PROTOCOL"; then
        owncloud_conf_set mail_smtpsecure "$OWNCLOUD_SMTP_PROTOCOL"
    fi
    if is_empty_value "$OWNCLOUD_SMTP_USER" && is_empty_value "$OWNCLOUD_SMTP_PASSWORD"; then
        owncloud_conf_set mail_smtpauth "false"
        owncloud_conf_set mail_smtpauthtype "PLAIN"
    else
        owncloud_conf_set mail_smtpauth "true"
        owncloud_conf_set mail_smtpauthtype "LOGIN"
    fi
    owncloud_conf_set mail_smtpname "$OWNCLOUD_SMTP_USER"
    owncloud_conf_set mail_smtppassword "$OWNCLOUD_SMTP_PASSWORD"
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
owncloud_wait_for_db_connection() {
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
