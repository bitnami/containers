#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Moodle library

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

if [[ -f /opt/bitnami/scripts/libpostgresqlclient.sh ]]; then
    . /opt/bitnami/scripts/libpostgresqlclient.sh
elif [[ -f /opt/bitnami/scripts/libpostgresql.sh ]]; then
    . /opt/bitnami/scripts/libpostgresql.sh
fi

########################
# Validate settings in MOODLE_* env vars
# Globals:
#   MOODLE_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
moodle_validate() {
    debug "Validating settings in MOODLE_* environment variables..."
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
        for empty_env_var in "MOODLE_DATABASE_PASSWORD" "MOODLE_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        done
    fi

    # Validate SMTP credentials
    if ! is_empty_value "$MOODLE_SMTP_HOST"; then
        for empty_env_var in "MOODLE_SMTP_USER" "MOODLE_SMTP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && warn "The ${empty_env_var} environment variable is empty or not set."
        done
        is_empty_value "$MOODLE_SMTP_PORT_NUMBER" && print_validation_error "The MOODLE_SMTP_PORT_NUMBER environment variable is empty or not set."
        ! is_empty_value "$MOODLE_SMTP_PORT_NUMBER" && check_valid_port "MOODLE_SMTP_PORT_NUMBER"
    fi

    # Compatibility with older images where 'moodledata' was located inside the 'htdocs' directory
    if is_mounted_dir_empty "$MOODLE_DATA_DIR" && [[ -d "${MOODLE_VOLUME_DIR}/moodledata" ]]; then
        warn "Found 'moodledata' directory inside ${MOODLE_VOLUME_DIR}. Support for this configuration is deprecated and will be removed soon. Please create a new volume mountpoint at ${MOODLE_DATA_DIR}, and copy all its files there."
    fi

    # Support for MySQL and MariaDB
    check_multi_value "MOODLE_DATABASE_TYPE" "mysqli mariadb pgsql auroramysql"

    # Check that the web server is properly set up
    web_server_validate || print_validation_error "Web server validation failed"

    # Check yes/no env. variables
    check_yes_no_value "MOODLE_REVERSEPROXY"
    check_yes_no_value "MOODLE_SSLPROXY"

    return "$error_code"
}

########################
# Bypass Azure for ManagedDB database version check
# We detected some issues in the way that Azure Database for MariaDB
# shows the version. This hack will bypass the Moodle installation check
# Globals:
#   MOODLE_*
# Arguments:
#   None
# Returns:
#   None
#########################
moodle_fix_manageddb_check() {
    info "Changing minimum required MariaDB version to $MOODLE_DATABASE_MIN_VERSION"
    replace_in_file "$MOODLE_BASE_DIR/admin/environment.xml" "name=\"mariadb\" version=\"[^\"]+\"" "name=\"mariadb\" version=\"$MOODLE_DATABASE_MIN_VERSION\""
    replace_in_file "$MOODLE_BASE_DIR/admin/environment.xml" "name=\"mysql\" version=\"[^\"]+\"" "name=\"mysql\" version=\"$MOODLE_DATABASE_MIN_VERSION\""
}

