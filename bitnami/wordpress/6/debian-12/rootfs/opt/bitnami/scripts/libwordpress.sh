#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami WordPress library

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
# Validate settings in WORDPRESS_* env vars
# Globals:
#   WORDPRESS_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
wordpress_validate() {
    debug "Validating settings in WORDPRESS_* environment variables..."
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
    check_int_value() {
        if ! is_int "${!1}"; then
            print_validation_error "The value for $1 should be an integer"
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
            print_validation_error "The variable ${1} is defined but the file ${!1} is not accessible or does not exist"
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
    is_file_writable "$WORDPRESS_CONF_FILE" || warn "The WordPress configuration file '${WORDPRESS_CONF_FILE}' is not writable. Configurations based on environment variables will not be applied for this file."

    # Validate user inputs
    check_yes_no_value "WORDPRESS_ENABLE_HTTPS"
    check_yes_no_value "WORDPRESS_HTACCESS_OVERRIDE_NONE"
    check_yes_no_value "WORDPRESS_ENABLE_HTACCESS_PERSISTENCE"
    check_yes_no_value "WORDPRESS_RESET_DATA_PERMISSIONS"
    check_yes_no_value "WORDPRESS_SKIP_BOOTSTRAP"
    check_multi_value "WORDPRESS_AUTO_UPDATE_LEVEL" "major minor none"
    check_yes_no_value "WORDPRESS_ENABLE_REVERSE_PROXY"
    check_yes_no_value "WORDPRESS_ENABLE_XML_RPC"

    # Multisite validations
    check_yes_no_value "WORDPRESS_ENABLE_MULTISITE"
    if is_boolean_yes "$WORDPRESS_ENABLE_MULTISITE"; then
        # subdirectory is an alias for subfolder
        check_multi_value "WORDPRESS_MULTISITE_NETWORK_TYPE" "subfolder subdirectory subdomain"
        check_yes_no_value "WORDPRESS_MULTISITE_ENABLE_NIP_IO_REDIRECTION"
        check_int_value "WORDPRESS_MULTISITE_FILEUPLOAD_MAXK"
        if ! is_empty_value "$WORDPRESS_MULTISITE_HOST"; then
            check_resolved_hostname "$WORDPRESS_MULTISITE_HOST"
            [[ "$WORDPRESS_MULTISITE_HOST" =~ localhost ]] && print_validation_error "WORDPRESS_MULTISITE_HOST must be set to an actual hostname, localhost values are not allowed."
            validate_ipv4 "$WORDPRESS_MULTISITE_HOST" && print_validation_error "WORDPRESS_MULTISITE_HOST must be set to an actual hostname, IP addresses are not allowed."
            check_valid_port "WORDPRESS_MULTISITE_EXTERNAL_HTTP_PORT_NUMBER"
            check_valid_port "WORDPRESS_MULTISITE_EXTERNAL_HTTPS_PORT_NUMBER"
        else
            print_validation_error "WORDPRESS_MULTISITE_HOST must be set when enabling WordPress Multisite mode."
        fi
    elif ! is_empty_value "$WORDPRESS_MULTISITE_HOST"; then
        warn "Multisite mode is not enabled, and WORDPRESS_MULTISITE_HOST is only used for Multisite installations. Its value will be ignored."
    fi

    # Database configuration validations
    check_resolved_hostname "$WORDPRESS_DATABASE_HOST"
    check_valid_port "WORDPRESS_DATABASE_PORT_NUMBER"
    check_yes_no_value "WORDPRESS_ENABLE_DATABASE_SSL"
    if is_boolean_yes "$WORDPRESS_ENABLE_DATABASE_SSL"; then
        check_yes_no_value "WORDPRESS_VERIFY_DATABASE_SSL"
        check_mounted_file "WORDPRESS_DATABASE_SSL_CERT_FILE"
        check_mounted_file "WORDPRESS_DATABASE_SSL_KEY_FILE"
        check_mounted_file "WORDPRESS_DATABASE_SSL_CA_FILE"
    fi

    # Validate credentials
    if is_boolean_yes "${ALLOW_EMPTY_PASSWORD:-}"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD:-}. For safety reasons, do not use this flag in a production environment."
    else
        for empty_env_var in "WORDPRESS_DATABASE_PASSWORD" "WORDPRESS_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        done
    fi

    # Validate SMTP credentials
    if ! is_empty_value "$WORDPRESS_SMTP_HOST"; then
        check_resolved_hostname "$WORDPRESS_SMTP_HOST"
        for empty_env_var in "WORDPRESS_SMTP_USER" "WORDPRESS_SMTP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && warn "The ${empty_env_var} environment variable is empty or not set."
        done
        is_empty_value "$WORDPRESS_SMTP_PORT_NUMBER" && print_validation_error "The WORDPRESS_SMTP_PORT_NUMBER environment variable is empty or not set."
        ! is_empty_value "$WORDPRESS_SMTP_PORT_NUMBER" && check_valid_port "WORDPRESS_SMTP_PORT_NUMBER"
        ! is_empty_value "$WORDPRESS_SMTP_PROTOCOL" && check_multi_value "WORDPRESS_SMTP_PROTOCOL" "ssl tls"
    fi

    # Validate htaccess persistence
    if is_boolean_yes "$WORDPRESS_ENABLE_HTACCESS_PERSISTENCE" && [[ "$(web_server_type)" = "apache" ]]; then
        if is_boolean_yes "$WORDPRESS_HTACCESS_OVERRIDE_NONE"; then
            local htaccess_file="${WORDPRESS_BASE_DIR}/wordpress-htaccess.conf"
            local htaccess_dest="${APACHE_HTACCESS_DIR}/wordpress-htaccess.conf"
            if is_file_writable "$htaccess_dest"; then
                ! is_file_writable "$htaccess_file" && print_validation_error "The WORDPRESS_ENABLE_HTACCESS_PERSISTENCE configuration is enabled, but the htaccess file to persist ${htaccess_file} is not writable."
            else
                warn "The WORDPRESS_ENABLE_HTACCESS_PERSISTENCE configuration is enabled but the ${htaccess_dest} file is not writable. The file will not be persisted."
            fi
        else
            local htaccess_file="${WORDPRESS_BASE_DIR}/.htaccess"
            ! is_file_writable "$htaccess_file" && print_validation_error "The WORDPRESS_ENABLE_HTACCESS_PERSISTENCE configuration is enabled but the htaccess file to persist ${htaccess_file} is not writable."
        fi
    fi

    # Check that the web server is properly set up
    web_server_validate || print_validation_error "Web server validation failed"

    return "$error_code"
}

