#!/bin/bash
#
# Bitnami Magento library

# shellcheck disable=SC1091

# Load generic libraries
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnet.sh
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
# Validate settings in MAGENTO_* env vars
# Globals:
#   MAGENTO_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
magento_validate() {
    debug "Validating settings in MAGENTO_* environment variables..."
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

    # Validate user inputs
    check_empty_value "MAGENTO_HOST"
    check_empty_value "MAGENTO_PASSWORD"
    # See: https://devdocs.magento.com/guides/v2.4/config-guide/bootstrap/magento-modes.html
    check_multi_value "MAGENTO_MODE" "default developer production"
    check_yes_no_value "MAGENTO_ENABLE_HTTPS"
    check_yes_no_value "MAGENTO_ENABLE_ADMIN_HTTPS"
    check_yes_no_value "MAGENTO_SKIP_REINDEX"
    check_yes_no_value "MAGENTO_SKIP_BOOTSTRAP"

    # HTTP cache server configuration validations
    check_yes_no_value "MAGENTO_ENABLE_HTTP_CACHE"
    if is_boolean_yes "$MAGENTO_ENABLE_HTTP_CACHE"; then
        check_empty_value "MAGENTO_HTTP_CACHE_BACKEND_HOST"
        check_empty_value "MAGENTO_HTTP_CACHE_BACKEND_PORT_NUMBER"
        check_empty_value "MAGENTO_HTTP_CACHE_SERVER_HOST"
        check_empty_value "MAGENTO_HTTP_CACHE_SERVER_PORT_NUMBER"
    fi

    # Database configuration validations
    check_resolved_hostname "$MAGENTO_DATABASE_HOST"
    validate_port "$MAGENTO_DATABASE_PORT_NUMBER"
    check_yes_no_value "MAGENTO_ENABLE_DATABASE_SSL"
    if is_boolean_yes "$MAGENTO_ENABLE_DATABASE_SSL"; then
        check_yes_no_value "MAGENTO_VERIFY_DATABASE_SSL"
        check_mounted_file "MAGENTO_DATABASE_SSL_CERT_FILE"
        check_mounted_file "MAGENTO_DATABASE_SSL_KEY_FILE"
        check_mounted_file "MAGENTO_DATABASE_SSL_CA_FILE"
    fi

    # Search engine configuration validations
    check_multi_value "MAGENTO_SEARCH_ENGINE" "elasticsearch5 elasticsearch6 elasticsearch7"
    if [[ "$MAGENTO_SEARCH_ENGINE" =~ ^elasticsearch ]]; then
        check_resolved_hostname "$MAGENTO_ELASTICSEARCH_HOST"
        validate_port "$MAGENTO_ELASTICSEARCH_PORT_NUMBER"
        check_yes_no_value "MAGENTO_ELASTICSEARCH_ENABLE_AUTH"
        if is_boolean_yes "$MAGENTO_ELASTICSEARCH_ENABLE_AUTH"; then
            check_empty_value "MAGENTO_ELASTICSEARCH_USER"
            check_empty_value "MAGENTO_ELASTICSEARCH_PASSWORD"
        fi
    fi

    # Validate credentials
    if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    else
        for empty_env_var in "MAGENTO_DATABASE_PASSWORD" "MAGENTO_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        done
    fi

    # Check that the web server is properly set up
    web_server_validate || print_validation_error "Web server validation failed"

    return "$error_code"
}

