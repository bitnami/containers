#!/bin/bash
#
# Bitnami MediaWiki library

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
# Validate settings in MEDIAWIKI_* env vars
# Globals:
#   MEDIAWIKI_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
mediawiki_validate() {
    debug "Validating settings in MEDIAWIKI_* environment variables..."
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
        for empty_env_var in "MEDIAWIKI_DATABASE_PASSWORD" "MEDIAWIKI_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        done
    fi

    # Validate SMTP credentials
    if ! is_empty_value "$MEDIAWIKI_SMTP_HOST"; then
        for empty_env_var in "MEDIAWIKI_SMTP_USER" "MEDIAWIKI_SMTP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && warn "The ${empty_env_var} environment variable is empty or not set."
        done
        is_empty_value "$MEDIAWIKI_SMTP_PORT_NUMBER" && print_validation_error "The MEDIAWIKI_SMTP_PORT_NUMBER environment variable is empty or not set."
        ! is_empty_value "$MEDIAWIKI_SMTP_PORT_NUMBER" && check_valid_port "MEDIAWIKI_SMTP_PORT_NUMBER"
    fi

    # Check that the web server is properly set up
    web_server_validate || print_validation_error "Web server validation failed"

    return "$error_code"
}

########################
# Ensure MediaWiki is initialized
# Globals:
#   MEDIAWIKI_*
# Arguments:
#   None
# Returns:
#   None
#########################
mediawiki_initialize() {
    # Check if mediawiki has already been initialized and persisted in a previous run
    local -r app_name="mediawiki"
    local db_host db_port db_name db_user db_pass
    if ! is_app_initialized "$app_name"; then
        # Ensure the MediaWiki base directory exists and has proper permissions
        info "Configuring file permissions for MediaWiki"
        ensure_dir_exists "$MEDIAWIKI_VOLUME_DIR"
        # Use daemon:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$MEDIAWIKI_VOLUME_DIR" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"

        db_host="$MEDIAWIKI_DATABASE_HOST"
        db_port="$MEDIAWIKI_DATABASE_PORT_NUMBER"
        db_name="$MEDIAWIKI_DATABASE_NAME"
        db_user="$MEDIAWIKI_DATABASE_USER"
        db_pass="$MEDIAWIKI_DATABASE_PASSWORD"
        info "Trying to connect to the database server"
        mediawiki_wait_for_db_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"

        # Perform initial bootstrap of the database
        if ! is_boolean_yes "$MEDIAWIKI_SKIP_BOOTSTRAP"; then
            info "Running MediaWiki install script"
            debug_execute php "${MEDIAWIKI_BASE_DIR}/maintenance/install.php" "$MEDIAWIKI_WIKI_NAME" "$MEDIAWIKI_USERNAME" \
                --pass "$MEDIAWIKI_PASSWORD" \
                --dbserver "$db_host" \
                --dbport "$db_port" \
                --dbuser "$db_user" \
                --dbpass "$db_pass" \
                --installdbuser "$db_user" \
                --installdbpass "$db_pass" \
                --dbname "$db_name"
            # Configure admin e-mail as it is not handled by the installation command
            echo "UPDATE user SET user_email='${MEDIAWIKI_EMAIL}' WHERE user_id='1'" | mediawiki_sql_execute
        else
            info "An already initialized MediaWiki database was provided, configuration will be skipped"
            # Perform MediaWiki database schema upgrade
            debug_execute php "${MEDIAWIKI_BASE_DIR}/maintenance/update.php"
        fi

        # Configure MediaWiki based on environment variables
        info "Configuring MediaWiki settings"
        mediawiki_configure_short_urls
        mediawiki_conf_set "\$wgEnableUploads" "true" yes
        which convert >/dev/null && mediawiki_conf_set "\$wgUseImageMagick" "true" yes
        mediawiki_configure_host "$MEDIAWIKI_HOST"
        mediawiki_conf_set "\$wgEmergencyContact" "$MEDIAWIKI_EMAIL"
        mediawiki_conf_set "\$wgPasswordSender" "$MEDIAWIKI_EMAIL"
        mediawiki_configure_smtp

        info "Persisting MediaWiki installation"
        persist_app "$app_name" "$MEDIAWIKI_DATA_TO_PERSIST"
    else
        info "Restoring persisted MediaWiki installation"
        restore_persisted_app "$app_name" "$MEDIAWIKI_DATA_TO_PERSIST"
        info "Trying to connect to the database server"
        db_host="$(mediawiki_conf_get "\$wgDBserver")"
        db_name="$(mediawiki_conf_get "\$wgDBname")"
        db_user="$(mediawiki_conf_get "\$wgDBuser")"
        db_pass="$(mediawiki_conf_get "\$wgDBpassword")"
        # The port number option is only supported for PostgreSQL, so rely on environment variables instead
        db_port="$MEDIAWIKI_DATABASE_PORT_NUMBER"
        mediawiki_wait_for_db_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
        # Perform MediaWiki database schema upgrade
        debug_execute php "${MEDIAWIKI_BASE_DIR}/maintenance/update.php"
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Add or modify an entry in the MediaWiki configuration file (config.inc.php)
# Globals:
#   MEDIAWIKI_*
# Arguments:
#   $1 - PHP variable name
#   $2 - Value to assign to the PHP variable
#   $3 - Whether the value is a literal, or if instead it should be quoted (default: no)
# Returns:
#   None
#########################
mediawiki_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:-}"
    local -r is_literal="${3:-no}"
    debug "Setting ${key} to '${value}' in MediaWiki configuration (literal: ${is_literal})"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(//\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")\s*=.*"
    local entry
    is_boolean_yes "$is_literal" && entry="${key} = $value;" || entry="${key} = '$value';"
    # Check if the configuration exists in the file
    if grep -q -E "$sanitized_pattern" "$MEDIAWIKI_CONF_FILE"; then
        # It exists, so replace the line
        replace_in_file "$MEDIAWIKI_CONF_FILE" "$sanitized_pattern" "$entry"
    else
        # The MediaWiki configuration file includes all supported keys, but because of its format,
        # we cannot append contents to the end. We can assume thi
        warn "Could not set the MediaWiki '${key}' configuration. Check that the file has not been modified externally."
    fi
}