########################
# Configure database settings in wp-config.php
# Globals:
#   WORDPRESS_*
# Arguments:
#   None
# Returns:
#   None
#########################
wordpress_set_db_settings() {
    # Configure database credentials
    wordpress_conf_set "DB_NAME" "$WORDPRESS_DATABASE_NAME"
    wordpress_conf_set "DB_USER" "$WORDPRESS_DATABASE_USER"
    wordpress_conf_set "DB_PASSWORD" "$WORDPRESS_DATABASE_PASSWORD"
    wordpress_conf_set "DB_HOST" "${WORDPRESS_DATABASE_HOST}:${WORDPRESS_DATABASE_PORT_NUMBER}"
    # Configure database SSL/TLS connections
    if is_boolean_yes "$WORDPRESS_ENABLE_DATABASE_SSL"; then
        ! is_empty_value "$WORDPRESS_DATABASE_SSL_KEY_FILE" && wordpress_conf_set "MYSQL_SSL_KEY" "$WORDPRESS_DATABASE_SSL_KEY_FILE"
        ! is_empty_value "$WORDPRESS_DATABASE_SSL_CERT_FILE" && wordpress_conf_set "MYSQL_SSL_CERT" "$WORDPRESS_DATABASE_SSL_CERT_FILE"
        ! is_empty_value "$WORDPRESS_DATABASE_SSL_CA_FILE" && wordpress_conf_set "MYSQL_SSL_CA" "$WORDPRESS_DATABASE_SSL_CA_FILE"
        local wp_mysqli_client_flags="MYSQLI_CLIENT_SSL"
        if ! is_boolean_yes "$WORDPRESS_VERIFY_DATABASE_SSL"; then
            wp_mysqli_client_flags+=" | MYSQLI_CLIENT_SSL_DONT_VERIFY_SERVER_CERT"
        fi
        wordpress_conf_set "MYSQL_CLIENT_FLAGS" "$wp_mysqli_client_flags" yes
    fi
}

