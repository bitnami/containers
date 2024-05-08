#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami OpenCart library

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
# Validate settings in OPENCART_* env vars
# Globals:
#   OPENCART_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
opencart_validate() {
    debug "Validating settings in OPENCART_* environment variables..."
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
        for empty_env_var in "OPENCART_DATABASE_PASSWORD" "OPENCART_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        done
    fi

    # Validate SMTP credentials
    if ! is_empty_value "$OPENCART_SMTP_HOST"; then
        for empty_env_var in "OPENCART_SMTP_USER" "OPENCART_SMTP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && warn "The ${empty_env_var} environment variable is empty or not set."
        done
        is_empty_value "$OPENCART_SMTP_PORT_NUMBER" && print_validation_error "The OPENCART_SMTP_PORT_NUMBER environment variable is empty or not set."
        ! is_empty_value "$OPENCART_SMTP_PORT_NUMBER" && check_valid_port "OPENCART_SMTP_PORT_NUMBER"
        ! is_empty_value "$OPENCART_SMTP_PROTOCOL" && check_multi_value "OPENCART_SMTP_PROTOCOL" "ssl tls"
    fi

    # Compatibility with older images where 'storage' was located inside the 'htdocs' directory
    if is_mounted_dir_empty "$OPENCART_STORAGE_DIR" && [[ -d "${OPENCART_VOLUME_DIR}/system/storage" ]]; then
        warn "Found 'storage' directory inside ${OPENCART_VOLUME_DIR}. Support for this configuration is deprecated and will be removed soon. Please create a new volume mountpoint at ${OPENCART_STORAGE_DIR}, and copy all its files there."
    fi

    # Check that the web server is properly set up
    web_server_validate || print_validation_error "Web server validation failed"

    return "$error_code"
}

