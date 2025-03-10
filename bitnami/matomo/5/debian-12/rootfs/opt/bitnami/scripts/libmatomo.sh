#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Matomo library

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
# Validate settings in MATOMO_* env vars
# Globals:
#   MATOMO_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
matomo_validate() {
    debug "Validating settings in MATOMO_* environment variables..."
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
        for empty_env_var in "MATOMO_DATABASE_PASSWORD" "MATOMO_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        done
    fi

    # Check yes no values
    for yes_no_var in "MATOMO_ENABLE_DATABASE_SSL" "MATOMO_ENABLE_PROXY_URI_HEADER" "MATOMO_VERIFY_DATABASE_SSL" "MATOMO_ENABLE_FORCE_SSL" "MATOMO_ENABLE_ASSUME_SECURE_PROTOCOL"; do
        check_yes_no_value "${yes_no_var}"
    done

    # Validate SMTP credentials
    if ! is_empty_value "$MATOMO_SMTP_HOST"; then
        for empty_env_var in "MATOMO_SMTP_USER" "MATOMO_SMTP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && warn "The ${empty_env_var} environment variable is empty or not set."
        done
        is_empty_value "$MATOMO_SMTP_PORT_NUMBER" && print_validation_error "The MATOMO_SMTP_PORT_NUMBER environment variable is empty or not set."
        ! is_empty_value "$MATOMO_SMTP_PORT_NUMBER" && check_valid_port "MATOMO_SMTP_PORT_NUMBER"
        ! is_empty_value "$MATOMO_SMTP_PROTOCOL" && check_multi_value "MATOMO_SMTP_PROTOCOL" "ssl tls none"
        ! is_empty_value "$MATOMO_SMTP_AUTH" && check_multi_value "MATOMO_SMTP_AUTH" "Plain Login Cram-md5"
    fi

    # Check that the web server is properly set up
    web_server_validate || print_validation_error "Web server validation failed"

    return "$error_code"
}