########################
# Ensure WordPress is initialized
# Globals:
#   WORDPRESS_*
# Arguments:
#   None
# Returns:
#   None
#########################
wordpress_initialize() {
    # For backwards compatibility, check if the .htaccess file should be persisted
    # Now it is possible specify the list of files by overriding WORDPRESS_DATA_TO_PERSIST
    if is_boolean_yes "$WORDPRESS_ENABLE_HTACCESS_PERSISTENCE" && [[ "$(web_server_type)" = "apache" ]]; then
        if is_boolean_yes "$WORDPRESS_HTACCESS_OVERRIDE_NONE"; then
            local htaccess_file="${WORDPRESS_BASE_DIR}/wordpress-htaccess.conf"
            local htaccess_dest="${APACHE_HTACCESS_DIR}/wordpress-htaccess.conf"
            if is_file_writable "$htaccess_dest" && is_file_writable "$htaccess_file"; then
                # If the file was not created at build time, copy the default configuration
                [[ ! -f "$htaccess_file" ]] && cp "$htaccess_dest" "$htaccess_file"
                # With the use of symlinks, we can configure Apache to use it before the persisted file is even created
                rm "$htaccess_dest"
                ln -s "$htaccess_file" "$htaccess_dest"
                WORDPRESS_DATA_TO_PERSIST+=" ${htaccess_file}"
            fi
        else
            local htaccess_file="${WORDPRESS_BASE_DIR}/.htaccess"
            if is_file_writable "$htaccess_file"; then
                # If the file was not mounted, use default configuration (currently empty htaccess for app root)
                [[ ! -f "$htaccess_file" ]] && touch "$htaccess_file"
                WORDPRESS_DATA_TO_PERSIST+=" ${htaccess_file}"
            fi
        fi
    fi

    # Check if WordPress has already been initialized and persisted in a previous run
    local -r app_name="wordpress"
    if ! is_app_initialized "$app_name" || [[ ! -f "$WORDPRESS_CONF_FILE" ]]; then
        # Ensure WordPress persisted directories exist (i.e. when a volume has been mounted to /bitnami)
        info "Ensuring WordPress directories exist"
        ensure_dir_exists "$WORDPRESS_VOLUME_DIR"
        # Use daemon:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$WORDPRESS_VOLUME_DIR" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
        info "Trying to connect to the database server"
        wordpress_wait_for_mysql_connection "$WORDPRESS_DATABASE_HOST" "$WORDPRESS_DATABASE_PORT_NUMBER" "$WORDPRESS_DATABASE_NAME" "$WORDPRESS_DATABASE_USER" "$WORDPRESS_DATABASE_PASSWORD"

        # Apply changes to WordPress configuration file based on user inputs
        # See: https://wordpress.org/support/article/editing-wp-config-php/
        # Note that wp-config.php is officially indented via tabs, not spaces
        info "Configuring WordPress with settings provided via environment variables"
        if is_file_writable "$WORDPRESS_CONF_FILE"; then
            # Set miscellaneous configurations
            wordpress_conf_set "FS_METHOD" "direct"
            is_boolean_yes "$WORDPRESS_ENABLE_REVERSE_PROXY" && wordpress_configure_reverse_proxy
            ! is_boolean_yes "$WORDPRESS_ENABLE_MULTISITE" && wordpress_configure_urls
            # The only variable/non-constant in the entire configuration file is '$table_prefix'
            replace_in_file "$WORDPRESS_CONF_FILE" "^(\s*\\\$table_prefix\s*=\s*).*" "\1'$WORDPRESS_TABLE_PREFIX';"
            wordpress_set_db_settings
            # Configure random keys and salt values
            wp_execute config shuffle-salts

            # Configure keys and salt values
            ! is_empty_value "$WORDPRESS_AUTH_KEY" && wordpress_conf_set "AUTH_KEY" "$WORDPRESS_AUTH_KEY"
            ! is_empty_value "$WORDPRESS_SECURE_AUTH_KEY" && wordpress_conf_set "SECURE_AUTH_KEY" "$WORDPRESS_SECURE_AUTH_KEY"
            ! is_empty_value "$WORDPRESS_LOGGED_IN_KEY" && wordpress_conf_set "LOGGED_IN_KEY" "$WORDPRESS_LOGGED_IN_KEY"
            ! is_empty_value "$WORDPRESS_NONCE_KEY" && wordpress_conf_set "NONCE_KEY" "$WORDPRESS_NONCE_KEY"
            ! is_empty_value "$WORDPRESS_AUTH_SALT" && wordpress_conf_set "AUTH_SALT" "$WORDPRESS_AUTH_SALT"
            ! is_empty_value "$WORDPRESS_SECURE_AUTH_SALT" && wordpress_conf_set "SECURE_AUTH_SALT" "$WORDPRESS_SECURE_AUTH_SALT"
            ! is_empty_value "$WORDPRESS_LOGGED_IN_SALT" && wordpress_conf_set "LOGGED_IN_SALT" "$WORDPRESS_LOGGED_IN_SALT"
            ! is_empty_value "$WORDPRESS_NONCE_SALT" && wordpress_conf_set "NONCE_SALT" "$WORDPRESS_NONCE_SALT"

            # Enable or disable auto-updates
            # https://wordpress.org/support/article/configuring-automatic-background-updates/#constant-to-configure-core-updates
            if [[ "$WORDPRESS_AUTO_UPDATE_LEVEL" = "minor" ]]; then
                wordpress_conf_set "WP_AUTO_UPDATE_CORE" "minor"
            else
                wordpress_conf_set "WP_AUTO_UPDATE_CORE" "$([[ "$WORDPRESS_AUTO_UPDATE_LEVEL" = "major" ]] && echo "true" || echo "false")" yes
            fi
            # Disable pingback to prevent WordPress from participating in DDoS attacks
            wordpress_disable_pingback
            # Lastly, allow to append any custom configuration to the wp-config.php file via an environment variable
            ! is_empty_value "$WORDPRESS_EXTRA_WP_CONFIG_CONTENT" && wordpress_conf_append "$WORDPRESS_EXTRA_WP_CONFIG_CONTENT"
        else
            warn "Skipping modifications to ${WORDPRESS_CONF_FILE} because it is not writable"
        fi

        # Initialize the WordPress application
        if ! is_boolean_yes "$WORDPRESS_SKIP_BOOTSTRAP"; then
            # Build install arguments and run installation command
            local wp_install_flags=(
                "--title=${WORDPRESS_BLOG_NAME}"
                "--admin_user=${WORDPRESS_USERNAME}"
                "--admin_password=${WORDPRESS_PASSWORD}"
                "--admin_email=${WORDPRESS_EMAIL}"
                "--skip-email"
            )
            # The --url argument is required in all cases
            # However, in Multisite it is used to set the domains, meaning the value having a direct impact
            # In non-Multisite installations, however, it will only set install metadata and not have any usage impact
            if is_boolean_yes "$WORDPRESS_ENABLE_MULTISITE"; then
                local wordpress_url="$WORDPRESS_MULTISITE_HOST"
                if is_boolean_yes "$WORDPRESS_ENABLE_HTTPS" || [[ "$WORDPRESS_SCHEME" = "https" ]]; then
                    wordpress_url="https://${wordpress_url}"
                    [[ "$WORDPRESS_MULTISITE_EXTERNAL_HTTPS_PORT_NUMBER" != "443" ]] && wordpress_url+=":${WORDPRESS_MULTISITE_EXTERNAL_HTTPS_PORT_NUMBER}"
                else
                    wordpress_url="http://${wordpress_url}"
                    [[ "$WORDPRESS_MULTISITE_EXTERNAL_HTTP_PORT_NUMBER" != "80" ]] && wordpress_url+=":${WORDPRESS_MULTISITE_EXTERNAL_HTTP_PORT_NUMBER}"
                fi
                wp_install_flags+=("--url=${wordpress_url}")
            else
                wp_install_flags+=("--url=localhost")
            fi
            # Allow to specify extra CLI flags, but ensure they are added last
            local -a wp_extra_install_flags
            read -r -a wp_extra_install_flags <<<"$WORDPRESS_EXTRA_INSTALL_ARGS"
            [[ "${#wp_extra_install_flags[@]}" -gt 0 ]] && wp_install_flags+=("${wp_extra_install_flags[@]}")
            # Run installation command, which differs between normal and Multisite installations
            if is_boolean_yes "$WORDPRESS_ENABLE_MULTISITE"; then
                info "Installing WordPress Multisite"
                [[ "$WORDPRESS_MULTISITE_NETWORK_TYPE" = "subdomain" ]] && wp_install_flags=("--subdomains" "${wp_install_flags[@]}")
                wp_execute core multisite-install "${wp_install_flags[@]}"
            else
                info "Installing WordPress"
                wp_execute core install "${wp_install_flags[@]}"
            fi
            # Install plugins defined via environment variables
            local -a install_plugins_args=()
            if [[ "$WORDPRESS_PLUGINS" = "all" ]]; then
                info "Activating all installed plugins"
                install_plugins_args+=("--all")
                if is_boolean_yes "$WORDPRESS_ENABLE_MULTISITE"; then
                    install_plugins_args+=("--network")
                fi
                wp_execute plugin activate "${install_plugins_args[@]}"
            elif [[ "$WORDPRESS_PLUGINS" != "none" ]]; then
                local -a plugins_to_install
                read -r -a plugins_to_install <<<"$(echo "$WORDPRESS_PLUGINS" | tr ',;' ' ')"
                if [[ "${#plugins_to_install[@]}" -gt 0 ]]; then
                    info "Installing and activating plugins: ${plugins_to_install[*]}"
                    install_plugins_args+=("${plugins_to_install[@]}")
                    if is_boolean_yes "$WORDPRESS_ENABLE_MULTISITE"; then
                        install_plugins_args+=("--activate-network")
                    else
                        install_plugins_args+=("--activate")
                    fi
                    wp_execute plugin install "${install_plugins_args[@]}"
                fi
            fi
            # Post installation steps
            local -r default_user_id="1"
            wp_execute user meta set "$default_user_id" first_name "$WORDPRESS_FIRST_NAME"
            wp_execute user meta set "$default_user_id" last_name "$WORDPRESS_LAST_NAME"
            # Increase upload limit for multisite installations (default is 1MB)
            local -r default_site_id="1"
            is_boolean_yes "$WORDPRESS_ENABLE_MULTISITE" && wp_execute site meta update "$default_site_id" fileupload_maxk "$WORDPRESS_MULTISITE_FILEUPLOAD_MAXK"
            # Enable friendly URLs / permalinks (using historic Bitnami defaults)
            wp_execute rewrite structure '/%year%/%monthnum%/%day%/%postname%/'
            ! is_empty_value "$WORDPRESS_SMTP_HOST" && wordpress_configure_smtp
        else
            info "An already initialized WordPress database was provided, configuration will be skipped"
            wp_execute core update-db
        fi

        info "Persisting WordPress installation"
        persist_app "$app_name" "$WORDPRESS_DATA_TO_PERSIST"

        # Secure wp-config.php file after persisting data because then we can ensure the commands to work
        # when running the scripts as non-root users
        local wp_config_path
        wp_config_path="$(readlink -f "$WORDPRESS_CONF_FILE")"
        if am_i_root; then
            is_file_writable "$wp_config_path" && configure_permissions_ownership "$wp_config_path" -f "440" -u "$WEB_SERVER_DAEMON_USER" -g "root"
        else
            is_file_writable "$wp_config_path" && configure_permissions_ownership "$wp_config_path" -f "440"
        fi
    else
        info "Restoring persisted WordPress installation"
        restore_persisted_app "$app_name" "$WORDPRESS_DATA_TO_PERSIST"
        info "Trying to connect to the database server"
        local db_name db_user db_pass db_host db_port
        if is_boolean_yes "$WORDPRESS_OVERRIDE_DATABASE_SETTINGS"; then
            info "Overriding the database configuration in wp-config.php with the provided environment variables"
            # Make the wp-config.php file writable to change the db settings
            local wp_config_path wp_config_perms
            wp_config_path="$(readlink -f "$WORDPRESS_CONF_FILE")"
            wp_config_perms="$(stat -c "%a" "$WORDPRESS_CONF_FILE")"
            if am_i_root; then
                ! is_file_writable "$wp_config_path" && configure_permissions_ownership "$wp_config_path" -f "775" -u "$WEB_SERVER_DAEMON_USER" -g "root"
            else
                ! is_file_writable "$wp_config_path" && configure_permissions_ownership "$wp_config_path" -f "775"
            fi
            wordpress_set_db_settings
            # Make it non-writable again
            if am_i_root; then
                is_file_writable "$wp_config_path" && configure_permissions_ownership "$wp_config_path" -f "$wp_config_perms" -u "$WEB_SERVER_DAEMON_USER" -g "root"
            else
                is_file_writable "$wp_config_path" && configure_permissions_ownership "$wp_config_path" -f "$wp_config_perms"
            fi
        fi
        db_name="$(wordpress_conf_get "DB_NAME")"
        db_user="$(wordpress_conf_get "DB_USER")"
        db_pass="$(wordpress_conf_get "DB_PASSWORD")"
        db_host_port="$(wordpress_conf_get "DB_HOST")"
        db_host="${db_host_port%:*}"
        if [[ "$db_host_port" =~ :[0-9]+$ ]]; then
            # Use '##' to extract only the part after the last colon, to avoid any possible issues with IPv6 addresses
            db_port="${db_host_port##*:}"
        else
            db_port="$WORDPRESS_DATABASE_PORT_NUMBER"
        fi
        wordpress_wait_for_mysql_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
        wp_execute core update-db

        if is_boolean_yes "$WORDPRESS_RESET_DATA_PERMISSIONS"; then
            warn "Resetting file permissions in persisted volume"
            local wp_config_path
            wp_config_path="$(readlink -f "$WORDPRESS_CONF_FILE")"
            if am_i_root; then
                is_file_writable "$wp_config_path" && configure_permissions_ownership "$wp_config_path" -f "440" -u "$WEB_SERVER_DAEMON_USER" -g "root"
                configure_permissions_ownership "${WORDPRESS_VOLUME_DIR}/wp-content" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
            else
                is_file_writable "$wp_config_path" && configure_permissions_ownership "$wp_config_path" -f "440"
                configure_permissions_ownership "${WORDPRESS_VOLUME_DIR}/wp-content" -d "775" -f "664"
            fi
        else
            debug "Not resetting file permissions in persisted volume"
        fi
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Executes the 'wp' CLI with the specified arguments and print result to stdout/stderr
# Globals:
#   WORDPRESS_*
# Arguments:
#   $1..$n - Arguments to pass to the CLI call
# Returns:
#   None
#########################
wp_execute_print_output() {
    # Avoid creating unnecessary cache files at initialization time
    local -a env=("env" "WP_CLI_CONFIG_PATH=${WP_CLI_CONF_FILE}" "WP_CLI_CACHE_DIR=/dev/null")
    local -a cmd=("${PHP_BIN_DIR}/php" "${WP_CLI_BIN_DIR}/wp-cli.phar" "$@")
    # Allow to specify extra CLI flags, but ensure they are added last
    local -a wp_extra_cli_flags
    read -r -a wp_extra_cli_flags <<<"$WORDPRESS_EXTRA_CLI_ARGS"
    [[ "${#wp_extra_cli_flags[@]}" -gt 0 ]] && cmd+=("${wp_extra_cli_flags[@]}")
    # Run as web server user to avoid having to change permissions/ownership afterwards
    if am_i_root; then
        run_as_user "$WEB_SERVER_DAEMON_USER" "${env[@]}" "${cmd[@]}"
    else
        "${env[@]}" "${cmd[@]}"
    fi
}

########################
# Executes the 'wp' CLI with the specified arguments
# Globals:
#   WORDPRESS_*
# Arguments:
#   $1..$n - Arguments to pass to the CLI call
# Returns:
#   None
#########################
wp_execute() {
    debug_execute wp_execute_print_output "$@"
}

########################
# Append configuration to the WordPress configuration file
# Globals:
#   WORDPRESS_*
# Arguments:
#   $1 - Configuration to append
# Returns:
#   None
#########################
wordpress_conf_append() {
    local -r conf="${1:?conf missing}"
    # This is basically escaping the newline character, for sed
    local conf_without_newlines
    conf_without_newlines="$(awk '{ printf "%s\\n", $0 }' <<<"$conf")"
    replace_in_file "$WORDPRESS_CONF_FILE" "(/\* That's all, stop editing\! .*)" "${conf_without_newlines}\n\1"
}

########################
# Add or modify an entry in the WordPress configuration file
# Globals:
#   WORDPRESS_*
# Arguments:
#   $1 - Variable name
#   $2 - Value to assign to the variable
#   $3 - Whether the value is a literal, or if instead it should be quoted (default: no)
# Returns:
#   None
#########################
wordpress_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:-}"
    local -r is_literal="${3:-no}"
    debug "Setting ${key} to '${value}' in WordPress configuration (literal: ${is_literal})"
    # Note: Using an empty --url to avoid any failure if the current URL is not properly configured
    local -a cmd=("wp_execute" "--url=http:" "config" "set" "$key" "$value")
    if is_boolean_yes "$is_literal"; then
        cmd+=("--raw")
    fi
    "${cmd[@]}"
}