########################
# Ensure OpenCart is initialized
# Globals:
#   OPENCART_*
# Arguments:
#   None
# Returns:
#   None
#########################
opencart_initialize() {
    # Check if OpenCart has already been initialized and persisted in a previous run
    local db_host db_port db_name db_user db_pass
    local -r app_name="opencart"
    if ! is_app_initialized "$app_name"; then
        # Ensure OpenCart persisted directories exist (i.e. when a volume has been mounted to /bitnami)
        info "Ensuring OpenCart directories exist"
        ensure_dir_exists "$OPENCART_VOLUME_DIR"
        # Use daemon:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$OPENCART_VOLUME_DIR" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
        info "Trying to connect to the database server"
        db_host="$OPENCART_DATABASE_HOST"
        db_port="$OPENCART_DATABASE_PORT_NUMBER"
        db_name="$OPENCART_DATABASE_NAME"
        db_user="$OPENCART_DATABASE_USER"
        db_pass="$OPENCART_DATABASE_PASSWORD"
        local -a mysql_execute_args=("$db_host" "$db_port" "$db_name" "$db_user" "$db_pass")
        opencart_wait_for_db_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
        local -a opencart_cli_args=(
                --db_hostname "$db_host" \
                --db_port "$db_port" \
                --db_username "$db_user" \
                --db_password "$db_pass" \
                --db_database "$db_name" \
                --db_driver "mysqli" \
                --username "$OPENCART_USERNAME" \
                --password "$OPENCART_PASSWORD" \
                --email "$OPENCART_EMAIL" \
                --http_server "http://${OPENCART_HOST}/"
        )
        if ! is_boolean_yes "$OPENCART_SKIP_BOOTSTRAP"; then
            info "Installing OpenCart"
            debug_execute php "${OPENCART_BASE_DIR}/install/cli_install.php" install "${opencart_cli_args[@]}"

            # Make admin panel available at a consistent /administration URL, to avoid initial warning and for documentation/metadata purposes
            mv "${OPENCART_BASE_DIR}/admin" "${OPENCART_BASE_DIR}/administration"
            replace_in_file "$OPENCART_ADMIN_CONF_FILE" "admin/" "administration/"

            # Restrict permissions of the configuration files to keep the site secure
            if am_i_root; then
                configure_permissions_ownership "$OPENCART_CONF_FILE" -u "root" -g "$WEB_SERVER_DAEMON_USER" -f "644"
                configure_permissions_ownership "$OPENCART_ADMIN_CONF_FILE" -u "root" -g "$WEB_SERVER_DAEMON_USER" -f "644"
            fi
            
            local -a settings_to_update=(
                # Enable friendly URLs by default
                "config_seo_url=1"
            )
            is_boolean_yes "$OPENCART_ENABLE_HTTPS" && settings_to_update+=("config_secure=1")
            if ! is_empty_value "$OPENCART_SMTP_HOST"; then
                info "Configuring SMTP"
                local smtp_host="$OPENCART_SMTP_HOST"
                ! is_empty_value "$OPENCART_SMTP_PROTOCOL" && smtp_host="${OPENCART_SMTP_PROTOCOL}://${smtp_host}"
                settings_to_update+=(
                    "config_mail_protocol=smtp"
                    "config_mail_parameter=-f${OPENCART_SMTP_USER}"
                    "config_mail_smtp_hostname=${smtp_host}"
                    "config_mail_smtp_username=${OPENCART_SMTP_USER}"
                    "config_mail_smtp_password=${OPENCART_SMTP_PASSWORD}"
                    "config_mail_smtp_port=${OPENCART_SMTP_PORT_NUMBER}"
                )
            fi
            if [[ "${#settings_to_update[@]}" -gt 0 ]]; then
                for setting in "${settings_to_update[@]}"; do
                    # We split the key and value with the '=' delimiter via native Bash functionality to simplify the logic
                    # We need to backtick 'key' because it is a reserved MySQL word, and escape it to avoid Bash parsing a command
                    mysql_remote_execute "${mysql_execute_args[@]}" <<< "UPDATE oc_setting SET value='${setting#*=}' WHERE \`key\`='${setting%=*}';"
                done
            fi
        else
            info "An already initialized OpenCart database was provided, configuration will be skipped"
            if [[ -d "${OPENCART_BASE_DIR}/admin" ]]; then
                mv "${OPENCART_BASE_DIR}/admin" "${OPENCART_BASE_DIR}/administration"
            fi
            info "Generating configuration files"
            opencart_create_config_files "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass" "mysqli"  "${OPENCART_HOST}"
            opencart_upgrade_wizard
        fi
        info "Updating OpenCart hostname"
        opencart_update_hostname "${OPENCART_HOST:-localhost}"

        info "Persisting OpenCart installation"
        persist_app "$app_name" "$OPENCART_DATA_TO_PERSIST"

        # This is executed after persisting the app directory to avoid a broken install in case of an error
        opencart_protect_storage_dir
    else
        info "Restoring persisted OpenCart installation"
        if [[ -d "${OPENCART_BASE_DIR}/admin" ]]; then
            mv "${OPENCART_BASE_DIR}/admin" "${OPENCART_BASE_DIR}/administration"
        fi
        restore_persisted_app "$app_name" "$OPENCART_DATA_TO_PERSIST"
        info "Trying to connect to the database server"
        db_host="$(opencart_conf_get "DB_HOSTNAME")"
        db_port="$(opencart_conf_get "DB_PORT")"
        db_name="$(opencart_conf_get "DB_DATABASE")"
        db_user="$(opencart_conf_get "DB_USERNAME")"
        db_pass="$(opencart_conf_get "DB_PASSWORD")"
        opencart_wait_for_db_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
        opencart_upgrade_wizard
    fi

    # Remove previous storage location to avoid confusion
    # Note that 'opencart_protect_storage_dir' is not executed for upgrades, so it exists even if removed in that function
    rm -rf "${OPENCART_BASE_DIR}/system/storage"

    # Remove the installation page for security purposes
    rm -rf "${OPENCART_BASE_DIR}/install"

    # Remove cache
    rm -rf "${OPENCART_STORAGE_DIR}/cache/"*
    
    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Add or modify an entry in the OpenCart configuration file (config.php)
# Globals:
#   OPENCART_*
# Arguments:
#   $1 - PHP constant name
#   $2 - Value to assign to the PHP variable
#   $3 - Configuration file to modify
# Returns:
#   None
#########################
opencart_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:?value missing}"
    local -r file="${3:-$OPENCART_CONF_FILE}"
    debug "Setting ${key} to '${value}' in OpenCart configuration file ${file}"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(//\s*)?define\s*\(['\"]$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")['\"]\s*,.*"
    local -r entry="define('${key}', '$value');"
    # Check if the configuration exists in the file
    if grep -q -E "$sanitized_pattern" "$file"; then
        # It exists, so replace the line
        replace_in_file "$file" "$sanitized_pattern" "$entry"
    else
        echo "define('${key}', '$value');" >> "$file"
    fi
}

