#!/bin/bash
#
# Bitnami Osclass library

# shellcheck disable=SC1091

# Load generic libraries
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libpersistence.sh
. /opt/bitnami/scripts/libwebserver.sh
. /opt/bitnami/scripts/libservice.sh

# Load database library
if [[ -f /opt/bitnami/scripts/libmysqlclient.sh ]]; then
    . /opt/bitnami/scripts/libmysqlclient.sh
elif [[ -f /opt/bitnami/scripts/libmysql.sh ]]; then
    . /opt/bitnami/scripts/libmysql.sh
elif [[ -f /opt/bitnami/scripts/libmariadb.sh ]]; then
    . /opt/bitnami/scripts/libmariadb.sh
fi

########################
# Validate settings in OSCLASS_* env vars
# Globals:
#   OSCLASS_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
osclass_validate() {
    debug "Validating settings in OSCLASS_* environment variables..."
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

    check_empty_value "OSCLASS_WEB_TITLE"
    ! is_empty_value "$OSCLASS_SKIP_BOOTSTRAP" && check_yes_no_value "OSCLASS_SKIP_BOOTSTRAP"
    ! is_empty_value "$OSCLASS_DATABASE_HOST" && check_resolved_hostname "$OSCLASS_DATABASE_HOST"
    ! is_empty_value "$OSCLASS_DATABASE_PORT_NUMBER" && validate_port "$OSCLASS_DATABASE_PORT_NUMBER"

    # Validate credentials
    if is_boolean_yes "${ALLOW_EMPTY_PASSWORD:-}"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD:-}. For safety reasons, do not use this flag in a production environment."
    else
        for empty_env_var in "OSCLASS_DATABASE_PASSWORD" "OSCLASS_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        done
    fi

    # Validate SMTP credentials
    if ! is_empty_value "$OSCLASS_SMTP_HOST"; then
        for empty_env_var in "OSCLASS_SMTP_USER" "OSCLASS_SMTP_PASSWORD" "OSCLASS_SMTP_PORT_NUMBER"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set."
        done
        ! is_empty_value "$OSCLASS_SMTP_PROTOCOL" && check_multi_value "OSCLASS_SMTP_PROTOCOL" "ssl tls"
    fi

    # Check that the web server is properly set up
    web_server_validate || print_validation_error "Web server validation failed"

    return "$error_code"
}