########################
# Get an entry from the WordPress configuration file
# Globals:
#   WORDPRESS_*
# Arguments:
#   $1 - Variable name
# Returns:
#   None
#########################
wordpress_conf_get() {
    local -r key="${1:?key missing}"
    debug "Getting ${key} from WordPress configuration"
    # Use an empty URL to avoid any failure if the URL is not properly set
    wp_execute_print_output --url=http: config get "$key"
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
wordpress_wait_for_mysql_connection() {
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
# Disable the pingback functionality for WordPress
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
wordpress_disable_pingback() {
    # Append logic to disable pingbacks at the end of the file
    # Must be added after wp-settings.php is require'd since it defines them
    # Also note that wp-config.php is officially indented via tabs, not spaces
    cat >>"$WORDPRESS_CONF_FILE" <<"EOF"

/**
 * Disable pingback.ping xmlrpc method to prevent WordPress from participating in DDoS attacks
 * More info at: https://docs.bitnami.com/general/apps/wordpress/troubleshooting/xmlrpc-and-pingback/
 */
if ( !defined( 'WP_CLI' ) ) {
	// remove x-pingback HTTP header
	add_filter("wp_headers", function($headers) {
		unset($headers["X-Pingback"]);
		return $headers;
	});
	// disable pingbacks
	add_filter( "xmlrpc_methods", function( $methods ) {
		unset( $methods["pingback.ping"] );
		return $methods;
	});
}
EOF
}

########################
# Configure reverse proxy headers
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
wordpress_configure_reverse_proxy() {
    wordpress_conf_append "$(
        cat <<"EOF"
/**
 * Handle potential reverse proxy headers. Ref:
 *  - https://wordpress.org/support/article/faq-installation/#how-can-i-get-wordpress-working-when-im-behind-a-reverse-proxy
 *  - https://wordpress.org/support/article/administration-over-ssl/#using-a-reverse-proxy
 */
if ( ! empty( $_SERVER['HTTP_X_FORWARDED_HOST'] ) ) {
	$_SERVER['HTTP_HOST'] = $_SERVER['HTTP_X_FORWARDED_HOST'];
}
if ( ! empty( $_SERVER['HTTP_X_FORWARDED_PROTO'] ) \&\& 'https' === $_SERVER['HTTP_X_FORWARDED_PROTO'] ) {
	$_SERVER['HTTPS'] = 'on';
}
EOF
    )"
}

########################
# Configure application URLs for WordPress (non-Multisite)
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
wordpress_configure_urls() {
    # Set URL to dynamic value, depending on which host WordPress is accessed from (to be overridden later)
    # Note that wp-config.php is officially indented via tabs, not spaces
    wordpress_conf_append "$(
        cat <<"EOF"
/**
 * The WP_SITEURL and WP_HOME options are configured to access from any hostname or IP address.
 * If you want to access only from an specific domain, you can modify them. For example:
 *  define('WP_HOME','http://example.com');
 *  define('WP_SITEURL','http://example.com');
 *
 */
if ( defined( 'WP_CLI' ) ) {
	$_SERVER['HTTP_HOST'] = '127.0.0.1';
}
EOF
    )"
    local wp_url_protocol="http"
    (is_boolean_yes "$WORDPRESS_ENABLE_HTTPS" || [[ "$WORDPRESS_SCHEME" = "https" ]]) && wp_url_protocol="https"
    local wp_url_string="'${wp_url_protocol}://' . \$_SERVER['HTTP_HOST'] . '/'"
    wordpress_conf_set "WP_HOME" "$wp_url_string" yes
    wordpress_conf_set "WP_SITEURL" "$wp_url_string" yes
}

