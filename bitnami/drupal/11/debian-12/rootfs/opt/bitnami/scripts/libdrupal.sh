#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Drupal library

# shellcheck disable=SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libversion.sh
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
# Validate settings in DRUPAL_* env vars
# Globals:
#   DRUPAL_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
drupal_validate() {
    debug "Validating settings in DRUPAL_* environment variables..."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    check_multi_value() {
        if [[ " ${2} " != *" ${!1} "* ]]; then
            print_validation_error "The allowed values for ${1} are: ${2}"
        fi
    }

    check_yes_no_value() {
        if ! is_yes_no_value "${!1}" && ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for ${1} are: yes no"
        fi
    }

    check_resolved_hostname() {
        if ! is_hostname_resolved "$1"; then
            warn "Hostname $1 could not be resolved. This could lead to connection issues"
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
    is_file_writable "$DRUPAL_CONF_FILE" || warn "The Drupal configuration file '${DRUPAL_CONF_FILE}' is not writable. Configurations based on environment variables will not be applied for this file."

    # Validate user inputs
    ! is_empty_value "$DRUPAL_SKIP_BOOTSTRAP" && check_yes_no_value "DRUPAL_SKIP_BOOTSTRAP"
    ! is_empty_value "$DRUPAL_DATABASE_PORT_NUMBER" && check_valid_port "DRUPAL_DATABASE_PORT_NUMBER"
    ! is_empty_value "$DRUPAL_DATABASE_HOST" && check_resolved_hostname "$DRUPAL_DATABASE_HOST"
    check_mounted_file "DRUPAL_DATABASE_TLS_CA_FILE"

    # Validate database credentials
    if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    else
        for empty_env_var in "DRUPAL_DATABASE_PASSWORD" "DRUPAL_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        done
    fi

    # Validate SMTP credentials
    if ! is_empty_value "$DRUPAL_SMTP_HOST"; then
        for empty_env_var in "DRUPAL_SMTP_USER" "DRUPAL_SMTP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && warn "The ${empty_env_var} environment variable is empty or not set."
        done
        is_empty_value "$DRUPAL_SMTP_PORT_NUMBER" && print_validation_error "The DRUPAL_SMTP_PORT_NUMBER environment variable is empty or not set."
        ! is_empty_value "$DRUPAL_SMTP_PORT_NUMBER" && check_valid_port "DRUPAL_SMTP_PORT_NUMBER"
        ! is_empty_value "$DRUPAL_SMTP_PROTOCOL" && check_multi_value "DRUPAL_SMTP_PROTOCOL" "standard tls ssl"
    fi

    # Check that the web server is properly set up
    web_server_validate || print_validation_error "Web server validation failed"

    return "$error_code"
}

########################
# Ensure Drupal is initialized
# Globals:
#   DRUPAL_*
# Arguments:
#   None
# Returns:
#   None
#########################
drupal_initialize() {
    # Update Drupal configuration via mounted configuration files and environment variables
    if is_file_writable "$DRUPAL_CONF_FILE"; then
        # Enable mounted configuration files
        if [[ -f "$DRUPAL_MOUNTED_CONF_FILE" ]]; then
            info "Found mounted Drupal configuration file '${DRUPAL_MOUNTED_CONF_FILE}', copying to '${DRUPAL_CONF_FILE}'"
            cp "$DRUPAL_MOUNTED_CONF_FILE" "$DRUPAL_CONF_FILE"
            return
        fi
    fi

    # Check if Drupal has already been initialized and persisted in a previous run
    local -r app_name="drupal"
    if ! is_app_initialized "$app_name"; then
        info "Trying to connect to the database server"
        drupal_wait_for_db_connection "$DRUPAL_DATABASE_HOST" "$DRUPAL_DATABASE_PORT_NUMBER" "$DRUPAL_DATABASE_NAME" "$DRUPAL_DATABASE_USER" "$DRUPAL_DATABASE_PASSWORD"

        # Ensure the Drupal base directory exists and has proper permissions
        info "Configuring file permissions for Drupal"
        ensure_dir_exists "$DRUPAL_VOLUME_DIR"
        # Use daemon:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$DRUPAL_VOLUME_DIR" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"

        if ! is_boolean_yes "$DRUPAL_SKIP_BOOTSTRAP"; then
            # Perform initial bootstrapping for Drupal
            info "Installing Drupal site"
            drupal_site_install
            if ! is_empty_value "$DRUPAL_ENABLE_MODULES"; then
                info "Enabling Drupal modules"
                drupal_enable_modules
            fi
            if ! is_empty_value "$DRUPAL_SMTP_HOST"; then
                info "Configuring SMTP"
                drupal_configure_smtp
            fi
            info "Flushing Drupal cache"
            drupal_flush_cache
        else
            info "An already initialized Drupal database was provided, configuration will be skipped"
            if is_empty_value "$DRUPAL_DATABASE_TLS_CA_FILE"; then
                drupal_set_database_settings
            else
                drupal_set_database_ssl_settings
            fi

            # Drupal expects a directory for storing site configuration
            # For more info see https://www.drupal.org/docs/configuration-management
            drupal_create_config_directory

            # Drupal needs a hash value to build one-time login links, cancel links, form tokens, etc.
            drupal_set_hash_salt
            drupal_update_database
        fi

        info "Persisting Drupal installation"
        persist_app "$app_name" "$DRUPAL_DATA_TO_PERSIST"
    else
        info "Restoring persisted Drupal installation"
        restore_persisted_app "$app_name" "$DRUPAL_DATA_TO_PERSIST"
        info "Trying to connect to the database server"
        db_host="$(drupal_database_conf_get 'host')"
        db_port="$(drupal_database_conf_get 'port')"
        db_name="$(drupal_database_conf_get 'database')"
        db_user="$(drupal_database_conf_get 'username')"
        db_pass="$(drupal_database_conf_get 'password')"
        drupal_wait_for_db_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
        drupal_update_database
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Get a database entry from the Drupal configuration file (settings.php)
# Globals:
#   DRUPAL_*
# Arguments:
#   $1 - Key
# Returns:
#   None
#########################
drupal_database_conf_get() {
    local -r key="${1:?key missing}"
    debug "Getting ${key} from Drupal database configuration"
    grep -E "^\s*'${key}' =>" "$DRUPAL_CONF_FILE" | awk -F'=>' '{gsub(/[ ,'\''"]/, "", $2); print $2}'
}

########################
# Add or modify an entry in the Drupal configuration file (settings.php)
# Globals:
#   DRUPAL_*
# Arguments:
#   $1 - PHP variable name
#   $2 - Value to assign to the PHP variable
#   $3 - Whether the value is a literal, or if instead it should be quoted (default: no)
# Returns:
#   None
#########################
drupal_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:?value missing}"
    local -r is_literal="${3:-no}"
    debug "Setting ${key} to '${value}' in Drupal configuration (literal: ${is_literal})"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^(#\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")\s*=.*"
    local entry
    is_boolean_yes "$is_literal" && entry="${key} = $value;" || entry="${key} = '$value';"
    # Check if the configuration exists in the file
    if grep -q -E "$sanitized_pattern" "$DRUPAL_CONF_FILE"; then
        # It exists, so replace the line
        replace_in_file "$DRUPAL_CONF_FILE" "$sanitized_pattern" "$entry"
    else
        echo "$entry" >> "$DRUPAL_CONF_FILE"
    fi
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
drupal_wait_for_db_connection() {
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
# Drupal Site Install
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
drupal_site_install() {
    is_empty_value "$DRUPAL_DATABASE_TLS_CA_FILE" || drupal_set_database_ssl_settings

    (
        # Unfortunately there is no way to disable mail sending via sendmail when installing Drupal
        # The "hack" consists of overriding the sendmail path to an executable that does nothing (i.e. "/bin/true")
        # This is also what Drush is doing in their CI
        PHP_OPTIONS="-d sendmail_path=$(which true)"
        export PHP_OPTIONS

        drush_execute "site:install" \
            "--db-url=mysql://${DRUPAL_DATABASE_USER}:${DRUPAL_DATABASE_PASSWORD}@${DRUPAL_DATABASE_HOST}:${DRUPAL_DATABASE_PORT_NUMBER}/${DRUPAL_DATABASE_NAME}" \
            "--account-name=${DRUPAL_USERNAME}" \
            "--account-mail=${DRUPAL_EMAIL}" \
            "--account-pass=${DRUPAL_PASSWORD}" \
            "--site-name=${DRUPAL_SITE_NAME}" \
            "--site-mail=${DRUPAL_EMAIL}" \
            "-y" "$DRUPAL_PROFILE"
    )

    # When Drupal settings are patched to allow SSL database connections, the database settings block is duplicated
    # after the installation with Drush
    is_empty_value "$DRUPAL_DATABASE_TLS_CA_FILE" || drupal_remove_duplicated_database_settings
    # Restrict permissions of the configuration file to keep the site secure
    if am_i_root; then
        configure_permissions_ownership "$DRUPAL_CONF_FILE" -u "root" -g "$WEB_SERVER_DAEMON_USER" -f "644"
    else
        # HACK: The drupal installation is changing the ownership of the sites/default folder. When running as
        # 1001:1001 this is causing an issue with the persist_app function. This sets the folder with write permissions
        # so the function works. We add || true to not break docker-compose installations
        chmod u+w "${DRUPAL_BASE_DIR}/sites/default" || true
    fi
}

########################
# Create Drupal sync configuration directory (DRUPAL_SKIP_BOOTSTRAP only)
# Globals:
#   DRUPAL_BASE_DIR
# Arguments:
#   None
# Returns:
#   None
#########################
drupal_create_config_directory() {
    local config_sync_dir="${DRUPAL_CONFIG_SYNC_DIR:-}"
    if is_empty_value "$config_sync_dir"; then
        config_sync_dir="${DRUPAL_BASE_DIR}/sites/default/files/config_$(generate_random_string -t alphanumeric -c 16)"
    fi
    ensure_dir_exists "$config_sync_dir"
    drupal_conf_set "\$settings['config_sync_directory']" "$config_sync_dir"
}

########################
# Create Drupal hash salt value (DRUPAL_SKIP_BOOTSTRAP only)
# Globals:
#   DRUPAL_HASH_SALT
# Arguments:
#   None
# Returns:
#   None
#########################
drupal_set_hash_salt() {
    local hash_salt="${DRUPAL_HASH_SALT:-}"
    if is_empty_value "$hash_salt"; then
        hash_salt="$(generate_random_string -t alphanumeric -c 32)"
    fi
    drupal_conf_set "\$settings['hash_salt']" "$hash_salt"
}

########################
# Execute Drush Tool
# Globals:
#   *
# Arguments:
#   $@ - Arguments to pass to the Drush tool
# Returns:
#   None
#########################
drush_execute() {
    if am_i_root; then
        debug_execute run_as_user "$WEB_SERVER_DAEMON_USER" drush "--root=${DRUPAL_BASE_DIR}" "$@"
    else
        debug_execute drush "--root=${DRUPAL_BASE_DIR}" "$@"
    fi
}

########################
# Execute Drush Tool to set a config option
# Globals:
#   *
# Arguments:
#   $1 - config group
#   $2 - config key
#   $3 - config value
# Returns:
#   None
#########################
drush_config_set() {
    local -r group="${1:?missing config group}"
    local -r key="${2:?missing config key}"
    local -r value="${3:-}"

    drush_execute "config-set" "--yes" "$group" "$key" "$value"
}

########################
# Drupal enable modules
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
drupal_enable_modules() {
    local -a modules
    read -r -a modules <<< "${DRUPAL_ENABLE_MODULES/,/ }"
    [[ "${#modules[@]}" -gt 0 ]] || return 0
    drush_execute "pm:enable" "--yes" "${modules[@]}"
}

########################
# Drupal configure SMTP
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
drupal_configure_smtp() {
    drush_execute "pm:enable" "--yes" "smtp"

    drush_config_set "system.mail" "interface.default" "SMTPMailSystem"
    drush_config_set "smtp.settings" "smtp_on" "1"
    drush_config_set "smtp.settings" "smtp_host" "$DRUPAL_SMTP_HOST"
    drush_config_set "smtp.settings" "smtp_port" "$DRUPAL_SMTP_PORT_NUMBER"
    drush_config_set "smtp.settings" "smtp_protocol" "$DRUPAL_SMTP_PROTOCOL"
    drush_config_set "smtp.settings" "smtp_username" "$DRUPAL_SMTP_USER"
    drush_config_set "smtp.settings" "smtp_password" "$DRUPAL_SMTP_PASSWORD"
    drush_config_set "smtp.settings" "smtp_from" "$DRUPAL_EMAIL"
    drush_config_set "smtp.settings" "smtp_fromname" "$DRUPAL_SITE_NAME"
}

########################
# Drupal flush cache
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
drupal_flush_cache() {
    drush_execute "cache:rebuild"
}

########################
# Drupal update database
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
drupal_update_database() {
    debug 'Upgrading Drupal database with drush...'
    drush_execute "updatedb"
}

########################
# Drupal set database SSL settings
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
drupal_set_database_ssl_settings() {
    cat >>"$DRUPAL_CONF_FILE" <<EOF
\$databases['default']['default'] = array ( // Database block with SSL support
  'database' => '${DRUPAL_DATABASE_NAME}',
  'username' => '${DRUPAL_DATABASE_USER}',
  'password' => '${DRUPAL_DATABASE_PASSWORD}',
  'prefix' => '',
  'host' => '${DRUPAL_DATABASE_HOST}',
  'port' => '${DRUPAL_DATABASE_PORT_NUMBER}',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
  'pdo' => array (
    PDO::MYSQL_ATTR_SSL_CA => '${DRUPAL_DATABASE_TLS_CA_FILE}',
    PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => 0
  )
);
EOF
}

########################
# Drupal set database non-SSL settings (DRUPAL_SKIP_BOOTSTRAP only)
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
drupal_set_database_settings() {
    cat >>"$DRUPAL_CONF_FILE" <<EOF
\$databases['default']['default'] = array ( // Database block with SSL support
  'database' => '${DRUPAL_DATABASE_NAME}',
  'username' => '${DRUPAL_DATABASE_USER}',
  'password' => '${DRUPAL_DATABASE_PASSWORD}',
  'prefix' => '',
  'host' => '${DRUPAL_DATABASE_HOST}',
  'port' => '${DRUPAL_DATABASE_PORT_NUMBER}',
  'namespace' => 'Drupal\\Core\\Database\\Driver\\mysql',
  'driver' => 'mysql',
);
EOF
}

########################
# Drupal remove duplicated database block from settings file
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
drupal_remove_duplicated_database_settings() {
    local -r first_line_block=$'\$databases\[\'default\'\]\[\'default\'\] = array \($'
    local -r last_line_block='\);'

    remove_in_file "$DRUPAL_CONF_FILE" "${first_line_block}/,/${last_line_block}"
}

########################
# Drupal fix htaccess warning protection.
# Drupal checks for the htaccess file to prevent malicious attacks
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
drupal_fix_htaccess_warning_protection() {
    local -r files_dir="${DRUPAL_BASE_DIR}/sites/default/files/"
    local -r htaccess_file="${files_dir}/.htaccess"

    ensure_dir_exists "$files_dir"
    cat <<EOF >"$htaccess_file"
# Recommended protections: https://www.drupal.org/forum/newsletters/security-advisories-for-drupal-core/2013-11-20/sa-core-2013-003-drupal-core

# Turn off all options we don\'t need.
Options -Indexes -ExecCGI -Includes -MultiViews

# Set the catch-all handler to prevent scripts from being executed.
SetHandler Drupal_Security_Do_Not_Remove_See_SA_2006_006
<Files *>
  # Override the handler again if we\'re run later in the evaluation list.
  SetHandler Drupal_Security_Do_Not_Remove_See_SA_2013_003
</Files>

# If we know how to do it safely, disable the PHP engine entirely.
<IfModule mod_php7.c>
  php_flag engine off
</IfModule>
EOF
}