########################
# Ensure Magento is initialized
# Globals:
#   MAGENTO_*
# Arguments:
#   None
# Returns:
#   None
#########################
magento_initialize() {
    # Check if Magento has already been initialized and persisted in a previous run
    local db_host db_port db_name db_user db_pass
    local es_host es_port es_user es_pass
    local -r app_name="magento"
    if ! is_app_initialized "$app_name"; then
        # Parse user inputs for the Magento CLI calls below
        db_host="$MAGENTO_DATABASE_HOST"
        db_port="$MAGENTO_DATABASE_PORT_NUMBER"
        db_name="$MAGENTO_DATABASE_NAME"
        db_user="$MAGENTO_DATABASE_USER"
        db_pass="$MAGENTO_DATABASE_PASSWORD"
        # CLI flags to use for 'setup:config:create' (to create config files but not modify the database)
        local -a magento_setup_cli_flags=(
            "--no-interaction"
            "--backend-frontname" "$MAGENTO_ADMIN_URL_PREFIX"
            "--db-host" "${db_host}:${db_port}"
            "--db-name" "$db_name"
            "--db-user" "$db_user"
            "--db-password" "$db_pass"
        )
        # Extra flags for when enabling SSL database connections
        if is_boolean_yes "$MAGENTO_ENABLE_DATABASE_SSL"; then
            info "Enabling SSL for database connections"
            is_boolean_yes "$MAGENTO_VERIFY_DATABASE_SSL" && magento_setup_cli_flags+=("--db-ssl-verify")
            ! is_empty_value "$MAGENTO_DATABASE_SSL_CERT_FILE" && magento_setup_cli_flags+=("--db-ssl-cert" "$MAGENTO_DATABASE_SSL_CERT_FILE")
            ! is_empty_value "$MAGENTO_DATABASE_SSL_KEY_FILE" && magento_setup_cli_flags+=("--db-ssl-key" "$MAGENTO_DATABASE_SSL_KEY_FILE")
            ! is_empty_value "$MAGENTO_DATABASE_SSL_CA_FILE" && magento_setup_cli_flags+=("--db-ssl-ca" "$MAGENTO_DATABASE_SSL_CA_FILE")
        fi
        # Set cache server (i.e. Varnish) configuration to Magento's 'env.php' configuration file
        if is_boolean_yes "$MAGENTO_ENABLE_HTTP_CACHE"; then
            info "Enabling HTTP cache server"
            magento_setup_cli_flags+=("--http-cache-hosts" "${MAGENTO_HTTP_CACHE_SERVER_HOST}:${MAGENTO_HTTP_CACHE_SERVER_PORT_NUMBER}")
        fi
        # CLI flags to use for 'setup:install' (based on the flags to use for 'setup:config:create')
        local -a magento_install_cli_flags=(
            "${magento_setup_cli_flags[@]}"
            "--search-engine" "$MAGENTO_SEARCH_ENGINE"
            "--admin-firstname" "$MAGENTO_FIRST_NAME"
            "--admin-lastname" "$MAGENTO_LAST_NAME"
            "--admin-email" "$MAGENTO_EMAIL"
            "--admin-user" "$MAGENTO_USERNAME"
            "--admin-password" "$MAGENTO_PASSWORD"
        )
        # Search engine configuration
        if [[ "$MAGENTO_SEARCH_ENGINE" =~ ^elasticsearch ]]; then
            es_host="$MAGENTO_ELASTICSEARCH_HOST"
            es_port="$MAGENTO_ELASTICSEARCH_PORT_NUMBER"
            es_user="$MAGENTO_ELASTICSEARCH_USER"
            es_pass="$MAGENTO_ELASTICSEARCH_PASSWORD"
            # Define whether Elasticsearch auth is enabled
            local es_auth="0"
            is_boolean_yes "$MAGENTO_ELASTICSEARCH_ENABLE_AUTH" && es_auth="1"
            # Elasticsearch configuration is stored in the database, so we only need to specify for 'setup:install'
            if is_boolean_yes "$MAGENTO_ELASTICSEARCH_USE_HTTPS"; then
                magento_install_cli_flags+=(
                    "--elasticsearch-host" "https://$es_host"
                )
            else
                magento_install_cli_flags+=(
                    "--elasticsearch-host" "$es_host"
                )
            fi
            magento_install_cli_flags+=(
                "--elasticsearch-port" "$es_port"
                "--elasticsearch-enable-auth" "$es_auth"
                "--elasticsearch-username" "$es_user"
                "--elasticsearch-password" "$es_pass"
            )
        fi
        # Allow to specify extra CLI flags, but ensure they are added last
        local -a magento_extra_cli_flags
        read -r -a magento_extra_cli_flags <<< "$MAGENTO_EXTRA_INSTALL_ARGS"
        if [[ "${#magento_extra_cli_flags[@]}" -gt 0 ]]; then
            magento_setup_cli_flags+=("${magento_extra_cli_flags[@]}")
            magento_install_cli_flags+=("${magento_extra_cli_flags[@]}")
        fi

        # Ensure Magento persisted directories exist (i.e. when a volume has been mounted to /bitnami)
        info "Ensuring Magento directories exist"
        ensure_dir_exists "$MAGENTO_VOLUME_DIR"
        # Use daemon:root ownership for compatibility when running as a non-root user
        if am_i_root; then
            info "Configuring permissions"
            configure_permissions_ownership "$MAGENTO_VOLUME_DIR" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
        fi

        # Wait until external services are available
        info "Trying to connect to the database server"
        magento_wait_for_db_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
        if [[ "$MAGENTO_SEARCH_ENGINE" =~ ^elasticsearch ]]; then
            info "Trying to connect to Elasticsearch"
            magento_wait_for_es_connection "$es_host" "$es_port"
        fi

        if ! is_boolean_yes "$MAGENTO_SKIP_BOOTSTRAP"; then
            info "Running Magento install script"
            magento_execute setup:install "${magento_install_cli_flags[@]}"

            # Define whether the site must be accessed via HTTP or HTTPS
            # If the site must be accessed via HTTPS, we will force the admin panel to be accessed via HTTPS too
            local use_secure="0"
            is_boolean_yes "$MAGENTO_ENABLE_HTTPS" && use_secure="1"
            local use_secure_admin="0"
            ( is_boolean_yes "$MAGENTO_ENABLE_HTTPS" || is_boolean_yes "$MAGENTO_ENABLE_ADMIN_HTTPS" ) && use_secure_admin="1"

            # Set additional store configuration in the database
            # These options were previously added via 'magento setup:install', but that is now deprecated
            # See: https://devdocs.magento.com/guides/v2.4/config-guide/prod/config-reference-most.html#web-paths
            # Enable/disable HTTPS in frontend and admin panel, respectively
            magento_conf_set "web/secure/use_in_frontend" "$use_secure"
            magento_conf_set "web/secure/use_in_adminhtml" "$use_secure_admin"
            # Set domain name
            magento_update_hostname "$MAGENTO_HOST"
            # Enable friendly URLs
            magento_conf_set "web/seo/use_rewrites" 1
            # Enable HTTP cache: https://devdocs.magento.com/guides/v2.4/config-guide/varnish/config-varnish-magento.html
            if is_boolean_yes "$MAGENTO_ENABLE_HTTP_CACHE"; then
                # Set Varnish as cache server (1: built-in, 2: Varnish)
                # See: vendor/magento/module-page-cache/model/Config.php -> "Cache types" comment
                magento_conf_set "system/full_page_cache/caching_application" 2
                # Specify backend host/port for Varnish config file generation via Admin panel
                magento_conf_set "system/full_page_cache/varnish/backend_host" "$MAGENTO_HTTP_CACHE_BACKEND_HOST"
                magento_conf_set "system/full_page_cache/varnish/backend_port" "$MAGENTO_HTTP_CACHE_BACKEND_PORT_NUMBER"
            fi
        else
            info "An already initialized Magento database was provided, configuration will be skipped"

            info "Generating configuration files"
            # First generate the 'env.php' configuration file
            # It is essential to add the 'installed' setting, or none of the below calls would work
            # Note: The file will be prettified/regenerated after running the commands
            magento_execute setup:config:set "${magento_setup_cli_flags[@]}"
            replace_in_file "$MAGENTO_CONF_FILE" '\];' ",'install' => ['date' => '$(date -u)']];"
            # The below steps are usually handled by the installation script, which is not executed in this case
            # Enable all modules to generate the 'config.php' file
            magento_execute module:enable --all
            # Enable all cache types in 'env.php' (none are enabled via 'setup:config:set')
            magento_execute cache:enable

            # Finally, after the Magento is properly installed on disk, perform database schema upgrade
            info "Upgrading database schema"
            magento_execute setup:upgrade
        fi

        # The below steps are common for both normal installations and installations with 'MAGENTO_SKIP_BOOTSTRAP',
        # since they rely on modifying files generated during initialization

        # Disable 2FA module by default as it prevents access to admin panel after the first login
        # Setup would be hard as it would require to configure Sendmail (SMTP not supported) and authorization keys
        # 'You need to configure Two-Factor Authorization in order to proceed to your store's admin area'
        # 'An E-mail was sent to you with further instructions'
        magento_execute module:disable "Magento_TwoFactorAuth"

        # Set the Magento mode in 'env.php'
        # See: https://devdocs.magento.com/guides/v2.4/config-guide/bootstrap/magento-modes.html
        magento_execute deploy:mode:set "$MAGENTO_MODE"

        # Create initial indexes (this is not performed by the setup script)
        if is_boolean_yes "$MAGENTO_SKIP_REINDEX"; then
            info "Skipping reindex"
        else
            info "Reindexing"
            magento_execute indexer:reindex
        fi

        # Flush cache after changing configuration and reindexing, to avoid warnings in admin panel
        info "Flushing cache"
        magento_execute cache:flush

        # Magento 'default' and 'developer' modes build required assets on demand
        # However, due to the huge amount of those, the first-time page load is huge, so we build them beforehand
        if is_boolean_yes "$MAGENTO_DEPLOY_STATIC_CONTENT" && [[ "$MAGENTO_MODE" != "production" ]]; then
            info "Deploying static files"
            magento_execute setup:static-content:deploy -f
        fi

        # Configure PHP options provided via envvars in .user.ini (which overrides configuration in php.ini)
        for user_ini_file in "${MAGENTO_BASE_DIR}/.user.ini" "${MAGENTO_BASE_DIR}/pub/.user.ini"; do
            configure_permissions_ownership "$user_ini_file" -f "660"
            php_set_runtime_config "$user_ini_file"
            # Ensure that the .user.ini files cannot be written to by the web server user
            # This file allows for PHP-FPM to set application-specific PHP settings, and could be a security risk if left writable
            configure_permissions_ownership "$user_ini_file" -f "440"
        done

        info "Persisting Magento installation"
        persist_app "$app_name" "$MAGENTO_DATA_TO_PERSIST"
    else
        info "Restoring persisted Magento installation"
        restore_persisted_app "$app_name" "$MAGENTO_DATA_TO_PERSIST"

        # Compatibility with previous container images
        if [[ "$(ls "$MAGENTO_VOLUME_DIR")" = "htdocs" ]]; then
            warn "The persisted data for this Magento installation is located at '${MAGENTO_VOLUME_DIR}/htdocs' instead of '${MAGENTO_VOLUME_DIR}'"
            warn "This is deprecated and support for this may be removed in a future release"
            rm "$MAGENTO_BASE_DIR"
            ln -s "${MAGENTO_VOLUME_DIR}/htdocs" "$MAGENTO_BASE_DIR"
        fi

        info "Trying to connect to the database server"
        db_name="$(magento_conf_get "db" "connection" "default" "dbname")"
        db_user="$(magento_conf_get "db" "connection" "default" "username")"
        db_pass="$(magento_conf_get "db" "connection" "default" "password")"
        # Separate 'host:port' with native Bash split functions (fallback to default port number if not specified)
        db_host_port="$(magento_conf_get "db" "connection" "default" "host")"
        db_host="${db_host_port%:*}"
        if [[ "$db_host_port" =~ :[0-9]+$ ]]; then
            # Use '##' to extract only the part after the last colon, to avoid any possible issues with IPv6 addresses
            db_port="${db_host_port##*:}"
        else
            db_port="$MAGENTO_DATABASE_PORT_NUMBER"
        fi
        magento_wait_for_db_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"

        if [[ "$MAGENTO_SEARCH_ENGINE" =~ ^elasticsearch ]]; then
            es_host="$MAGENTO_ELASTICSEARCH_HOST"
            es_port="$MAGENTO_ELASTICSEARCH_PORT_NUMBER"
            info "Trying to connect to Elasticsearch"
            magento_wait_for_es_connection "$es_host" "$es_port"
        fi

        # Perform database schema upgrade
        info "Upgrading database schema"
        magento_execute setup:upgrade
    fi

    # Magento includes a command for setting up the cron jobs via the 'cron:install' command
    # However, cron entries for the 'daemon' user are disabled in some Bitnami images for security purposes (via /etc/cron.deny)
    # Therefore we have to generate the entry manually (NOTE: the resulting command is equivalent)
    local -a cron_cmd=(
        # Use an array for easy concatenation of strings
        "${PHP_BIN_DIR}/php ${MAGENTO_BIN_DIR}/magento cron:run 2>&1"
        "| grep -v \"Ran jobs by schedule\" >> ${MAGENTO_BASE_DIR}/var/log/magento.cron.log"
    )
    # Ensure Magento cron jobs are created when running setup with a root user
    if am_i_root; then
        generate_cron_conf "magento" "${cron_cmd[*]}" --run-as "$WEB_SERVER_DAEMON_USER" --schedule "*/1 * * * *"
    else
        warn "Skipping cron configuration for Magento because of running as a non-root user"
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Executes the Magento CLI with the specified arguments
# Globals:
#   MAGENTO_*
# Arguments:
#   $1..$n - Arguments to pass to the CLI call
# Returns:
#   None
#########################
magento_execute() {
    local -a cmd=("php" "${MAGENTO_BIN_DIR}/magento" "$@")
    # Run as web server user to avoid having to change permissions/ownership afterwards
    if am_i_root; then
        debug_execute gosu "$WEB_SERVER_DAEMON_USER" "${cmd[@]}"
    else
        debug_execute "${cmd[@]}"
    fi
}

########################
# Add or modify an entry in the Magento configuration file (config.inc.php)
# Globals:
#   MAGENTO_*
# Arguments:
#   $1 - PHP variable name
#   $2 - Value to assign to the PHP variable
#   $3 - Whether the value is a literal, or if instead it should be quoted (default: no)
# Returns:
#   None
#########################
magento_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:?value missing}"
    debug "Setting Magento configuration value '${key}' to '${value}'"
    magento_execute config:set "$key" "$value"
}