########################
# Configure SMTP
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
wordpress_configure_smtp() {
    info "Enabling wp-mail-smtp plugin"
    local -a install_smtp_plugin_args
    if is_boolean_yes "$WORDPRESS_ENABLE_MULTISITE"; then
        install_smtp_plugin_args=("--activate-network")
    else
        install_smtp_plugin_args=("--activate")
    fi
    wp_execute plugin install wp-mail-smtp "${install_smtp_plugin_args[@]}"
    info "Configuring SMTP settings"
    wp_execute option patch update wp_mail_smtp mail from_email "$WORDPRESS_SMTP_FROM_EMAIL"
    wp_execute option patch update wp_mail_smtp mail from_name "$WORDPRESS_SMTP_FROM_NAME"
    wp_execute option patch update wp_mail_smtp mail mailer "smtp"
    wp_execute option patch insert wp_mail_smtp smtp host "$WORDPRESS_SMTP_HOST"
    wp_execute option patch insert wp_mail_smtp smtp port "$WORDPRESS_SMTP_PORT_NUMBER"
    wp_execute option patch insert wp_mail_smtp smtp encryption "$WORDPRESS_SMTP_PROTOCOL"
    wp_execute option patch insert wp_mail_smtp smtp user "$WORDPRESS_SMTP_USER"
    wp_execute option patch insert wp_mail_smtp smtp pass "$WORDPRESS_SMTP_PASSWORD"
    # Prevent WP Mail SMTP wizard to be launched after logging in the admin panel
    wp_execute option set wp_mail_smtp_activation_prevent_redirect 1
}