########################
# Ensure Moodle is initialized
# Globals:
#   MOODLE_*
# Arguments:
#   None
# Returns:
#   None
#########################
moodle_initialize() {
    # Check if Moodle has already been initialized and persisted in a previous run
    local db_type db_host db_port db_name db_user db_pass
    local -r app_name="moodle"
    if ! is_app_initialized "$app_name"; then
        # Ensure Moodle persisted directories exist (i.e. when a volume has been mounted to /bitnami)
        info "Ensuring Moodle directories exist"
        for dir in "$MOODLE_VOLUME_DIR" "$MOODLE_DATA_DIR"; do
            ensure_dir_exists "$dir"
            # Use daemon:root ownership for compatibility when running as a non-root user
            am_i_root && configure_permissions_ownership "$dir" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
        done

        info "Trying to connect to the database server"
        db_type="$MOODLE_DATABASE_TYPE"
        db_host="$MOODLE_DATABASE_HOST"
        db_port="$MOODLE_DATABASE_PORT_NUMBER"
        db_name="$MOODLE_DATABASE_NAME"
        db_user="$MOODLE_DATABASE_USER"
        db_pass="$MOODLE_DATABASE_PASSWORD"
        [[ "$db_type" = "mariadb" || "$db_type" = "mysqli" || "$db_type" = "auroramysql" ]] && moodle_wait_for_mysql_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
        [[ "$db_type" = "pgsql" ]] && moodle_wait_for_postgresql_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"

        # Create Moodle install argument list, allowing to pass custom options via 'MOODLE_INSTALL_EXTRA_ARGS'
        local -a moodle_install_args=("--dbtype=${db_type}" "--dbhost=${db_host}" "--dbport=${db_port}" "--dbname=${db_name}" "--dbuser=${db_user}" "--dbpass=${db_pass}")
        local -a extra_args
        read -r -a extra_args <<<"$MOODLE_INSTALL_EXTRA_ARGS"
        [[ "${#extra_args[@]}" -gt 0 ]] && moodle_install_args+=("${extra_args[@]}")

        # Handle --prefix (table prefix) being overridden via MOODLE_INSTALL_EXTRA_ARGS
        mdl_prefix="mdl_"
        for extra_arg in "${extra_args[@]}"; do
            if [[ $extra_arg == --prefix=* ]]; then
                mdl_prefix=${extra_arg#--prefix=}
                break
            fi
        done
        # Setup Moodle
        if ! is_boolean_yes "$MOODLE_SKIP_BOOTSTRAP"; then
            info "Running Moodle install script"
            # Create the configuration file and populate the database
            moodle_install "${moodle_install_args[@]}"
            # Configure additional settings in the database according to user inputs
            local db_remote_execute="mysql_remote_execute"
            [[ "$db_type" = "pgsql" ]] && db_remote_execute="postgresql_remote_execute"
            local -a db_execute_args=("$db_host" "$db_port" "$db_name" "$db_user" "$db_pass")
            # Configure no-reply e-mail address for SMTP
	    echo "INSERT INTO ${mdl_prefix}config (name, value) VALUES ('noreplyaddress', '${MOODLE_EMAIL}')" | "$db_remote_execute" "${db_execute_args[@]}"
            # Additional Bitnami customizations
            echo "UPDATE ${mdl_prefix}course SET summary='Moodle powered by Bitnami' WHERE id='1'" | "$db_remote_execute" "${db_execute_args[@]}"
            # SMTP configuration
            if ! is_empty_value "$MOODLE_SMTP_HOST"; then
                info "Configuring SMTP credentials"
                "$db_remote_execute" "${db_execute_args[@]}" <<EOF
UPDATE ${mdl_prefix}config SET value='${MOODLE_SMTP_HOST}:${MOODLE_SMTP_PORT_NUMBER}' WHERE name='smtphosts';
UPDATE ${mdl_prefix}config SET value='${MOODLE_SMTP_USER}' WHERE name='smtpuser';
UPDATE ${mdl_prefix}config SET value='${MOODLE_SMTP_PASSWORD}' WHERE name='smtppass';
UPDATE ${mdl_prefix}config SET value='${MOODLE_SMTP_PROTOCOL}' WHERE name='smtpsecure';
EOF
            fi
        else
            info "An already initialized Moodle database was provided, it will not be re-initialized"
            # Create the configuration file
            info "Creating Moodle configuration file"
            moodle_install "${moodle_install_args[@]}" --skip-database
            # Perform Moodle database schema upgrade
            info "Running database upgrade"
            moodle_upgrade
        fi
        # Change wwwroot configuration so the Moodle site can be accessible from anywhere
        moodle_configure_wwwroot
        # Turn on Moodle's reverseproxy (also sslproxy if using ssl) so we can use the reverse proxy
        moodle_configure_reverseproxy

        info "Persisting Moodle installation"
        persist_app "$app_name" "$MOODLE_DATA_TO_PERSIST"
    else
        info "Restoring persisted Moodle installation"
        restore_persisted_app "$app_name" "$MOODLE_DATA_TO_PERSIST"

        info "Trying to connect to the database server"
        db_type="$(moodle_conf_get "\$CFG->dbtype")"
        db_host="$(moodle_conf_get "\$CFG->dbhost")"
        db_port="$(moodle_conf_get "'dbport'")"
        db_name="$(moodle_conf_get "\$CFG->dbname")"
        db_user="$(moodle_conf_get "\$CFG->dbuser")"
        db_pass="$(moodle_conf_get "\$CFG->dbpass")"
        [[ "$db_type" = "mariadb" || "$db_type" = "mysqli" || "$db_type" = "auroramysql" ]] && moodle_wait_for_mysql_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
        [[ "$db_type" = "pgsql" ]] && moodle_wait_for_postgresql_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"

        # Perform Moodle database schema upgrade
        info "Running database upgrade"
        moodle_upgrade

        # Skip the following check for legacy installs where moodledata is in /bitnami/moodle/moodledata and not /bitnami/moodledata (#142)
        if ! is_dir_empty "${MOODLE_DATA_DIR}/sessions"; then
            # This fixes an issue when restoring Moodle, due to cookies/sessions from a previous run being considered closed.
            # Therefore, users are unable to connect to Moodle with their cookies since the server considers them invalid.
            # The problem disappears when removing the old (invalid) session files.
            find "${MOODLE_DATA_DIR}/sessions/" -name "sess_*" -delete
        fi
    fi

    # Ensure Moodle cron jobs are created when running setup with a root user
    local -a cron_cmd=("${PHP_BIN_DIR}/php" "${MOODLE_BASE_DIR}/admin/cli/cron.php")
    if am_i_root; then
        generate_cron_conf "moodle" "${cron_cmd[*]} > /dev/null 2>> ${MOODLE_DATA_DIR}/moodle-cron.log" --run-as "$WEB_SERVER_DAEMON_USER" --schedule "*/${MOODLE_CRON_MINUTES} * * * *"
    else
        warn "Skipping cron configuration for Moodle because of running as a non-root user"
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Get an entry from the Moodle configuration file (config.php)
# Globals:
#   MOODLE_*
# Arguments:
#   $1 - PHP variable name
# Returns:
#   None
#########################
moodle_conf_get() {
    local -r key="${1:?key missing}"
    debug "Getting ${key} from Moodle configuration"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="^\s*(//\s*)?$(sed 's/[]\[^$.*/]/\\&/g' <<<"$key")\s*=>?([^;,]+)[;,]"
    grep -E "$sanitized_pattern" "$MOODLE_CONF_FILE" | sed -E "s|${sanitized_pattern}|\2|" | tr -d "\"' "
}

########################
# Wait until a MySQL or MariaDB database is accessible with the currently-known credentials
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
moodle_wait_for_mysql_connection() {
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
# Wait until a PostgreSQL database is accessible with the currently-known credentials
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
moodle_wait_for_postgresql_connection() {
    local -r db_host="${1:?missing database host}"
    local -r db_port="${2:?missing database port}"
    local -r db_name="${3:?missing database name}"
    local -r db_user="${4:?missing database user}"
    local -r db_pass="${5:-}"
    check_postgresql_connection() {
        echo "SELECT 1" | postgresql_remote_execute "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
    }
    if ! retry_while "check_postgresql_connection"; then
        error "Could not connect to the database"
        return 1
    fi
}

########################
# Run Moodle install script
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   true if the script succeeded, false otherwise
#########################
moodle_install() {
    local -r http_port="${WEB_SERVER_HTTP_PORT_NUMBER:-"$WEB_SERVER_DEFAULT_HTTP_PORT_NUMBER"}"
    local -a moodle_install_args=(
        "${PHP_BIN_DIR}/php"
        "admin/cli/install.php"
        "--lang=${MOODLE_LANG}"
        "--chmod=2775"
        "--wwwroot=http://localhost:${http_port}"
        "--dataroot=${MOODLE_DATA_DIR}"
        "--adminuser=${MOODLE_USERNAME}"
        "--adminpass=${MOODLE_PASSWORD}"
        "--adminemail=${MOODLE_EMAIL}"
        "--fullname=${MOODLE_SITE_NAME}"
        "--shortname=${MOODLE_SITE_NAME}"
        "--non-interactive"
        "--allow-unstable"
        "--agree-license"
        "$@"
    )
    # HACK: Change database version check for Azure Database for MariaDB
    ! is_empty_value "$MOODLE_DATABASE_MIN_VERSION" && moodle_fix_manageddb_check
    pushd "$MOODLE_BASE_DIR" >/dev/null || exit
    # Run as web server user to avoid having to change permissions/ownership afterwards
    if am_i_root; then
        debug_execute run_as_user "$WEB_SERVER_DAEMON_USER" "${moodle_install_args[@]}"
        # Remove write permissions for the web server to the config.php file
        configure_permissions_ownership "$MOODLE_CONF_FILE" -f "644" -u "root" -g "$WEB_SERVER_DAEMON_GROUP"
    else
        debug_execute "${moodle_install_args[@]}"
    fi
    popd >/dev/null || exit
}

########################
# Run Moodle database schema upgrade script
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   true if the script succeeded, false otherwise
#########################
moodle_upgrade() {
    pushd "$MOODLE_BASE_DIR" >/dev/null || exit
    local -a moodle_upgrade_args=(
        "${PHP_BIN_DIR}/php"
        "admin/cli/upgrade.php"
        "--non-interactive"
        "--allow-unstable"
    )
    am_i_root && moodle_upgrade_args=("run_as_user" "$WEB_SERVER_DAEMON_USER" "${moodle_upgrade_args[@]}")
    debug_execute "${moodle_upgrade_args[@]}"
    popd >/dev/null || exit
}

########################
# Configure Moodle www root
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
moodle_configure_wwwroot() {
    local -r http_port="${WEB_SERVER_HTTP_PORT_NUMBER:-"$WEB_SERVER_DEFAULT_HTTP_PORT_NUMBER"}"
    # Sanitize the hostname including quotes
    local host="${MOODLE_HOST:+"'${MOODLE_HOST}'"}"
    # Default value if the hostname isn't provided
    host="${host:-"\$_SERVER['HTTP_HOST']"}"
    # sed replacement notes:
    # - The ampersand ('&') is escaped due to sed replacing any non-escaped ampersand characters with the matched string
    # - For the replacement text to be multi-line, an \ needs to be specified to escape the newline character
    local conf_to_replace="if (empty(\$_SERVER['HTTP_HOST'])) {\\
  \$_SERVER['HTTP_HOST'] = '127.0.0.1:${http_port}';\\
}"
    if is_boolean_yes "$MOODLE_SSLPROXY"; then
        conf_to_replace="$conf_to_replace\\
\$CFG->wwwroot   = 'https://' . ${host};"
    else
        conf_to_replace="$conf_to_replace\\
if (isset(\$_SERVER['HTTPS']) \&\& \$_SERVER['HTTPS'] == 'on') {\\
  \$CFG->wwwroot   = 'https://' . ${host};\\
} else {\\
  \$CFG->wwwroot   = 'http://' . ${host};\\
}"
    fi
    replace_in_file "$MOODLE_CONF_FILE" "\\\$CFG->wwwroot\s*=.*" "$conf_to_replace"
}

########################
# Configure Moodle reverse proxy
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   None
#########################
moodle_configure_reverseproxy() {
    # Checking the reverseproxy setting values
    is_boolean_yes "$MOODLE_REVERSEPROXY" && sed -i "/^require/i \$CFG->reverseproxy = true;" "$MOODLE_CONF_FILE"
    # Checking the sslproxy setting values
    is_boolean_yes "$MOODLE_SSLPROXY" && sed -i "/^require/i \$CFG->sslproxy = true;" "$MOODLE_CONF_FILE"

    true
}