########################
# Get an entry from the Magento configuration file (config.inc.php)
# Globals:
#   MAGENTO_*
# Arguments:
#   $1 - PHP variable name
# Returns:
#   None
#########################
magento_conf_get() {
    local key="${1:?key missing}"
    # Print the key path in a readable format (keeping in mind that the config file simply returns a PHP array)
    local key_readable_format
    key_readable_format="/$(echo "$*" | sed -E 's/\s+/\//g')"
    debug "Getting configuration path '${key_readable_format}' from Magento configuration"
    # Construct a PHP array path for the configuration, so each key can be passed as a separate argument
    local path=""
    for key in "$@"; do
        path+="['${key}']"
    done
    php -r "\$config = require ('${MAGENTO_CONF_FILE}'); print_r(\$config$path);"
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
magento_wait_for_db_connection() {
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
# Wait until Elasticsearch is accessible
# Globals:
#   *
# Arguments:
#   $1 - Elasticsearch host
#   $2 - Elasticsearch port
# Returns:
#   true if the Elasticsearch connection succeeded, false otherwise
#########################
magento_wait_for_es_connection() {
    local -r es_host="${1:?missing database host}"
    local -r es_port="${2:?missing database port}"
    if ! retry_while "debug_execute wait-for-port --timeout 5 --host ${es_host} ${es_port}"; then
        error "Could not connect to Elasticsearch"
        return 1
    fi
}

########################
# Update Magento hostname
# Globals:
#   MAGENTO_*
# Arguments:
#   $1 - hostname
# Returns:
#   None
#########################
magento_update_hostname() {
    local -r hostname="${1:?missing hostname}"

    # Define Magento base URLs (without port if not needed)
    local magento_http_base_url="http://${hostname}"
    [[ "$MAGENTO_EXTERNAL_HTTP_PORT_NUMBER" != "80" ]] && magento_http_base_url+=":${MAGENTO_EXTERNAL_HTTP_PORT_NUMBER}"
    magento_https_base_url="https://${hostname}"
    [[ "$MAGENTO_EXTERNAL_HTTPS_PORT_NUMBER" != "443" ]] && magento_https_base_url+=":${MAGENTO_EXTERNAL_HTTPS_PORT_NUMBER}"

    # Magento requires the trailing slash ('/') to be added, or it will fail with 'Invalid Base URL. Value must be a URL or (...)'
    magento_conf_set "web/secure/base_url" "${magento_https_base_url}/"
    magento_conf_set "web/unsecure/base_url" "${magento_http_base_url}/"
}