########################
# Apply web server configuration to host WordPress
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
wordpress_generate_web_server_configuration() {
    # Web server config files will be generated twice, in order to properly support WORDPRESS_HTACCESS_OVERRIDE_NONE
    # At build time, htaccess files will not be moved - This will happen at runtime only if WORDPRESS_HTACCESS_OVERRIDE_NONE is enabled
    local -a web_server_config_create_flags
    if ! is_boolean_yes "$WORDPRESS_HTACCESS_OVERRIDE_NONE"; then
        # Enable .htaccess files
        web_server_config_create_flags+=("--apache-move-htaccess" "no" "--apache-allow-override" "All")
    else
        # Use htaccess.conf file loaded at web server startup
        web_server_config_create_flags+=("--apache-move-htaccess" "yes" "--apache-allow-override" "None")
    fi
    local apache_config nginx_config
    local template_dir="${BITNAMI_ROOT_DIR}/scripts/wordpress/bitnami-templates"
    # Fix themes/plugins usage
    apache_config="$(render-template "${template_dir}/apache-wordpress-volume-rewrite.conf.tpl")"
    nginx_config="$(render-template "${template_dir}/nginx-wordpress-volume-rewrite.conf.tpl")"
    nginx_external_config=""
    # Enable friendly URLs
    if ! is_boolean_yes "$WORDPRESS_ENABLE_MULTISITE"; then
        # Basic configuration (non-Multisite)
        apache_config+=$'\n'"$(render-template "${template_dir}/apache-wordpress-basic.conf.tpl")"
        nginx_config+=$'\n'"$(render-template "${template_dir}/nginx-wordpress-basic.conf.tpl")"
    elif [[ "$WORDPRESS_MULTISITE_NETWORK_TYPE" = "subfolder" || "$WORDPRESS_MULTISITE_NETWORK_TYPE" = "subdirectory" ]]; then
        # Multisite configuration for subfolder/subdirectory network type
        apache_config+=$'\n'"$(render-template "${template_dir}/apache-wordpress-multisite-subfolder.conf.tpl")"
        nginx_config+=$'\n'"$(render-template "${template_dir}/nginx-wordpress-multisite-subfolder.conf.tpl")"
        nginx_external_config+=$'\n'"$(render-template "${template_dir}/nginx-wordpress-multisite-subfolder-external.conf.tpl")"
    elif [[ "$WORDPRESS_MULTISITE_NETWORK_TYPE" = "subdomain" ]]; then
        # nip.io allows to create subdomains when WordPress Multisite is configured with an IP address
        # It only makes sense for WordPress Multisite when using subdomain network type
        # The redirection simply improves user experience so the site can be accessed via IP addresses without getting errors
        if is_boolean_yes "$WORDPRESS_MULTISITE_ENABLE_NIP_IO_REDIRECTION"; then
            apache_config+=$'\n'"$(render-template "${template_dir}/apache-nip-io-redirect.conf.tpl")"
            nginx_config+=$'\n'"$(render-template "${template_dir}/nginx-nip-io-redirect.conf.tpl")"
        fi
        # Multisite configuration for subdomain network type
        apache_config+=$'\n'"$(render-template "${template_dir}/apache-wordpress-multisite-subdomain.conf.tpl")"
        nginx_config+=$'\n'"$(render-template "${template_dir}/nginx-wordpress-multisite-subdomain.conf.tpl")"
        nginx_external_config+=$'\n'"$(render-template "${template_dir}/nginx-wordpress-multisite-subdomain-external.conf.tpl")"
    else
        error "Unknown WordPress Multisite network mode"
        return 1
    fi

    if ! is_boolean_yes "$WORDPRESS_ENABLE_XML_RPC"; then
        apache_config+=$'\n'"$(render-template "${template_dir}/apache-wordpress-disable-xml-rpc.tpl")"
        nginx_config+=$'\n'"$(render-template "${template_dir}/nginx-wordpress-disable-xml-rpc.tpl")"
    fi

    web_server_config_create_flags+=("--apache-extra-directory-configuration" "$apache_config" "--nginx-additional-configuration" "$nginx_config")
    [[ -n "$nginx_external_config" ]] && web_server_config_create_flags+=("--nginx-external-configuration" "$nginx_external_config")
    ensure_web_server_app_configuration_exists "wordpress" --type "php" "${web_server_config_create_flags[@]}"
}