########################
# Get an entry from the OpenCart configuration file (config.php)
# Globals:
#   OPENCART_*
# Arguments:
#   $1 - PHP constant name
#   $2 - Configuration file to read
# Returns:
#   None
#########################
opencart_conf_get() {
    local -r key="${1:?key missing}"
    local -r file="${2:-$OPENCART_CONF_FILE}"
    debug "Getting ${key} from OpenCart configuration"
    php -r "require ('${OPENCART_CONF_FILE}'); print ${key};"
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
opencart_wait_for_db_connection() {
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
# Protect storage directory so it is not directly accessible by users
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
opencart_protect_storage_dir() {
    # Place 'storage' directory outside of the web server root, to fix warning when accessing the admin panel:
    # "It is very important that you move the storage directory outside of the web directory (e.g. public_html, www or htdocs)"
    # Note that OpenCart requires slashes ("/") at the end of URLs and paths
    cp -rp "${OPENCART_BASE_DIR}/system/storage/"* "$OPENCART_STORAGE_DIR"
    opencart_conf_set DIR_STORAGE "${OPENCART_STORAGE_DIR}/"
    opencart_conf_set DIR_STORAGE "${OPENCART_STORAGE_DIR}/" "$OPENCART_ADMIN_CONF_FILE"
}

########################
# Update OpenCart hostname
# Globals:
#   OPENCART_*
# Arguments:
#   $1 - hostname in the form <host>[:<port>]
# Returns:
#   None
#########################
opencart_update_hostname() {
    local -r hostname="${1:?missing hostname}"
    local http_url="http://${hostname}"
    local https_url="https://${hostname}"
    [[ "$OPENCART_EXTERNAL_HTTP_PORT_NUMBER" != "80" ]] && http_url+=":$OPENCART_EXTERNAL_HTTP_PORT_NUMBER"
    [[ "$OPENCART_EXTERNAL_HTTPS_PORT_NUMBER" != "443" ]] && https_url+=":$OPENCART_EXTERNAL_HTTPS_PORT_NUMBER"

    if is_boolean_yes "$OPENCART_ENABLE_HTTPS"; then
        opencart_conf_set HTTP_SERVER "${https_url}/"
        opencart_conf_set HTTPS_SERVER "${https_url}/"

        opencart_conf_set HTTP_SERVER "${https_url}/administration/" "$OPENCART_ADMIN_CONF_FILE"
        opencart_conf_set HTTP_CATALOG "${https_url}/" "$OPENCART_ADMIN_CONF_FILE"
        opencart_conf_set HTTPS_SERVER "${https_url}/administration/" "$OPENCART_ADMIN_CONF_FILE"
        opencart_conf_set HTTPS_CATALOG "${https_url}/" "$OPENCART_ADMIN_CONF_FILE"
    else
        opencart_conf_set HTTP_SERVER "${http_url}/"
        opencart_conf_set HTTPS_SERVER "${http_url}/"

        opencart_conf_set HTTP_SERVER "${http_url}/administration/" "$OPENCART_ADMIN_CONF_FILE"
        opencart_conf_set HTTP_CATALOG "${http_url}/" "$OPENCART_ADMIN_CONF_FILE"
        opencart_conf_set HTTPS_SERVER "${http_url}/administration/" "$OPENCART_ADMIN_CONF_FILE"
        opencart_conf_set HTTPS_CATALOG "${http_url}/" "$OPENCART_ADMIN_CONF_FILE"
    fi
}

########################
# Create OpenCart configuration files without populating the database
# The installation wizard already performs this, so it is only executed in case of deploying a site with an existing DB
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   true if the wizard succeeded, false otherwise
#########################
opencart_create_config_files() {
    # We want to setup a site to work with an existing database, which requires not to make any changes to it
    # For that, we use OPENCART_SKIP_BOOTSTRAP, which determines whether to perform initial bootstrapping for the application or not
    # Unfortunately OpenCart does not offer an official way to do this
    # Despite being hacky, it allows to deploy a site with an existing database without needing to start from zero
    local -r db_host="${1:?missing database host}"
    local -r db_port="${2:?missing database port}"
    local -r db_name="${3:?missing database name}"
    local -r db_user="${4:?missing database user}"
    local -r db_pass="${5:-}"
    local -r db_driver="${6:?mysqli}"
    local -r hostname="${7:?localhost}"

    # Generate config file
    cat > "$OPENCART_CONF_FILE" <<EOF
<?php
// APPLICATION
define('APPLICATION', 'Catalog');

// HTTP
define('HTTP_SERVER', 'http://${hostname}/');
define('HTTPS_SERVER', 'http://${hostname}/');

// DIR
define('DIR_OPENCART', '/opt/bitnami/opencart/');
define('DIR_APPLICATION', DIR_OPENCART . 'catalog/');
define('DIR_SYSTEM', DIR_OPENCART . 'system/');
define('DIR_EXTENSION', DIR_OPENCART . 'extension/');
define('DIR_IMAGE', DIR_OPENCART . 'image/');
define('DIR_STORAGE', '/bitnami/opencart_storage/');
define('DIR_LANGUAGE', DIR_APPLICATION . 'language/');
define('DIR_TEMPLATE', DIR_APPLICATION . 'view/template/');
define('DIR_CONFIG', DIR_SYSTEM . 'config/');
define('DIR_CACHE', DIR_STORAGE . 'cache/');
define('DIR_DOWNLOAD', DIR_STORAGE . 'download/');
define('DIR_LOGS', DIR_STORAGE . 'logs/');
define('DIR_SESSION', DIR_STORAGE . 'session/');
define('DIR_UPLOAD', DIR_STORAGE . 'upload/');

// DB
define('DB_DRIVER', '${db_driver}');
define('DB_HOSTNAME', 'mariadb');
define('DB_USERNAME', '${db_user}');
define('DB_PASSWORD', '${db_pass}');
define('DB_DATABASE', '${db_name}');
define('DB_PREFIX', 'oc_');
define('DB_PORT', '${db_port}');
EOF

    # Generate admin config file
    cat > "$OPENCART_ADMIN_CONF_FILE" <<EOF
<?php
// APPLICATION
define('APPLICATION', 'Admin');

// HTTP
define('HTTP_SERVER', 'http://${hostname}/administration/');
define('HTTP_CATALOG', 'http://${hostname}/');
define('HTTPS_SERVER', 'http://${hostname}/administration/');
define('HTTPS_CATALOG', 'http://${hostname}/');

// DIR
define('DIR_OPENCART', '/opt/bitnami/opencart/');
define('DIR_APPLICATION', DIR_OPENCART . 'administration/');
define('DIR_SYSTEM', DIR_OPENCART . 'system/');
define('DIR_EXTENSION', DIR_OPENCART . 'extension/');
define('DIR_IMAGE', DIR_OPENCART . 'image/');
define('DIR_STORAGE', '/bitnami/opencart_storage/');
define('DIR_CATALOG', DIR_OPENCART . 'catalog/');
define('DIR_LANGUAGE', DIR_APPLICATION . 'language/');
define('DIR_TEMPLATE', DIR_APPLICATION . 'view/template/');
define('DIR_CONFIG', DIR_SYSTEM . 'config/');
define('DIR_CACHE', DIR_STORAGE . 'cache/');
define('DIR_DOWNLOAD', DIR_STORAGE . 'download/');
define('DIR_LOGS', DIR_STORAGE . 'logs/');
define('DIR_SESSION', DIR_STORAGE . 'session/');
define('DIR_UPLOAD', DIR_STORAGE . 'upload/');

// DB
define('DB_DRIVER', '${db_driver}');
define('DB_HOSTNAME', 'mariadb');
define('DB_USERNAME', '${db_user}');
define('DB_PASSWORD', '${db_pass}');
define('DB_DATABASE', '${db_name}');
define('DB_PREFIX', 'oc_');
define('DB_PORT', '${db_port}');

// OpenCart API
define('OPENCART_SERVER', 'https://www.opencart.com/');
EOF
}

########################
# Pass OpenCart upgrade wizard
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   true if the wizard succeeded, false otherwise
#########################
opencart_upgrade_wizard() {
    if [[ -d "${OPENCART_BASE_DIR}/install" ]]; then
        # Backup config files
        mv "$OPENCART_CONF_FILE" "${OPENCART_CONF_FILE}.bck"
        mv "$OPENCART_ADMIN_CONF_FILE" "${OPENCART_ADMIN_CONF_FILE}.bck"

        # Upgrade requires admin directory to exist
        # GH issue: https://github.com/opencart/opencart/issues/11641
        mv "${OPENCART_BASE_DIR}/administration" "${OPENCART_BASE_DIR}/admin"
        cp "${OPENCART_BASE_DIR}/admin/config.php.bck" "${OPENCART_BASE_DIR}/admin/config.php"
        cp "${OPENCART_CONF_FILE}.bck" "${OPENCART_CONF_FILE}"
        replace_in_file "${OPENCART_BASE_DIR}/admin/config.php" "administration/" "admin/"

        local -r port="${WEB_SERVER_HTTP_PORT_NUMBER:-"$WEB_SERVER_DEFAULT_HTTP_PORT_NUMBER"}"
        local wizard_url cookie_file curl_output
        local -a curl_opts curl_data_opts curl_output
        local -a migrations
        read -r -a migrations <<< "$(find /opt/bitnami/opencart/install/controller/upgrade/ -name 'upgrade_*.php' -printf '%f\0' | sort -z | xargs -0)"
        wizard_url="http://127.0.0.1:${port}/install/index.php?route=upgrade"
        cookie_file="/tmp/cookie$(generate_random_string -t alphanumeric -c 8)"
        curl_opts=("--location" "--silent" "--cookie" "$cookie_file" "--cookie-jar" "$cookie_file")
        # Ensure the web server is started
        web_server_start
        info "Passing OpenCart upgrade wizard"
        # Step 1: Get cookies
        debug_execute "curl" "${curl_opts[@]}" "${wizard_url}/upgrade"
        # Step 2: System check
        for migration in "${migrations[@]}"; do
            step="${migration%%.php}"
            curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}/${step}" 2>/dev/null)"
            if [[ "$curl_output" != *"has been applied"* ]] && [[ "$curl_output" != *"Congratulations"* ]]; then
                error "An error occurred while upgrading OpenCart: ${step}"
                debug "$curl_output"
                return 1
            fi
        done
        if [[ "$curl_output" != *"Congratulations"* ]]; then
            error "An error occurred while upgrading OpenCart"
            debug "$curl_output"
            return 1
        else
            info "OpenCart upgrade wizard finished successfully"
        fi
        # Stop the web server afterwards
        web_server_stop

        # Restore administration
        mv "${OPENCART_BASE_DIR}/admin" "${OPENCART_BASE_DIR}/administration"

        # Restore configuration files
        mv "${OPENCART_CONF_FILE}.bck" "$OPENCART_CONF_FILE"
        mv "${OPENCART_ADMIN_CONF_FILE}.bck" "$OPENCART_ADMIN_CONF_FILE"
    else
        info "Path ${OPENCART_BASE_DIR}/install does not exist, upgrade will be skipped"
    fi
}