########################
# Get an entry from the MediaWiki configuration file (config.inc.php)
# Globals:
#   MEDIAWIKI_*
# Arguments:
#   $1 - PHP variable name
# Returns:
#   None
#########################
mediawiki_conf_get() {
    local -r key="${1:?key missing}"
    debug "Getting ${key} from MediaWiki configuration"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(//\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")\s*=([^;]+);"
    debug "$sanitized_pattern"
    grep -E "$sanitized_pattern" "$MEDIAWIKI_CONF_FILE" | sed -E "s|${sanitized_pattern}|\\2|" | tr -d "\"' "
}

########################
# Execute an SQL command with MediaWiki's database credentials
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   true if the command was executed properly, false otherwise
#########################
mediawiki_sql_execute() {
    local -a args=(
        "$MEDIAWIKI_DATABASE_HOST"
        "$MEDIAWIKI_DATABASE_PORT_NUMBER"
        "$MEDIAWIKI_DATABASE_NAME"
        "$MEDIAWIKI_DATABASE_USER"
        "$MEDIAWIKI_DATABASE_PASSWORD"
    )
    mysql_remote_execute "${args[@]}"
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
mediawiki_wait_for_db_connection() {
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
# Configure MediaWiki SMTP credentials
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
mediawiki_configure_smtp() {
    is_empty_value "$MEDIAWIKI_SMTP_HOST" && return
    info "Setting SMTP credentials"
    cat >>"$MEDIAWIKI_CONF_FILE" <<EOF
\$wgSMTP = array(
'host' => '${MEDIAWIKI_SMTP_HOST}',
'IDHost' => '${MEDIAWIKI_SMTP_HOST_ID}',
'port' => ${MEDIAWIKI_SMTP_PORT_NUMBER},
'username' => '${MEDIAWIKI_SMTP_USER}',
'password' => '${MEDIAWIKI_SMTP_PASSWORD}',
'auth' => true
);
EOF
}

########################
# Configure MediaWiki short URLs
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
mediawiki_configure_short_urls() {
    info "Setting MediaWiki short URLs"
    mediawiki_conf_set "\$wgScriptPath" ""
    cat >>"$MEDIAWIKI_CONF_FILE" <<EOF
\$wgArticlePath = "$MEDIAWIKI_WIKI_PREFIX/\$1";
\$wgUsePathInfo = true;
EOF
}

#########################
# Configure Mediawiki host
# Globals:
#   MEDIAWIKI_*
# Arguments:
#   None
# Returns:
#   None
#########################
mediawiki_configure_host() {
    local host="${1:?missing host}"
    local url

    if is_boolean_yes "$MEDIAWIKI_ENABLE_HTTPS"; then
        url="https://${host}"
        [[ "$MEDIAWIKI_EXTERNAL_HTTPS_PORT_NUMBER" != "443" ]] && url+=":${MEDIAWIKI_EXTERNAL_HTTPS_PORT_NUMBER}"
    else
        if [[ "$MEDIAWIKI_EXTERNAL_HTTP_PORT_NUMBER" != "80" || "$MEDIAWIKI_EXTERNAL_HTTPS_PORT_NUMBER" != "443" ]]; then
            url="http://${host}"
            [[ "$MEDIAWIKI_EXTERNAL_HTTP_PORT_NUMBER" != "80" ]] && url+=":${MEDIAWIKI_EXTERNAL_HTTP_PORT_NUMBER}"
        else
            # If using default values, support both HTTP and HTTPS at the same time
            url="//${host}"
        fi
    fi
    mediawiki_conf_set "\$wgServer" "$url"

}