########################
# Ensure Matomo is initialized
# Globals:
#   MATOMO_*
# Arguments:
#   None
# Returns:
#   None
#########################
matomo_initialize() {
    # Update Matomo configuration via mounted configuration files and environment variables
    # Check if Matomo has already been initialized and persisted in a previous run
    local db_host db_port db_name db_user db_pass
    local -r app_name="matomo"
    if ! is_app_initialized "$app_name"; then
        # Ensure Matomo persisted directories exist (i.e. when a volume has been mounted to /bitnami)
        info "Ensuring Matomo directories exist"
        ensure_dir_exists "$MATOMO_VOLUME_DIR"
        # Use daemon:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$MATOMO_VOLUME_DIR" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
        info "Trying to connect to the database server"
        db_host="$MATOMO_DATABASE_HOST"
        db_port="$MATOMO_DATABASE_PORT_NUMBER"
        db_name="$MATOMO_DATABASE_NAME"
        db_user="$MATOMO_DATABASE_USER"
        db_pass="$MATOMO_DATABASE_PASSWORD"
        matomo_wait_for_db_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"

        if ! is_boolean_yes "$MATOMO_SKIP_BOOTSTRAP"; then
            matomo_pass_wizard
            local -a mysql_execute_args=("$db_host" "$db_port" "$db_name" "$db_user" "$db_pass")
            if am_i_root; then
                ## If the application is running as root, the cron jobs will be executed, so we need to disable
                ## the browser-triggered archiving so the "Last Successful Archiving Completion" check passes.
                ## In a non-root container we can only use the browser-triggered archiving, meaning that the
                ## system check will show a warning (but not a failure)
                ## https://matomo.org/docs/setup-auto-archiving/
                mysql_remote_execute "${mysql_execute_args[@]}" <<EOF
REPLACE INTO matomo_option VALUES ("enableBrowserTriggerArchiving","0",1);
EOF
            fi
        else
            info "An already initialized Matomo database was provided, configuration will be skipped"
            ## Unfortunately, due to how Matomo is designed, it requires passing through the wizard which will not only
            ## re-install the application, but also has some limitations (i.e. supporting only non-SSL db connections)
            ## Therefore, we'll make use of a valid configuration base to modify it to our interest
            ## NOTE: After the first user access, Matomo will re-write the file as if it were created by the wizard
            cp "$MATOMO_CONF_DIR"/global.ini.php "$MATOMO_CONF_FILE"
            # We need the configuration file to be writable
            am_i_root && configure_permissions_ownership "$MATOMO_CONF_FILE" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
            info "Setting database configuration"
            ini-file set -s "database" -k "host" -v "$db_host" "$MATOMO_CONF_FILE"
            ini-file set -s "database" -k "username" -v "$db_user" "$MATOMO_CONF_FILE"
            ini-file set -s "database" -k "password" -v "$db_pass" "$MATOMO_CONF_FILE"
            ini-file set -s "database" -k "port" -v "$db_port" "$MATOMO_CONF_FILE"
            ini-file set -s "database" -k "dbname" -v "$db_name" "$MATOMO_CONF_FILE"
            ini-file set -s "database" -k "adapter" -v "MYSQLI" "$MATOMO_CONF_FILE"
            ini-file set -s "database" -k "tables_prefix" -v "$MATOMO_DATABASE_TABLE_PREFIX" "$MATOMO_CONF_FILE"
        fi

        # Reverse Proxy Configuration options
        if is_boolean_yes "$MATOMO_ENABLE_PROXY_URI_HEADER"; then
            info "Configuring Matomo to use the HTTP_X_FORWARDED_URI header"
            ini-file set -s "General" -k "proxy_uri_header" -v "1" "$MATOMO_CONF_FILE"
        fi

        if ! is_empty_value "$MATOMO_PROXY_CLIENT_HEADER"; then
        info "Configuring Matomo to check proxy_client_headers for client IP"
            ini-file set -s "General" -k "proxy_client_headers[]" -v "$MATOMO_PROXY_CLIENT_HEADER" "$MATOMO_CONF_FILE"
        fi

        if is_boolean_yes "$MATOMO_ENABLE_ASSUME_SECURE_PROTOCOL"; then
            info "Configuring Matomo to always assume secure protocol"
            ini-file set -s "General" -k "assume_secure_protocol" -v "1" "$MATOMO_CONF_FILE"
        fi

        if is_boolean_yes "$MATOMO_ENABLE_FORCE_SSL"; then
            info "Configuring Matomo to force ssl"
            ini-file set -s "General" -k "force_ssl" -v "1" "$MATOMO_CONF_FILE"
        fi

        if ! is_empty_value "$MATOMO_PROXY_HOST_HEADER"; then
        info "Configuring Matomo to check proxy_host_headers for client IP"
            ini-file set -s "General" -k "proxy_host_headers[]" -v "$MATOMO_PROXY_HOST_HEADER" "$MATOMO_CONF_FILE"
        fi

        # Database SSL
        if is_boolean_yes "$MATOMO_ENABLE_DATABASE_SSL"; then
            info "Enabling database SSL"
            ini-file set -s "database" -k "enable_ssl" -v "1" "$MATOMO_CONF_FILE"
            ! is_empty_value "$MATOMO_DATABASE_SSL_CA_FILE" && ini-file set -s "database" -k "ssl_ca" -v "$MATOMO_DATABASE_SSL_CA_FILE" "$MATOMO_CONF_FILE"
            ! is_empty_value "$MATOMO_DATABASE_SSL_CERT_FILE" && ini-file set -s "database" -k "ssl_cert" -v "$MATOMO_DATABASE_SSL_CERT_FILE" "$MATOMO_CONF_FILE"
            ! is_empty_value "$MATOMO_DATABASE_SSL_KEY_FILE" && ini-file set -s "database" -k "ssl_key" -v "$MATOMO_DATABASE_SSL_KEY_FILE" "$MATOMO_CONF_FILE"
            ! is_boolean_yes "$MATOMO_VERIFY_DATABASE_SSL" && ini-file set -s "database" -k "ssl_no_verify" -v "1" "$MATOMO_CONF_FILE"
        fi

        # Trusted host check
        if is_boolean_yes "$MATOMO_ENABLE_TRUSTED_HOST_CHECK"; then
            ini-file set -s "General" -k "enable_trusted_host_check" -v "1" "$MATOMO_CONF_FILE"
        else
            ini-file set -s "General" -k "enable_trusted_host_check" -v "0" "$MATOMO_CONF_FILE"
        fi

        # SMTP
        if ! is_empty_value "$MATOMO_SMTP_HOST"; then
            info "Configuring SMTP credentials"
            ini-file set -s "mail" -k "transport" -v "smtp" "$MATOMO_CONF_FILE"
            ini-file set -s "mail" -k "port" -v "$MATOMO_SMTP_PORT_NUMBER" "$MATOMO_CONF_FILE"
            ini-file set -s "mail" -k "host" -v "$MATOMO_SMTP_HOST" "$MATOMO_CONF_FILE"
            ini-file set -s "mail" -k "username" -v "$MATOMO_SMTP_USER" "$MATOMO_CONF_FILE"
            ini-file set -s "mail" -k "password" -v "$MATOMO_SMTP_PASSWORD" "$MATOMO_CONF_FILE"
            ini-file set -s "mail" -k "type" -v "$MATOMO_SMTP_AUTH" "$MATOMO_CONF_FILE"
            ini-file set -s "mail" -k "encryption" -v "$MATOMO_SMTP_PROTOCOL" "$MATOMO_CONF_FILE"
            # Optional noreply name and address
            if ! is_empty_value "$MATOMO_NOREPLY_NAME"; then
                ini-file set -s "General" -k "noreply_email_name" -v "$MATOMO_NOREPLY_NAME" "$MATOMO_CONF_FILE"
            fi
            if ! is_empty_value "$MATOMO_NOREPLY_ADDRESS"; then
                ini-file set -s "General" -k "noreply_email_address" -v "$MATOMO_NOREPLY_ADDRESS" "$MATOMO_CONF_FILE"
            fi
        fi

        info "Persisting Matomo installation"
        persist_app "$app_name" "$MATOMO_DATA_TO_PERSIST"
    else
        info "Persisted Matomo installation detected"
        info "Updating Matomo files in persisted data"
        rsync_args=("-a" "$MATOMO_BASE_DIR"/* "$MATOMO_VOLUME_DIR" "--exclude" "$(realpath --relative-to="$MATOMO_BASE_DIR" "$MATOMO_CONF_FILE")")
        read -r -a extra_excluded_data <<< "$(tr ',;:' ' ' <<< "$MATOMO_EXCLUDED_DATA_FROM_UPDATE")"
        for file in "${extra_excluded_data[@]}"; do
            rsync_args+=("--exclude")
            rsync_args+=("$(realpath --relative-to="$MATOMO_BASE_DIR" "$file")")
        done
        rsync "${rsync_args[@]}"
        info "Restoring Matomo installation"
        restore_persisted_app "$app_name" "$MATOMO_DATA_TO_PERSIST"
        info "Trying to connect to the database server"
        db_host="$(ini-file get -s "database" -k "host" "$MATOMO_CONF_FILE")"
        db_port="$(ini-file get -s "database" -k "port" "$MATOMO_CONF_FILE")"
        # If port is 3306 it will not appear in the configuration file
        is_empty_value "$db_port" && db_port="3306"
        db_name="$(ini-file get -s "database" -k "dbname" "$MATOMO_CONF_FILE")"
        db_user="$(ini-file get -s "database" -k "username" "$MATOMO_CONF_FILE")"
        db_pass="$(ini-file get -s "database" -k "password" "$MATOMO_CONF_FILE")"
        matomo_wait_for_db_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
        info "Launching schema update"
        php "$MATOMO_BASE_DIR"/console "core:update" "--yes"
        am_i_root && configure_permissions_ownership "$MATOMO_BASE_DIR"/tmp -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
        debug "Re-creating .htaccess files"
        php "$MATOMO_BASE_DIR"/console "core:create-security-files"
    fi

    ## Ensure Matomo cron jobs are created when running setup with a root user
    ## This is necessary for the "Last Successful Archiving Completion" system check to pass
    ## https://matomo.org/docs/setup-auto-archiving/
    if am_i_root; then
        local -r port="${WEB_SERVER_HTTP_PORT_NUMBER:-"$WEB_SERVER_DEFAULT_HTTP_PORT_NUMBER"}"
        info "Configuring cron jobs"
        local -a cron_cmd=("${PHP_BIN_DIR}/php" "${MATOMO_BASE_DIR}/console" "core:archive" "--url=http://127.0.0.1:${port}")
        generate_cron_conf "matomo" "${cron_cmd[*]} > /dev/null 2>> ${MATOMO_BASE_DIR}/tmp/logs/matomo-cron.log" --run-as "$WEB_SERVER_DAEMON_USER" --schedule "*/1 * * * *"
    else
        warn "Skipping cron configuration for Matomo because of running as a non-root user"
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Add or modify an entry in the Matomo configuration file (config.inc.php)
# Globals:
#   MATOMO_*
# Arguments:
#   $1 - PHP variable name
#   $2 - Value to assign to the PHP variable
#   $3 - Whether the value is a literal, or if instead it should be quoted (default: no)
# Returns:
#   None
#########################
matomo_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:?value missing}"
    local -r is_literal="${3:-no}"
    debug "Setting ${key} to '${value}' in Matomo configuration (literal: ${is_literal})"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(//\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<<"$key")\s*=.*"
    local entry
    is_boolean_yes "$is_literal" && entry="${key} = $value;" || entry="${key} = '$value';"
    # Check if the configuration exists in the file
    if grep -q -E "$sanitized_pattern" "$MATOMO_CONF_FILE"; then
        # It exists, so replace the line
        replace_in_file "$MATOMO_CONF_FILE" "$sanitized_pattern" "$entry"
    else
        # The Matomo configuration file includes all supported keys, but because of its format,
        # we cannot append contents to the end. We can assume thi
        warn "Could not set the Matomo '${key}' configuration. Check that the file has not been modified externally."
    fi
}

########################
# Get an entry from the Matomo configuration file (config.inc.php)
# Globals:
#   MATOMO_*
# Arguments:
#   $1 - PHP variable name
# Returns:
#   None
#########################
matomo_conf_get() {
    local -r key="${1:?key missing}"
    debug "Getting ${key} from Matomo configuration"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(//\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<<"$key")\s*=([^;]+);"
    debug "$sanitized_pattern"
    grep -E "$sanitized_pattern" "$MATOMO_CONF_FILE" | sed -E "s|${sanitized_pattern}|\2|" | tr -d "\"' "
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
matomo_wait_for_db_connection() {
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
# Pass Matomo wizard
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   true if the wizard succeeded, false otherwise
#########################
matomo_pass_wizard() {
    local -r port="${WEB_SERVER_HTTP_PORT_NUMBER:-"$WEB_SERVER_DEFAULT_HTTP_PORT_NUMBER"}"
    local wizard_url cookie_file curl_output
    local -a curl_opts curl_data_opts
    wizard_url="http://127.0.0.1:${port}/"
    cookie_file="/tmp/cookie$(generate_random_string -t alphanumeric -c 8)"
    curl_opts=("--location" "--silent" "--cookie" "$cookie_file" "--cookie-jar" "$cookie_file")
    # Ensure the web server is started
    web_server_start
    info "Passing Matomo installation wizard"
    # Step 0: Get cookies
    debug_execute "curl" "${curl_opts[@]}" "$wizard_url"
    # Step 1: System check
    curl_data_opts=(
        "--data-urlencode" "action=systemCheck"
    )
    debug_execute "curl" "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}"

    # Step 2: Database setup
    curl_data_opts=(
        "--data-urlencode" "action=databaseSetup"
        "--data-urlencode" "host=${MATOMO_DATABASE_HOST}:${MATOMO_DATABASE_PORT_NUMBER}"
        "--data-urlencode" "username=${MATOMO_DATABASE_USER}"
        "--data-urlencode" "password=${MATOMO_DATABASE_PASSWORD}"
        "--data-urlencode" "dbname=${MATOMO_DATABASE_NAME}"
        "--data-urlencode" "tables_prefix=${MATOMO_DATABASE_TABLE_PREFIX}"
        "--data-urlencode" "adapter=MYSQLI"
    )
    debug_execute "curl" "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}"

    # Step 3: Create tables
    curl_data_opts=(
        "--data-urlencode" "action=tablesCreation"
        "--data-urlencode" "module=Installation"
    )
    debug_execute "curl" "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}"

    # Step 4: Setup super-user
    curl_data_opts=(
        "--data-urlencode" "action=setupSuperUser"
        "--data-urlencode" "module=Installation"
        "--data-urlencode" "login=${MATOMO_USERNAME}"
        "--data-urlencode" "password=${MATOMO_PASSWORD}"
        "--data-urlencode" "password_bis=${MATOMO_PASSWORD}"
        "--data-urlencode" "email=${MATOMO_EMAIL}"
    )
    debug_execute "curl" "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}"

    # Step 5: Setup first tracking website
    curl_data_opts=(
        "--data-urlencode" "action=firstWebsiteSetup"
        "--data-urlencode" "module=Installation"
        "--data-urlencode" "siteName=${MATOMO_WEBSITE_NAME}"
        "--data-urlencode" "url=${MATOMO_WEBSITE_HOST}"
        "--data-urlencode" "timezone=UTC-8"
    )
    debug_execute "curl" "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}"

    # Step 6: Tracking code
    curl_data_opts=(
        "--data-urlencode" "action=trackingCode"
        "--data-urlencode" "module=Installation"
    )

    # Step 7: Finish installation
    curl_data_opts=(
        "--data-urlencode" "action=finished"
        "--data-urlencode" "module=Installation"
    )

    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}" 2>/dev/null)"

    if [[ "$curl_output" != *"Success"* ]]; then
        error "An error occurred while installing Matomo"
        debug "$curl_output"
        return 1
    else
        info "Matomo wizard finished successfully"
    fi
    # Stop the web server afterwards
    web_server_stop
}