########################
# Ensure Osclass is initialized
# Globals:
#   OSCLASS_*
# Arguments:
#   None
# Returns:
#   None
#########################
osclass_initialize() {
    # Check if Osclass has already been initialized and persisted in a previous run
    local -r app_name="osclass"
    if ! is_app_initialized "$app_name"; then
        # Ensure Osclass persisted directories exist (i.e. when a volume has been mounted to /bitnami)
        info "Ensuring Osclass directories exist"
        ensure_dir_exists "$OSCLASS_VOLUME_DIR"
        # Use daemon:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$OSCLASS_VOLUME_DIR" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
        info "Trying to connect to the database server"
        osclass_wait_for_mysql_connection "$OSCLASS_DATABASE_HOST" "$OSCLASS_DATABASE_PORT_NUMBER" "$OSCLASS_DATABASE_NAME" "$OSCLASS_DATABASE_USER" "$OSCLASS_DATABASE_PASSWORD"

        if ! is_boolean_yes "$OSCLASS_SKIP_BOOTSTRAP"; then
            info "Installing Osclass"
            osclass_pass_wizard
        else
            # We copy the sample configuration file and modify it, as the installer will not generate it
            info "An already initialized Osclass database was provided, configuration will be skipped"
            cp "${OSCLASS_BASE_DIR}/config-sample.php" "$OSCLASS_CONF_FILE"
            if [[ "$OSCLASS_DATABASE_PORT_NUMBER" == "3306" ]]; then
                osclass_conf_set "DB_HOST" "$OSCLASS_DATABASE_HOST"
            else
                osclass_conf_set "DB_HOST" "${OSCLASS_DATABASE_HOST}:${OSCLASS_DATABASE_PORT_NUMBER}"
            fi
            osclass_conf_set "DB_USER" "$OSCLASS_DATABASE_USER"
            osclass_conf_set "DB_PASSWORD" "$OSCLASS_DATABASE_PASSWORD"
            osclass_conf_set "DB_NAME" "$OSCLASS_DATABASE_NAME"
            # In the sample configuration file the relative web url is set to "relhere", we need to change it
            osclass_conf_set "REL_WEB_URL" "/"
            osclass_pass_upgrade_wizard
        fi

        # We maintain the OSCLASS_HOST variable for backwards compatibility. If the user does not set it
        # then the modify the WEB_PATH setting in config.php file to allow any host, both HTTP and HTTPS.
        if is_empty_value "$OSCLASS_HOST"; then
            # sed replacement notes:
            # - The ampersand ('&') is escaped due to sed replacing any non-escaped ampersand characters with the matched string
            # - For the replacement text to be multi-line, an \ needs to be specified to escape the newline character
            local -r conf_to_replace="if (empty(\$_SERVER['HTTP_HOST'])) {\\
    define('WEB_PATH', 'http://127.0.0.1:${WEB_SERVER_HTTP_PORT_NUMBER}/');\\
} else if (isset(\$_SERVER['HTTPS']) \&\& \$_SERVER['HTTPS'] == 'on') {\\
    define('WEB_PATH','https://' . \$_SERVER['HTTP_HOST'] . '/');\\
} else {\\
    define('WEB_PATH','http://' . \$_SERVER['HTTP_HOST'] . '/');\\
}"
            replace_in_file "$OSCLASS_CONF_FILE" "define.*WEB_PATH.*" "$conf_to_replace"
        else
            osclass_conf_set "WEB_PATH" "$OSCLASS_HOST"
        fi

        # SMTP configuration tweaking the System Settings via Database
        # Based on https://docs.osclasspoint.com/setting-up-a-mail-server
        if ! is_empty_value "$OSCLASS_SMTP_HOST"; then
            local -a mysql_execute_args=("$OSCLASS_DATABASE_HOST" "$OSCLASS_DATABASE_PORT_NUMBER" "$OSCLASS_DATABASE_NAME" "$OSCLASS_DATABASE_USER" "$OSCLASS_DATABASE_PASSWORD")
            info "Configuring SMTP"
            settings_to_update=(
                "mailserver_auth=1"
                "mailserver_pop=0"
                "mailserver_host=${OSCLASS_SMTP_HOST}"
                "mailserver_port=${OSCLASS_SMTP_PORT_NUMBER}"
                "mailserver_username=${OSCLASS_SMTP_USER}"
                "mailserver_mail_from=${OSCLASS_EMAIL}"
                "mailserver_password=${OSCLASS_SMTP_PASSWORD}"
                "mailserver_ssl=${OSCLASS_SMTP_PROTOCOL}"
            )

            for setting in "${settings_to_update[@]}"; do
                # We split the key and value with the '=' delimiter via native Bash functionality to simplify the logic
                mysql_remote_execute "${mysql_execute_args[@]}" <<<"UPDATE oc_t_preference SET s_value='${setting#*=}' WHERE s_name='${setting%=*}';"
            done
        fi

        info "Persisting Osclass installation"
        persist_app "$app_name" "$OSCLASS_DATA_TO_PERSIST"
    else
        info "Restoring persisted Osclass installation"
        restore_persisted_app "$app_name" "$OSCLASS_DATA_TO_PERSIST"
        info "Trying to connect to the database server"
        local db_host_port db_host db_port db_name db_user db_pass
        db_host_port="$(osclass_conf_get "DB_HOST")"
        db_host="${db_host_port%:*}"
        if [[ "$db_host_port" =~ :[0-9]+$ ]]; then
            # Use '##' to extract only the part after the last colon, to avoid any possible issues with IPv6 addresses
            db_port="${db_host_port##*:}"
        else
            db_port="$OSCLASS_DATABASE_PORT_NUMBER"
        fi
        db_name="$(osclass_conf_get "DB_NAME")"
        db_user="$(osclass_conf_get "DB_USER")"
        db_pass="$(osclass_conf_get "DB_PASSWORD")"
        osclass_wait_for_mysql_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
        osclass_pass_upgrade_wizard
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Add or modify an entry in the Osclass configuration file (config.inc.php)
# Globals:
#   OSCLASS_*
# Arguments:
#   $1 - PHP constant name
#   $2 - Value to assign to the PHP variable
#   $3 - Configuration file to modify
# Returns:
#   None
#########################
osclass_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:-}"
    local -r file="${3:-$OSCLASS_CONF_FILE}"
    debug "Setting ${key} to '${value}' in Osclass configuration file ${file}"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(//\s*)?define\s*\(['\"]$(sed 's/[]\[^$.*/]/\\&/g' <<<"$key")['\"]\s*,.*"
    local -r entry="define('${key}', '$value');"
    # Check if the configuration exists in the file
    if grep -q -E "$sanitized_pattern" "$file"; then
        # It exists, so replace the line
        replace_in_file "$file" "$sanitized_pattern" "$entry"
    else
        # The Osclass configuration file includes all supported keys, but because of its format,
        # we cannot append contents to the end. We can assume thi
        warn "Could not set the Osclass '${key}' configuration. Check that the file has not been modified externally."
    fi
}

