#!/bin/bash
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
            info "Running install script"
            debug_execute php "${OPENCART_BASE_DIR}/install/cli_install.php" install "${opencart_cli_args[@]}"
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
            info "Generating configuration file"
            opencart_create_config_files "${opencart_cli_args[@]}"
            info "Upgrading database schema"
            opencart_upgrade
        fi
        info "Updating Opencart hostname"
        opencart_update_hostname "${OPENCART_HOST:-localhost}"

        info "Persisting OpenCart installation"
        persist_app "$app_name" "$OPENCART_DATA_TO_PERSIST"

        # This is executed after persisting the app directory to avoid a broken install in case of an error
        opencart_protect_storage_dir
    else
        info "Restoring persisted OpenCart installation"
        restore_persisted_app "$app_name" "$OPENCART_DATA_TO_PERSIST"
        info "Trying to connect to the database server"
        db_host="$(opencart_conf_get "DB_HOSTNAME")"
        db_port="$(opencart_conf_get "DB_PORT")"
        db_name="$(opencart_conf_get "DB_DATABASE")"
        db_user="$(opencart_conf_get "DB_USERNAME")"
        db_pass="$(opencart_conf_get "DB_PASSWORD")"
        opencart_wait_for_db_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
        info "Upgrading database schema"
        opencart_upgrade
    fi

    # Remove previous storage location to avoid confusion
    # Note that 'opencart_protect_storage_dir' is not executed for upgrades, so it exists even if removed in that function
    rm -rf "${OPENCART_BASE_DIR}/system/storage"

    # Remove the installation page for security purposes
    rm -rf "${OPENCART_BASE_DIR}/install"

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Add or modify an entry in the OpenCart configuration file (config.inc.php)
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
        # The OpenCart configuration file includes all supported keys, but because of its format,
        # we cannot append contents to the end. We can assume thi
        warn "Could not set the OpenCart '${key}' configuration. Check that the file has not been modified externally."
    fi
}

########################
# Get an entry from the OpenCart configuration file (config.inc.php)
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
    # Unfortunately OpenCart does not offer an official way to do this, but "cli_install.php" includes all functionality for this
    # However, "cli_install.php" cannot be used directly because the first thing it does is modify the DB, so we only execute the parts that interest us
    # Despite being hacky, it allows to deploy a site with an existing database without needing to start from zero
    # NOTE: We're using the supported "usage" CLI option to avoid triggering an 'exit()' line, with required CLI options to create the config file
    php_execute usage "$@" <<EOF
require('${OPENCART_BASE_DIR}/install/cli_install.php');
\$options = get_options(\$argv);
define('HTTP_OPENCART', \$options['http_server']);
\$valid = valid(\$options);
if (!\$valid[0]) {
    echo "FAILED! Following inputs were missing or invalid: ";
    echo implode(', ', \$valid[1]) . "\\n\\n";
    exit(1);
}
write_config_files(\$options);
echo "Successfully setup OpenCart folder layout";
EOF
}

########################
# Run OpenCart upgrade steps
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   true if the wizard succeeded, false otherwise
#########################
opencart_upgrade() {
    local -a migrations
    read -r -a migrations <<< "$(find /opt/bitnami/opencart/install/model/upgrade/ -name '*.php' -printf '%f\0' | sort -z | xargs -0)"
    # No CLI tool is available for this purpose yet, and unfortunately the wizard runs more than 10 upgrade steps
    # requiring to reset the hostname and hope for no network issues happen during the upgrade
    # To avoid potential failures, we've found our way to hack through the process with a PHP script based on 'cli_install.php'
    for migration in "${migrations[@]}"; do
        step="${migration%%.php}"
        # This script runs the logic defined PER migration file (in 'install/model/upgrade'), so it must be run for each
        # migration (1000, 1001, ..., 1009)
        php_execute <<EOF
define('DIR_OPENCART', '${OPENCART_BASE_DIR}/');
define('DIR_APPLICATION', DIR_OPENCART . 'install/');
// Load config ignoring errors (due to already defined constants)
@require('/opt/bitnami/opencart/config.php');
// Startup
require_once(DIR_SYSTEM . 'startup.php');
// Load registry and define modules that are required by the upgrade model (in the same way they are defined in the app code)
\$registry = new Registry();
\$config = new Config();
\$config->load('default');
\$registry->set('config', \$config);
\$registry->set('cache', new Cache(\$config->get('cache_engine'), \$config->get('cache_expire')));
\$registry->set('load', new Loader(\$registry));
\$registry->set('event', new Event(\$registry));
\$registry->set('db', new DB(DB_DRIVER, DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE, DB_PORT));
// Perform upgrade step
\$registry->get('load')->model('upgrade/${step}');
\$registry->get('model_upgrade_${step}')->upgrade();
EOF
    done
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
# Update Opencart hostname
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

    # Set URL store configuration file
    opencart_conf_set HTTP_SERVER "${http_url}/"
    if is_boolean_yes "$OPENCART_ENABLE_HTTPS"; then
        opencart_conf_set HTTPS_SERVER "${https_url}/"
    else
        opencart_conf_set HTTPS_SERVER "${http_url}/"
    fi
    # Set URL in admin configuration file
    opencart_conf_set HTTP_SERVER "${http_url}/admin/" "$OPENCART_ADMIN_CONF_FILE"
    opencart_conf_set HTTP_CATALOG "${http_url}/" "$OPENCART_ADMIN_CONF_FILE"
    if is_boolean_yes "$OPENCART_ENABLE_HTTPS"; then
        opencart_conf_set HTTPS_SERVER "${https_url}/admin/" "$OPENCART_ADMIN_CONF_FILE"
        opencart_conf_set HTTPS_CATALOG "${https_url}/" "$OPENCART_ADMIN_CONF_FILE"
    else
        opencart_conf_set HTTPS_SERVER "${http_url}/admin/" "$OPENCART_ADMIN_CONF_FILE"
        opencart_conf_set HTTPS_CATALOG "${http_url}/" "$OPENCART_ADMIN_CONF_FILE"
    fi
}
