#!/bin/bash
#
# Bitnami Joomla! library

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
# Validate settings in JOOMLA_* env vars
# Globals:
#   JOOMLA_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
joomla_validate() {
    debug "Validating settings in JOOMLA_* environment variables..."
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
        for empty_env_var in "JOOMLA_DATABASE_PASSWORD" "JOOMLA_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        done
    fi

    # Validate SMTP credentials
    if ! is_empty_value "$JOOMLA_SMTP_HOST"; then
        for empty_env_var in "JOOMLA_SMTP_USER" "JOOMLA_SMTP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && warn "The ${empty_env_var} environment variable is empty or not set."
        done
        is_empty_value "$JOOMLA_SMTP_PORT_NUMBER" && print_validation_error "The JOOMLA_SMTP_PORT_NUMBER environment variable is empty or not set."
        ! is_empty_value "$JOOMLA_SMTP_PORT_NUMBER" && check_valid_port "JOOMLA_SMTP_PORT_NUMBER"
        ! is_empty_value "$JOOMLA_SMTP_PROTOCOL" && check_multi_value "JOOMLA_SMTP_PROTOCOL" "ssl tls"
    fi

    # Check that the web server is properly set up
    web_server_validate || print_validation_error "Web server validation failed"

    return "$error_code"
}

########################
# Get Joomla! version
# Globals:
#   JOOMLA_*
# Arguments:
#   None
# Returns:
#   String with Joomla version
#########################
joomla_get_version() {
    grep -Eo "[0-9]+[.][0-9]+[.][0-9]+" "${JOOMLA_BASE_DIR}/administrator/manifests/files/joomla.xml"
}

########################
# Get Joomla! version
# Globals:
#   JOOMLA_*
# Arguments:
#   None
# Returns:
#   String with Joomla version
#########################
joomla_get_version_schema() {
    local -r migrations_dir=/opt/bitnami/joomla/administrator/components/com_admin/sql/updates/mysql
    # Sort by date (specified in the filename), since files are named following the 'version-date.sql' pattern
    # Regular sort does not work because the versions have different digits, example: 3.9.3 > 3.9.19 using sort
    local -r regex=".*-([0-9]{4}-[0-9]{2}-[0-9]{2})\.sql"
    local -r latest_date="$(find "$migrations_dir" -regextype posix-extended -regex "$regex" | sed -E "s/${regex}/\1/" | sort | tail -n 1)"
    # Obtain the file associated with the date
    find "$migrations_dir" -name "*-${latest_date}.sql" -exec basename {} \+ | sed 's/\.sql//g'
}

