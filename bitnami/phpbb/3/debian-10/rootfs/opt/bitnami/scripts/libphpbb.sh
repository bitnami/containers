#!/bin/bash
#
# Bitnami phpBB library

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
# Set an installation parameter that will be added to the installer wizard.
# Right now, the "phpbbcli install" is not working, so we need to create
# a JSON file embedded in a install_config.php script. In future versions of
# phpBB we will revisit this approach and use the CLI tool when the install
# support is working.
#
# Globals:
#   PHPBB_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
phpbb_set_installer_config() {
    local -r key="${1:?Missing key}"
    local -r value="${2:-}"
    local -r type="${3:-string}"
    local -r tempfile=$(mktemp)

    case "$type" in
    string)
        jq ". * {installer_config: { $key: \"$value\" }}" "$PHPBB_INSTALL_JSON_FILE" >"$tempfile"
        ;;
    int)
        jq ". * {installer_config: { $key: \"$value\" | tonumber }}" "$PHPBB_INSTALL_JSON_FILE" >"$tempfile"
        ;;
    bool)
        jq ". * {installer_config: { $key: \"$value\" | test(\"true\") }}" "$PHPBB_INSTALL_JSON_FILE" >"$tempfile"
        ;;
    *)
        error "Type unknown: $type"
        return 1
        ;;
    esac
    cp "$tempfile" "$PHPBB_INSTALL_JSON_FILE"
}

########################
# Validate settings in PHPBB_* env vars
# Globals:
#   PHPBB_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
phpbb_validate() {
    debug "Validating settings in PHPBB_* environment variables..."
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

    # Warn users in case the configuration file is not writable
    is_file_writable "$PHPBB_CONF_FILE" || warn "The phpBB configuration file '${PHPBB_CONF_FILE}' is not writable. Configurations based on environment variables will not be applied for this file."

    # Validate credentials
    if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    else
        for empty_env_var in "PHPBB_DATABASE_PASSWORD" "PHPBB_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        done
    fi

    # Validate SMTP credentials
    if ! is_empty_value "$PHPBB_SMTP_HOST"; then
        for empty_env_var in "PHPBB_SMTP_USER" "PHPBB_SMTP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && warn "The ${empty_env_var} environment variable is empty or not set."
        done
        is_empty_value "$PHPBB_SMTP_PORT_NUMBER" && print_validation_error "The PHPBB_SMTP_PORT_NUMBER environment variable is empty or not set."
        ! is_empty_value "$PHPBB_SMTP_PORT_NUMBER" && check_valid_port "PHPBB_SMTP_PORT_NUMBER"
        ! is_empty_value "$PHPBB_SMTP_PROTOCOL" && check_multi_value "PHPBB_SMTP_PROTOCOL" "plain ssl tls"
    fi

    # Check that the web server is properly set up
    web_server_validate || print_validation_error "Web server validation failed"

    return "$error_code"
}

