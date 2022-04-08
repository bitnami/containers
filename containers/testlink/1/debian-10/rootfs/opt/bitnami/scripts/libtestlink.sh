#!/bin/bash
#
# Bitnami TestLink library

# shellcheck disable=SC1091

# Load generic libraries
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
# Validate settings in TESTLINK_* env vars
# Globals:
#   TESTLINK_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
testlink_validate() {
    debug "Validating settings in TESTLINK_* environment variables..."
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
    check_resolved_hostname() {
        if ! is_hostname_resolved "$1"; then
            warn "Hostname $1 could not be resolved. This could lead to connection issues"
        fi
    }
    check_valid_port() {
        local port_var="${1:?missing port variable}"
        local err
        if ! err="$(validate_port "${!port_var}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    # Warn users in case the configuration files are not writable
    is_file_writable "$TESTLINK_CUSTOM_CONF_FILE" || warn "The TestLink custom configuration file '${TESTLINK_CUSTOM_CONF_FILE}' is not writable. Configurations based on environment variables will not be applied for this file."
    is_file_writable "$TESTLINK_DATABASE_CONF_FILE" || warn "The TestLink database configuration file '${TESTLINK_DATABASE_CONF_FILE}' is not writable. Configurations based on environment variables will not be applied for this file."

    # Validate user inputs
    ! is_empty_value "$TESTLINK_SKIP_BOOTSTRAP" && check_yes_no_value "TESTLINK_SKIP_BOOTSTRAP"
    ! is_empty_value "$TESTLINK_DATABASE_PORT_NUMBER" && check_valid_port "TESTLINK_DATABASE_PORT_NUMBER"
    ! is_empty_value "$TESTLINK_DATABASE_HOST" && check_resolved_hostname "$TESTLINK_DATABASE_HOST"

    # Validate credentials
    if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    else
        for empty_env_var in "TESTLINK_DATABASE_PASSWORD" "TESTLINK_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        done
    fi

    # Validate SMTP credentials
    if ! is_empty_value "$TESTLINK_SMTP_HOST"; then
        for empty_env_var in "TESTLINK_SMTP_USER" "TESTLINK_SMTP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && warn "The ${empty_env_var} environment variable is empty or not set."
        done
        is_empty_value "TESTLINK_SMTP_PORT_NUMBER" && print_validation_error "The TESTLINK_SMTP_PORT_NUMBER environment variable is empty or not set."
        ! is_empty_value "$TESTLINK_SMTP_PORT_NUMBER" && check_valid_port "TESTLINK_SMTP_PORT_NUMBER"
        ! is_empty_value "$TESTLINK_SMTP_PROTOCOL" && check_multi_value "TESTLINK_SMTP_PROTOCOL" "ssl tls"
    fi

    # Check that the web server is properly set up
    web_server_validate || print_validation_error "Web server validation failed"

    return "$error_code"
}

########################
# Ensure TestLink is initialized
# Globals:
#   TESTLINK_*
# Arguments:
#   None
# Returns:
#   None
#########################
testlink_initialize() {
    # Update TestLink configuration via mounted configuration files and environment variables
    if is_file_writable "$TESTLINK_CUSTOM_CONF_FILE" && is_file_writable "$TESTLINK_DATABASE_CONF_FILE"; then
        # Enable mounted configuration files
        if [[ -f "$TESTLINK_MOUNTED_CUSTOM_CONF_FILE" ]]; then
            info "Found mounted TestLink configuration file '${TESTLINK_MOUNTED_CUSTOM_CONF_FILE}', copying to '${TESTLINK_CUSTOM_CONF_FILE}'"
            cp "$TESTLINK_MOUNTED_CUSTOM_CONF_FILE" "$TESTLINK_CUSTOM_CONF_FILE"
        fi
        if [[ -f "$TESTLINK_MOUNTED_DATABASE_CONF_FILE" ]]; then
            info "Found mounted TestLink configuration file '${TESTLINK_MOUNTED_DATABASE_CONF_FILE}', copying to '${TESTLINK_DATABASE_CONF_FILE}'"
            cp "$TESTLINK_MOUNTED_DATABASE_CONF_FILE" "$TESTLINK_DATABASE_CONF_FILE"
        fi

        # Configure TestLink based on environment variables
        info "Configuring TestLink with settings provided via environment variables"
        testlink_custom_conf_set "\$tlCfg->default_language" "$TESTLINK_LANGUAGE"
        # SMTP settings
        if ! is_empty_value "$TESTLINK_SMTP_HOST"; then
            info "Configuring SMTP"
            testlink_custom_conf_set "\$g_tl_admin_email" "$TESTLINK_EMAIL"
            testlink_custom_conf_set "\$g_from_email" "$TESTLINK_EMAIL"
            testlink_custom_conf_set "\$g_return_path_email" "$TESTLINK_EMAIL"
            testlink_custom_conf_set "\$g_smtp_host" "$TESTLINK_SMTP_HOST"
            testlink_custom_conf_set "\$g_smtp_port" "$TESTLINK_SMTP_PORT_NUMBER"
            ! is_empty_value "$TESTLINK_SMTP_PROTOCOL" && testlink_custom_conf_set "\$g_smtp_connection_mode" "$TESTLINK_SMTP_PROTOCOL"
            ! is_empty_value "$TESTLINK_SMTP_USER" && testlink_custom_conf_set "\$g_smtp_username" "$TESTLINK_SMTP_USER"
            ! is_empty_value "$TESTLINK_SMTP_PASSWORD" && testlink_custom_conf_set "\$g_smtp_password" "$TESTLINK_SMTP_PASSWORD"
        fi
        # Configure database credentials based on user inputs
        testlink_database_conf_set "DB_HOST" "${TESTLINK_DATABASE_HOST}:${TESTLINK_DATABASE_PORT_NUMBER}"
        testlink_database_conf_set "DB_NAME" "$TESTLINK_DATABASE_NAME"
        testlink_database_conf_set "DB_USER" "$TESTLINK_DATABASE_USER"
        testlink_database_conf_set "DB_PASS" "$TESTLINK_DATABASE_PASSWORD"
    fi

    # Check if TestLink has already been initialized and persisted in a previous run
    local db_host db_port db_name db_user db_pass
    local -r app_name="testlink"
    if ! is_app_initialized "$app_name"; then
        # Ensure TestLink persisted directories exist (i.e. when a volume has been mounted to /bitnami)
        info "Ensuring TestLink directories exist"
        ensure_dir_exists "$TESTLINK_VOLUME_DIR"
        # Use daemon:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$TESTLINK_VOLUME_DIR" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
        info "Trying to connect to the database server"
        db_host="$TESTLINK_DATABASE_HOST"
        db_port="$TESTLINK_DATABASE_PORT_NUMBER"
        db_name="$TESTLINK_DATABASE_NAME"
        db_user="$TESTLINK_DATABASE_USER"
        db_pass="$TESTLINK_DATABASE_PASSWORD"
        local -a mysql_execute_args=("$db_host" "$db_port" "$db_name" "$db_user" "$db_pass")
        testlink_wait_for_db_connection "${mysql_execute_args[@]}"

        if ! is_boolean_yes "$TESTLINK_SKIP_BOOTSTRAP"; then
            replace_in_file "${TESTLINK_BASE_DIR}/install/sql/mysql/testlink_create_udf0.sql" "YOUR_TL_DBNAME" "$db_name"
            local -a mysql_source_files=(
                "${TESTLINK_BASE_DIR}/install/sql/mysql/testlink_create_tables.sql"
                "${TESTLINK_BASE_DIR}/install/sql/mysql/testlink_create_default_data.sql"
                "${TESTLINK_BASE_DIR}/install/sql/mysql/testlink_create_udf0.sql"
            )
            # Using source to avoid generating too much output
            for mysql_source_file in "${mysql_source_files[@]}"; do
                mysql_remote_execute "${mysql_execute_args[@]}" <<< "SOURCE ${mysql_source_file}"
            done
            # Update database with provided values
            mysql_remote_execute "${mysql_execute_args[@]}" <<< "UPDATE users SET
                login='${TESTLINK_USERNAME}',
                password=MD5('${TESTLINK_PASSWORD}'),
                email='${TESTLINK_EMAIL}', first='${TESTLINK_USERNAME}',
                locale='${TESTLINK_LANGUAGE}',
                cookie_string=CONCAT(MD5(RAND()),MD5('${TESTLINK_PASSWORD}'))
                WHERE login='admin'"
        else
            info "An already initialized TestLink database was provided, configuration will be skipped"
            testlink_update_database_schema "${mysql_execute_args[@]}"
        fi

        info "Persisting TestLink installation"
        persist_app "$app_name" "$TESTLINK_DATA_TO_PERSIST"
    else
        info "Restoring persisted TestLink installation"
        restore_persisted_app "$app_name" "$TESTLINK_DATA_TO_PERSIST"
        info "Trying to connect to the database server"
        read -r -a db_host_port <<< "$(tr ':' ' ' <<< "$(testlink_database_conf_get "DB_HOST")")"
        db_host="${db_host_port[0]}"
        db_port="${db_host_port[1]:-$PHPLIST_DATABASE_PORT_NUMBER}"
        db_name="$(testlink_database_conf_get "DB_NAME")"
        db_user="$(testlink_database_conf_get "DB_USER")"
        db_pass="$(testlink_database_conf_get "DB_PASS")"
        local -a mysql_execute_args=("$db_host" "$db_port" "$db_name" "$db_user" "$db_pass")
        testlink_wait_for_db_connection "${mysql_execute_args[@]}"
        testlink_update_database_schema "${mysql_execute_args[@]}"
    fi

    # The install subdir will be kept when manual upgrade is needed
    if [[ "$(testlink_get_app_version)" == "$(testlink_get_db_version "${mysql_execute_args[@]}")" ]]; then
        debug "Removing install subdir"
        rm -rf "${TESTLINK_BASE_DIR}/install"
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Add or modify an entry in the TestLink custom configuration file (custom_config.inc.php)
# Globals:
#   TESTLINK_*
# Arguments:
#   $1 - PHP variable name
#   $2 - Value to assign to the PHP variable
#   $3 - Whether the value is a literal, or if instead it should be quoted (default: no)
# Returns:
#   None
#########################
testlink_custom_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:-}"
    local -r is_literal="${3:-no}"
    debug "Setting ${key} to '${value}' in TestLink custom configuration file (literal: ${is_literal})"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(//\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")\s*=.*"
    local entry
    is_boolean_yes "$is_literal" && entry="${key} = $value;" || entry="${key} = '$value';"
    # Check if the configuration exists in the file
    if grep -q -E "$sanitized_pattern" "$TESTLINK_CUSTOM_CONF_FILE"; then
        # It exists, so replace the line
        replace_in_file "$TESTLINK_CUSTOM_CONF_FILE" "$sanitized_pattern" "$entry"
    else
        echo "$entry" >> "$TESTLINK_CUSTOM_CONF_FILE"
    fi
}

########################
# Add or modify an entry in the TestLink database configuration file (config_db.inc.php)
# Globals:
#   TESTLINK_*
# Arguments:
#   $1 - PHP variable name
#   $2 - Value to assign to the PHP variable
#   $3 - Whether the value is a literal, or if instead it should be quoted (default: no)
# Returns:
#   None
#########################
testlink_database_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:-}"
    local -r is_literal="${3:-no}"
    debug "Setting ${key} to '${value}' in TestLink database configuration file (literal: ${is_literal})"
    local pattern entry
    pattern="^\s*(//\s*)?define\([\"']${key}[\"'],.*"
    is_boolean_yes "$is_literal" && entry="define('${key}', ${value});" || entry="define('${key}', '${value}');"
    # Check if the configuration exists in the file
    if grep -q -E "$pattern" "$TESTLINK_DATABASE_CONF_FILE"; then
        # It exists, so replace the line
        replace_in_file "$TESTLINK_DATABASE_CONF_FILE" "$pattern" "$entry"
    else
        echo "$entry" >> "$TESTLINK_DATABASE_CONF_FILE"
    fi
}