########################
# Get an entry from the Osclass configuration file (config.inc.php)
# Globals:
#   OSCLASS_*
# Arguments:
#   $1 - PHP constant name
#   $2 - Configuration file to read
# Returns:
#   None
#########################
osclass_conf_get() {
    local -r key="${1:?key missing}"
    local -r file="${2:-$OSCLASS_CONF_FILE}"
    debug "Getting ${key} from Osclass configuration"
    php -r "require ('${OSCLASS_CONF_FILE}'); print ${key};"
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
osclass_wait_for_mysql_connection() {
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
# Pass Osclass wizard
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   true if the wizard succeeded, false otherwise
#########################
osclass_pass_wizard() {
    local -r port="${WEB_SERVER_HTTP_PORT_NUMBER:-"$WEB_SERVER_DEFAULT_HTTP_PORT_NUMBER"}"
    local wizard_url wizard_install_location_url cookie_file curl_output
    local -a curl_opts curl_data_opts
    wizard_url="http://127.0.0.1:${port}/oc-includes/osclass/install.php"
    wizard_install_location_url="http://127.0.0.1:${port}/oc-includes/osclass/install-location.php"
    cookie_file="/tmp/cookie$(generate_random_string -t alphanumeric -c 8)"
    curl_opts=("--location" "--silent" "--cookie" "$cookie_file" "--cookie-jar" "$cookie_file")
    # Ensure the web server is started
    web_server_start
    # Step 0: Get cookies
    debug_execute curl "${curl_opts[@]}" "$wizard_url" 2>/dev/null
    # Step 1: Requirements check
    curl_data_opts=(
        "--data-urlencode" "step=2"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}" 2>/dev/null)"
    debug_execute echo "$curl_output"
    # Step 2: Database settings
    curl_data_opts=(
        "--data-urlencode" "step=3"
        "--data-urlencode" "dbhost=${OSCLASS_DATABASE_HOST}"
        "--data-urlencode" "dbname=${OSCLASS_DATABASE_NAME}"
        "--data-urlencode" "username=${OSCLASS_DATABASE_USER}"
        "--data-urlencode" "password=${OSCLASS_DATABASE_PASSWORD}"
        "--data-urlencode" "tableprefix=oc_"
        "--data-urlencode" "submit=Next"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}" 2>/dev/null)"
    debug_execute echo "$curl_output"
    # Step 3: User settings
    curl_data_opts=(
        "--data-urlencode" "s_name=${OSCLASS_USERNAME}"
        "--data-urlencode" "s_passwd=${OSCLASS_PASSWORD}"
        "--data-urlencode" "webtitle=${OSCLASS_WEB_TITLE}"
        "--data-urlencode" "email=${OSCLASS_EMAIL}"
        "--data-urlencode" "skip-location-input=0"
        "--data-urlencode" "locationsql=US-United_States.sql"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_install_location_url}" 2>/dev/null)"
    debug_execute echo "$curl_output"
    # Step 4: Confirm user settings
    curl_data_opts=(
        "--data-urlencode" "step=4"
        "--data-urlencode" "password=${OSCLASS_PASSWORD}"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}" 2>/dev/null)"
    debug_execute echo "$curl_output"
    if [[ "$curl_output" != *"Congratulations"* ]]; then
        error "An error occurred while installing Osclass"
        return 1
    fi
    # Stop the web server afterwards
    web_server_stop
}

########################
# Pass Osclass upgrade wizard
# Based on https://docs.osclasspoint.com/updating-osclass
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   true if the wizard succeeded, false otherwise
#########################
osclass_pass_upgrade_wizard() {
    local -r port="${WEB_SERVER_HTTP_PORT_NUMBER:-"$WEB_SERVER_DEFAULT_HTTP_PORT_NUMBER"}"
    local wizard_url wizard_install_location_url cookie_file curl_output octoken
    local -a curl_opts curl_data_opts
    info "Passing update wizard"
    # Update wizard url
    wizard_url="http://127.0.0.1:${port}/oc-admin/index.php"
    cookie_file="/tmp/cookie$(generate_random_string -t alphanumeric -c 8)"
    octoken_file="$(mktemp)"
    curl_opts=("--location" "--silent" "--cookie" "$cookie_file" "--cookie-jar" "$cookie_file")
    # Ensure the web server is started
    web_server_start
    # Step 0: Get cookies and oc-token
    curl "${curl_opts[@]}" "$wizard_url" 2>/dev/null >"$octoken_file"
    # Extract octoken from the HTML
    octoken="$(grep -o "octoken.*value=[\"'][^\"']*[\"']" "$octoken_file" | awk -F= '{print $2}' | sed "s/[\"']//g")"
    # Step 1: Login
    curl_data_opts=(
        "--data-urlencode" "octoken=${octoken}"
        "--data-urlencode" "page=login"
        "--data-urlencode" "action=login_post"
        "--data-urlencode" "user=${OSCLASS_USERNAME}"
        "--data-urlencode" "password=${OSCLASS_PASSWORD}"
        "--data-urlencode" "locale=en_US"
        "--data-urlencode" "submit="
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}" 2>/dev/null)"
    debug_execute echo "$curl_output"
    # Step 2: Launch upgrade
    curl_data_opts=(
        "--data-urlencode" "octoken=${octoken}"
        "--data-urlencode" "page=upgrade"
        "--data-urlencode" "action=upgrade-funcs"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}" 2>/dev/null)"
    # Step 3: Check upgrade
    curl_data_opts=(
        "--data-urlencode" "octoken=${octoken}"
        "--data-urlencode" "page=tools"
        "--data-urlencode" "action=version"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}" 2>/dev/null)"
    debug_execute echo "$curl_output"
    if [[ "$curl_output" != *"Osclass has been updated successfully"* ]]; then
        error "An error occurred while installing Osclass"
        return 1
    fi
    # Stop the web server afterwards
    web_server_stop
}