########################
# Ensure phpBB is initialized
# Globals:
#   PHPBB_*
# Arguments:
#   None
# Returns:
#   None
#########################
phpbb_initialize() {

    # Check if phpBB has already been initialized and persisted in a previous run
    local db_host db_port db_name db_user db_pass
    local -r app_name="phpbb"
    if ! is_app_initialized "$app_name"; then
        # Ensure phpBB persisted directories exist (i.e. when a volume has been mounted to /bitnami)
        info "Ensuring phpBB directories exist"
        ensure_dir_exists "$PHPBB_VOLUME_DIR"

        # Use daemon:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$PHPBB_VOLUME_DIR" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
        info "Trying to connect to the database server"
        db_host="$PHPBB_DATABASE_HOST"
        db_port="$PHPBB_DATABASE_PORT_NUMBER"
        db_name="$PHPBB_DATABASE_NAME"
        db_user="$PHPBB_DATABASE_USER"
        db_pass="$PHPBB_DATABASE_PASSWORD"
        phpbb_wait_for_db_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"

        info "Creating configuration file for installation"
        phpbb_set_installer_config "admin_name" "$PHPBB_USERNAME"
        phpbb_set_installer_config "admin_passwd" "$PHPBB_PASSWORD"
        phpbb_set_installer_config "board_email" "$PHPBB_EMAIL"
        phpbb_set_installer_config "lang" "$PHPBB_FORUM_LANGUAGE"
        phpbb_set_installer_config "board_name" "$PHPBB_FORUM_NAME"
        phpbb_set_installer_config "board_description" "$PHPBB_FORUM_DESCRIPTION"
        phpbb_set_installer_config "dbhost" "$PHPBB_DATABASE_HOST"
        phpbb_set_installer_config "dbport" "$PHPBB_DATABASE_PORT_NUMBER" "int"
        phpbb_set_installer_config "dbuser" "$PHPBB_DATABASE_USER"
        phpbb_set_installer_config "dbpasswd" "$PHPBB_DATABASE_PASSWORD"
        phpbb_set_installer_config "dbname" "$PHPBB_DATABASE_NAME"
        phpbb_set_installer_config "dbms" "mysqli"
        phpbb_set_installer_config "table_prefix" "phpbb_"
        phpbb_set_installer_config "script_path" "/"
        phpbb_set_installer_config "server_name" "$PHPBB_HOST"
        phpbb_set_installer_config "server_protocol" "$PHPBB_FORUM_SERVER_PROTOCOL"
        phpbb_set_installer_config "server_port" "$PHPBB_FORUM_SERVER_PORT"
        phpbb_set_installer_config "cookie_secure" "$PHPBB_COOKIE_SECURE" "bool"
        phpbb_set_installer_config "force_server_vars" "0" "int"
        if ! is_empty_value "$PHPBB_SMTP_HOST"; then
            info "Configuring SMTP credentials"
            phpbb_set_installer_config "email_enable" "true" "bool"
            phpbb_set_installer_config "smtp_host" "$PHPBB_SMTP_HOST"
            phpbb_set_installer_config "smtp_port" "$PHPBB_SMTP_PORT" "int"
            phpbb_set_installer_config "smtp_auth" "$PHPBB_SMTP_PROTOCOL"
            phpbb_set_installer_config "smtp_user" "$PHPBB_SMTP_USER"
            phpbb_set_installer_config "smtp_pass" "$PHPBB_SMTP_PASSWORD"
            phpbb_set_installer_config "smtp_delivery" "1" "int"
        fi

        if ! is_boolean_yes "$PHPBB_SKIP_BOOTSTRAP"; then
            phpbb_pass_wizard
            local -a mysql_execute_args=("$db_host" "$db_port" "$db_name" "$db_user" "$db_pass")
            if is_boolean_yes "$PHPBB_DISABLE_SESSION_VALIDATION"; then
                # In Kubernetes installations, the ephemeral nature of the pods and the service redirections
                # cause issues with session management: https://github.com/bitnami/charts/issues/80
                info "Disabling session validation"
                mysql_remote_execute "${mysql_execute_args[@]}" <<EOF
UPDATE phpbb_config SET config_value='0' WHERE config_name='browser_check';
UPDATE phpbb_config SET config_value='0' WHERE config_name='ip_check';
EOF
            fi
        else
            info "An already initialized phpBB database was provided"
            info "Creating configuration file without running the installer and migrate database schema"
            # The config file must be regenerated manually according to https://www.phpbb.com/support/docs/en/3.3/kb/article/rebuilding-your-configphp-file/
            render-template "${BITNAMI_ROOT_DIR}/scripts/phpbb/files/config.php.tpl" >"${PHPBB_CONF_FILE}"
            php "${PHPBB_BIN_DIR}/phpbbcli.php" "db:migrate" "--safe-mode"
        fi

        info "Persisting phpBB installation"
        persist_app "$app_name" "$PHPBB_DATA_TO_PERSIST"
    else
        info "Restoring persisted phpBB installation"
        restore_persisted_app "$app_name" "$PHPBB_DATA_TO_PERSIST"
        db_host="$(phpbb_conf_get "\$dbhost")"
        db_port="$(phpbb_conf_get "\$dbport")"
        db_name="$(phpbb_conf_get "\$dbname")"
        db_user="$(phpbb_conf_get "\$dbuser")"
        db_pass="$(phpbb_conf_get "\$dbpasswd")"
        phpbb_wait_for_db_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
        info "Upgrading database schema"
        php "${PHPBB_BIN_DIR}/phpbbcli.php" "db:migrate" "--safe-mode"
    fi

    # Remove the installation files to avoid automatic redirection to the installation wizard
    if [[ -d "$PHPBB_WIZARD_DIR" ]]; then
        info "Removing installation files"
        rm -r "$PHPBB_WIZARD_DIR"
    fi
    am_i_root && configure_permissions_ownership "$PHPBB_CACHE_DIR" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Get an entry from the phpBB configuration file (config.inc.php)
# Globals:
#   PHPBB_*
# Arguments:
#   $1 - PHP variable name
# Returns:
#   None
#########################
phpbb_conf_get() {
    local -r key="${1:?key missing}"
    debug "Getting ${key} from phpBB configuration"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(//\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<<"$key")\s*=([^;]+);"
    debug "$sanitized_pattern"
    grep -E "$sanitized_pattern" "$PHPBB_CONF_FILE" | sed -E "s|${sanitized_pattern}|\2|" | tr -d "\"' "
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
phpbb_wait_for_db_connection() {
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
# Pass phpBB wizard
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   true if the wizard succeeded, false otherwise
#########################
phpbb_pass_wizard() {
    local -r port="${WEB_SERVER_HTTP_PORT_NUMBER:-"$WEB_SERVER_DEFAULT_HTTP_PORT_NUMBER"}"
    local wizard_url cookie_file curl_output
    local -a curl_opts curl_data_opts
    # Create php settings file based on the json
    wizard_url="http://127.0.0.1:${port}/install/app.php/install"
    cookie_file="/tmp/cookie$(generate_random_string -t alphanumeric -c 8)"
    curl_opts=(
        "--location"
        "--silent"
        "--cookie" "$cookie_file"
        "--cookie-jar" "$cookie_file"
        "-H" "content-type:application/x-www-form-urlencoded"
        "-H" "X-Requested-With: XMLHttpRequest"
    )
    # Ensure the web server is started
    web_server_start
    info "Running installation wizard"
    # Step 0: Get cookies
    curl "${curl_opts[@]}" "$wizard_url" >/dev/null 2>&1
    # Step 1.0: Prepare installation
    curl_data_opts=(
        "--data-urlencode" "default_lang=${PHPBB_FORUM_LANGUAGE}"
        "--data-urlencode" "board_name=${PHPBB_FORUM_NAME}"
        "--data-urlencode" "board_description=${PHPBB_FORUM_DESCRIPTION}"
        "--data-urlencode" "submit_board=Submit"
    )
    wizard_url_post(){
        echo "<?php // $(jq -c . "$PHPBB_INSTALL_JSON_FILE" | sed 's%/%\\/%g')" >"$PHPBB_INSTALL_PHP_FILE"
        curl_output="$(curl -X POST "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}")"
        debug "${curl_output}"
    }
    # Step 1.2: Execute installation
    wizard_url_post

    # Heart beat to keep alive the installation process
    phpbb_heartbeat() {
        if [[ "$curl_output" = *"finished successfully"* ]]; then
            return
        elif [[ "$curl_output" = *"errors"* ]]; then
            # If any error appears it will be retried
            wizard_url_post
        else
            curl_output="$(curl -X GET "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}")"
            debug "${curl_output}"
        fi

        false
    }

    # The installation process needs a continuous health check to keep alive the progress
    if ! retry_while "phpbb_heartbeat"; then
        error "phpBB failed to install"
        error_code=1
    else
        info "phpBB installed successfully"
    fi

    # Stop the web server afterwards
    web_server_stop
}