########################
# Get an PHP define entry from a file
# Globals:
#   TESTLINK_*
# Arguments:
#   $1 - file
#   $2 - PHP variable name
# Returns:
#   None
#########################
testlink_conf_get_define() {
    local -r file="${1:?file missing}"
    local -r key="${2:?key missing}"
    debug "Getting ${key} from ${file}"
    local pattern
    pattern="^\s*(//\s*)?define\([\"']${key}[\"'],\s?(.*)\);"
    debug "$pattern"
    grep -E "$pattern" "$file" | sed -E "s|${pattern}|\2|" | tr -d "\"' "
}

########################
# Get an entry from the TestLink database configuration file (config_db.inc.php)
# Globals:
#   TESTLINK_*
# Arguments:
#   $1 - PHP variable name
# Returns:
#   None
#########################
testlink_database_conf_get() {
    local -r key="${1:?key missing}"
    testlink_conf_get_define "$TESTLINK_DATABASE_CONF_FILE" "$key"
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
testlink_wait_for_db_connection() {
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
# Get TestLink application version
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   String with TestLink application version
#########################
testlink_get_app_version() {
    testlink_conf_get_define "${TESTLINK_BASE_DIR}/cfg/const.inc.php" "TL_VERSION_NUMBER"
}

########################
# Get TestLink database version
# Globals:
#   *
# Arguments:
#   $1 - database host
#   $2 - database port
#   $3 - database name
#   $4 - database username
#   $5 - database user password (optional)
# Returns:
#   String with TestLink database version
#########################
testlink_get_db_version() {
    local -r db_host="${1:?missing database host}"
    local -r db_port="${2:?missing database port}"
    local -r db_name="${3:?missing database name}"
    local -r db_user="${4:?missing database user}"
    local -r db_pass="${5:-}"

    # Database version is stored as "DB <version>"
    local -r query="SELECT REPLACE(version, 'DB ', '') FROM db_version ORDER BY upgrade_ts DESC LIMIT 1"
    mysql_execute_print_output "$db_name" "$db_user" "$db_pass" "-h ${db_host} -P ${db_port}" <<< "$query"
}

########################
# TestLink update database schema
# Globals:
#   *
# Arguments:
#   $1 - database host
#   $2 - database port
#   $3 - database name
#   $4 - database username
#   $5 - database user password (optional)
# Returns:
#   None
#########################
testlink_update_database_schema() {
    local -r db_host="${1:?missing database host}"
    local -r db_port="${2:?missing database port}"
    local -r db_name="${3:?missing database name}"
    local -r db_user="${4:?missing database user}"
    local -r db_pass="${5:-}"

    local -r base_migration_dir="${TESTLINK_BASE_DIR}/install/sql/alter_tables"
    local app_version db_version
    local -a applicable_sql_files=()

    app_version="$(testlink_get_app_version)"
    db_version="$(testlink_get_db_version "$@")"

    if testlink_compare_versions "$app_version" "$db_version" "gt"; then
        info "New TestLink version detected"

        # The following loops will look for the SQL files under install/sql/alter_tables that need
        # to be executed to perform a schema upgrade between two versions of the database. Files
        # are executed in order.
        local app_version_major app_version_minor db_version_major db_version_minor
        app_version_major="$(get_sematic_version "$app_version" 1)"
        app_version_minor="$(get_sematic_version "$app_version" 2)"
        db_version_major="$(get_sematic_version "$db_version" 1)"
        db_version_minor="$(get_sematic_version "$db_version" 2)"
        if [[ "$app_version_major" == "$db_version_major" ]] && [[ "$app_version_minor" == "$db_version_minor" ]]; then
            info "Patch version detected, starting upgrade process"
            read -r -a migration_dirs <<< "$(find "$base_migration_dir" -mindepth 1 -maxdepth 1 -type d -printf '%f\0' | sort -z --version-sort | xargs -0)"
            for dir in "${migration_dirs[@]}"; do
                if testlink_compare_versions "$dir" "$db_version" "gt"; then
                    read -r -a applicable_sql_files <<< "$(find "${base_migration_dir}/${dir}/mysql" -type f -name '[!.]*.sql' -printf '%p\0' | sort -z | xargs -0)"
                    for sql_file in "${applicable_sql_files[@]}"; do
                        # Using source to avoid generating too much output
                        echo "SOURCE ${sql_file}" | mysql_remote_execute "${mysql_execute_args[@]}"
                    done
                fi
            done
        else
            warn "Major versions upgrade detected. Please upgrade the application manually"
        fi
    fi
}

########################
# Helper function to compare versions
# Globals:
#   *
# Arguments:
#   $1 - version 1
#   $2 - version 2
#   $3 - operator
# Returns:
#   true if the operator relationship is correct
#########################
testlink_compare_versions() {
    local -r v1="${1:?missing version 1}"
    local -r v2="${2:?missing version 2}"
    local -r operator="${3:?missing operator}"

    ! is_empty_value "$(php_execute_print_output <<< "echo version_compare('${v1}', '${v2}', '${operator}');")"
}