########################
# Ensure Joomla! is initialized
# Globals:
#   JOOMLA_*
# Arguments:
#   None
# Returns:
#   None
#########################
joomla_initialize() {
    # Check if Joomla! has already been initialized and persisted in a previous run
    local db_host db_port db_name db_user db_pass
    local -r app_name="joomla"
    if ! is_app_initialized "$app_name"; then
        # Ensure the base directory exists and has proper permissions
        info "Configuring file permissions for Joomla!"
        ensure_dir_exists "$JOOMLA_VOLUME_DIR"
        # Use daemon:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$JOOMLA_VOLUME_DIR" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
        # Configure Joomla! based on environment variables
        info "Configuring Joomla! with settings provided via environment variables"
        ## Site name
        ! is_empty_value "$JOOMLA_SITE_NAME" && info "Setting site name" && joomla_conf_set "\$sitename" "$JOOMLA_SITE_NAME" && joomla_conf_set "\$fromname" "$JOOMLA_SITE_NAME"
        ## SMTP
        # Use JOOMLA_SMTP_HOST as a flag to know if SMTP should be enabled (the rest of parameters are check in the validation)
        if ! is_empty_value "$JOOMLA_SMTP_HOST"; then
            local smtp_auth_req=0
            ! is_empty_value "$JOOMLA_SMTP_USER" && smtp_auth_req=1

            info "Enabling SMTP" && joomla_conf_set  "\$mailer" "smtp"
            debug "Enabling SMTP authorization" && joomla_conf_set  "\$smtpauth" "$smtp_auth_req"
            debug "Setting SMTP host" && joomla_conf_set  "\$smtphost" "$JOOMLA_SMTP_HOST"
            ! is_empty_value "$JOOMLA_SMTP_USER" && debug "Setting SMTP user" && joomla_conf_set  "\$smtpuser" "$JOOMLA_SMTP_USER"
            ! is_empty_value "$JOOMLA_SMTP_PASSWORD" && debug "Setting SMTP password" && joomla_conf_set  "\$smtppass" "$JOOMLA_SMTP_PASSWORD"
            debug "Setting SMTP port" && joomla_conf_set  "\$smtpport" "$JOOMLA_SMTP_PORT"
            debug "Setting SMTP protocol" && joomla_conf_set  "\$smtpsecure" "$JOOMLA_SMTP_PROTOCOL"
            ! is_empty_value "$JOOMLA_SMTP_SENDER_EMAIL" && debug "Setting SMTP sender email" && joomla_conf_set  "\$mailfrom" "$JOOMLA_SMTP_SENDER_EMAIL"
            ! is_empty_value "$JOOMLA_SMTP_SENDER_NAME" && debug "Setting SMTP sender name" && joomla_conf_set  "\$fromname" "$JOOMLA_SMTP_SENDER_NAME"
        fi

        info "Setting database host" && joomla_conf_set "\$host" "${JOOMLA_DATABASE_HOST}:${JOOMLA_DATABASE_PORT_NUMBER}"
        info "Setting database name" && joomla_conf_set "\$db" "$JOOMLA_DATABASE_NAME"
        info "Setting database user" && joomla_conf_set "\$user" "$JOOMLA_DATABASE_USER"
        if ! is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
            info "Setting database password" && joomla_conf_set "\$password" "$JOOMLA_DATABASE_PASSWORD"
        fi
    local -r salt="${JOOMLA_SECRET:-$(generate_random_string -t alphanumeric -c 32)}"
        info "Setting salt" && joomla_conf_set "\$secret" "$salt"

        info "Trying to connect to the database server"
        db_host="$JOOMLA_DATABASE_HOST"
        db_port="$JOOMLA_DATABASE_PORT_NUMBER"
        db_name="$JOOMLA_DATABASE_NAME"
        db_user="$JOOMLA_DATABASE_USER"
        db_pass="$JOOMLA_DATABASE_PASSWORD"
        joomla_wait_for_db_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"

        if ! is_boolean_yes "$JOOMLA_SKIP_BOOTSTRAP"; then
            local -r version_id="$(joomla_get_version_schema)"
            local -r encrypted_password="$(generate_md5_hash "${JOOMLA_PASSWORD}${salt}")"
            info "Executing initialization SQL commands"
            # Using source to avoid generating too much output
            echo "SOURCE ${JOOMLA_BASE_DIR}/installation/sql/mysql/joomla.sql" | mysql_remote_execute "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
            echo "INSERT INTO jos_users(id, name, username, email, password, block, sendEmail, params) VALUES(42, 'Super User', '$JOOMLA_USERNAME', '$JOOMLA_EMAIL', '${encrypted_password}:${salt}', 0, 1, '')" | mysql_remote_execute "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
            echo "INSERT INTO jos_user_usergroup_map(user_id, group_id) VALUES(42, 8)" | mysql_remote_execute "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
            echo "DELETE FROM jos_utf8_conversion;" | mysql_remote_execute "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
            echo "INSERT INTO jos_utf8_conversion(converted) VALUES(2)" | mysql_remote_execute "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
            echo "INSERT INTO jos_schemas(extension_id, version_id) VALUES(700, '${version_id}')" | mysql_remote_execute "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
            echo "UPDATE jos_extensions SET manifest_cache='{\"version\": \"$(joomla_get_version)\"}' WHERE extension_id=700" | mysql_remote_execute "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
            if is_boolean_yes "$JOOMLA_LOAD_SAMPLE_DATA"; then
                info "Loading sample data"
                # Using source to avoid too much output
                echo "SOURCE ${JOOMLA_BASE_DIR}/installation/sql/mysql/sample_data.sql" | mysql_remote_execute "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
            fi
        else
            info "An already initialized Joomla! database was provided, configuration will be skipped"
        fi
        # Delete installation files for getting the version schema
        info "Deleting installation files"
        rm -rf "${JOOMLA_BASE_DIR}/installation"

        info "Persisting Joomla! installation"
        persist_app "$app_name" "$JOOMLA_DATA_TO_PERSIST"
    else
        info "Restoring persisted Joomla! installation"
        restore_persisted_app "$app_name" "$JOOMLA_DATA_TO_PERSIST"
        info "Trying to connect to the database server"
        db_host="$(joomla_conf_get "\$host" | awk -F: '{print $1}')"
        db_port="$(joomla_conf_get "\$host" | awk -F: '{print $2}')"
        db_name="$(joomla_conf_get "\$db")"
        db_user="$(joomla_conf_get "\$user")"
        db_pass="$(joomla_conf_get "\$password")"
        joomla_wait_for_db_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Add or modify an entry in the Joomla! configuration file (config.inc.php)
# Globals:
#   JOOMLA_*
# Arguments:
#   $1 - PHP variable name
#   $2 - Value to assign to the PHP variable
#   $3 - Whether the value is a literal, or if instead it should be quoted (default: no)
# Returns:
#   None
#########################
joomla_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:-}"
    local -r is_literal="${3:-no}"
    debug "Setting ${key} to '${value}' in Joomla! configuration (literal: ${is_literal})"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="public $(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")\s*=.*"
    local entry
    is_boolean_yes "$is_literal" && entry="${key} = $value;" || entry="public ${key} = '$value';"
    # Check if the configuration exists in the file
    if grep -q -E "$sanitized_pattern" "$JOOMLA_CONF_FILE"; then
        # It exists, so replace the line
        replace_in_file "$JOOMLA_CONF_FILE" "$sanitized_pattern" "$entry"
    else
        # The Joomla! configuration file includes all supported keys, but because of its format,
        # we cannot append contents to the end. We can assume thi
        warn "Could not set the Joomla! '${key}' configuration. Check that the file has not been modified externally."
    fi
}

########################
# Get an entry from the Joomla! configuration file (config.inc.php)
# Globals:
#   JOOMLA_*
# Arguments:
#   $1 - PHP variable name
# Returns:
#   None
#########################
joomla_conf_get() {
    local -r key="${1:?key missing}"
    debug "Getting ${key} from Joomla! configuration"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="public $(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")\s*=([^;/]+);.*$"
    debug "$sanitized_pattern"
    grep -E "$sanitized_pattern" "$JOOMLA_CONF_FILE" | sed -E "s|${sanitized_pattern}|\1|" | tr -d "\"\t' "
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
joomla_wait_for_db_connection() {
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
