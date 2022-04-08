#!/bin/bash
#
# Bitnami OrangeHRM library

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
# Validate settings in ORANGEHRM_* env vars
# Globals:
#   ORANGEHRM_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
orangehrm_validate() {
    debug "Validating settings in ORANGEHRM_* environment variables..."
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

    # Warn users in case the configuration file is not writable
    is_file_writable "$ORANGEHRM_CONF_FILE" || warn "The OrangeHRM configuration file '${ORANGEHRM_CONF_FILE}' is not writable. Some configurations might fail."
    is_file_writable "$ORANGEHRM_DATABASE_CONF_FILE" || warn "The OrangeHRM database configuration file '${ORANGEHRM_DATABASE_CONF_FILE}' is not writable. Some configuration might fail."

    # Validate user inputs
    ! is_empty_value "$ORANGEHRM_SKIP_BOOTSTRAP" && check_yes_no_value "ORANGEHRM_SKIP_BOOTSTRAP"
    ! is_empty_value "$ORANGEHRM_ENFORCE_PASSWORD_STRENGTH" && check_yes_no_value "ORANGEHRM_ENFORCE_PASSWORD_STRENGTH"
    ! is_empty_value "$ORANGEHRM_DATABASE_PORT_NUMBER" && check_valid_port "ORANGEHRM_DATABASE_PORT_NUMBER"
    ! is_empty_value "$ORANGEHRM_DATABASE_HOST" && check_resolved_hostname "$ORANGEHRM_DATABASE_HOST"

    # Validate credentials
    if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    else
        for empty_env_var in "ORANGEHRM_DATABASE_PASSWORD" "ORANGEHRM_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
        done
    fi

    # Validate SMTP credentials
    if ! is_empty_value "$ORANGEHRM_SMTP_HOST"; then
        for empty_env_var in "ORANGEHRM_SMTP_USER" "ORANGEHRM_SMTP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && warn "The ${empty_env_var} environment variable is empty or not set."
        done
        is_empty_value "$ORANGEHRM_SMTP_PORT_NUMBER" && print_validation_error "The ORANGEHRM_SMTP_PORT_NUMBER environment variable is empty or not set."
        ! is_empty_value "$ORANGEHRM_SMTP_PORT_NUMBER" && check_valid_port "ORANGEHRM_SMTP_PORT_NUMBER"
        ! is_empty_value "$ORANGEHRM_SMTP_PROTOCOL" && check_multi_value "ORANGEHRM_SMTP_PROTOCOL" "ssl none"
    fi

    # Check that the web server is properly set up
    web_server_validate || print_validation_error "Web server validation failed"

    return "$error_code"
}

########################
# Ensure OrangeHRM is initialized
# Globals:
#   ORANGEHRM_*
# Arguments:
#   None
# Returns:
#   None
#########################
orangehrm_initialize() {
    # Check if OrangeHRM has already been initialized and persisted in a previous run
    local db_host db_port db_name db_user db_pass
    local -r app_name="orangehrm"
    if ! is_app_initialized "$app_name"; then
        # Ensure OrangeHRM persisted directories exist (i.e. when a volume has been mounted to /bitnami)
        info "Ensuring OrangeHRM directories exist"
        ensure_dir_exists "$ORANGEHRM_VOLUME_DIR"
        # Use daemon:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$ORANGEHRM_VOLUME_DIR" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
        info "Trying to connect to the database server"
        db_host="$ORANGEHRM_DATABASE_HOST"
        db_port="$ORANGEHRM_DATABASE_PORT_NUMBER"
        db_name="$ORANGEHRM_DATABASE_NAME"
        db_user="$ORANGEHRM_DATABASE_USER"
        db_pass="$ORANGEHRM_DATABASE_PASSWORD"
        local -a mysql_execute_args=("$db_host" "$db_port" "$db_name" "$db_user" "$db_pass")
        orangehrm_wait_for_db_connection "${mysql_execute_args[@]}"

        # Change password strength level to medium
        if ! is_boolean_yes "$ORANGEHRM_ENFORCE_PASSWORD_STRENGTH"; then
            info "Changing the password strength validation to medium"
            local -a sql_files=("${ORANGEHRM_BASE_DIR}/dbscript/dbscript-2.sql" "${ORANGEHRM_BASE_DIR}/symfony/plugins/orangehrmSecurityAuthenticationPlugin/install/dbscript.sql")
            for sql_file in "${sql_files[@]}"; do
                replace_in_file "$sql_file" "'authentication.enforce_password_strength'\s*,\s*'on'" "'authentication.enforce_password_strength', 'off'"
                replace_in_file "$sql_file" "'authentication.default_required_password_strength'\s*,\s*'strong'" "'authentication.default_required_password_strength', 'medium'"
            done
        fi

        if ! is_boolean_yes "$ORANGEHRM_SKIP_BOOTSTRAP"; then
            # Perform initial bootstrapping for OrangeHRM
            orangehrm_pass_wizard "${mysql_execute_args[@]}"
            # SMTP configuration
            if ! is_empty_value "$ORANGEHRM_SMTP_HOST"; then
                info "Configuring SMTP credentials"
                mysql_remote_execute "${mysql_execute_args[@]}" <<EOF
INSERT INTO ohrm_email_configuration (mail_type, sent_as, smtp_host, smtp_port, smtp_username, smtp_password, smtp_auth_type, smtp_security_type)
VALUES ('smtp', '${ORANGEHRM_SMTP_USER}', '${ORANGEHRM_SMTP_HOST}', '${ORANGEHRM_SMTP_PORT_NUMBER}', '${ORANGEHRM_SMTP_USER}', '${ORANGEHRM_SMTP_PASSWORD}', 'login', '${ORANGEHRM_SMTP_PROTOCOL}');
EOF
            fi
        else
            info "An already initialized OrangeHRM database was provided, configuration will be skipped"
            orangehrm_generate_conf_files "${mysql_execute_args[@]}"
            warn "Make sure you upgrade the database manually if needed"
        fi

        info "Persisting OrangeHRM installation"
        persist_app "$app_name" "$ORANGEHRM_DATA_TO_PERSIST"
    else
        info "Restoring persisted OrangeHRM installation"
        restore_persisted_app "$app_name" "$ORANGEHRM_DATA_TO_PERSIST"

        local app_version db_version
        app_version="$(orangehrm_get_app_version)"
        db_version="$(orangehrm_conf_get "version")"
        if orangehrm_compare_versions "$app_version" "$db_version" "gt"; then
            info "New OrangeHRM version detected"
            if is_file_writable "$ORANGEHRM_CONF_FILE" && is_file_writable "$ORANGEHRM_DATABASE_CONF_FILE"; then
                info "Trying to connect to the database server"
                db_host="$(orangehrm_conf_get "dbhost")"
                db_port="$(orangehrm_conf_get "dbport")"
                db_name="$(orangehrm_conf_get "dbname")"
                db_user="$(orangehrm_conf_get "dbuser")"
                db_pass="$(orangehrm_conf_get "dbpass")"
                local -a mysql_execute_args=("$db_host" "$db_port" "$db_name" "$db_user" "$db_pass")
                orangehrm_wait_for_db_connection "${mysql_execute_args[@]}"
                orangehrm_pass_upgrade_wizard "$db_version" "${mysql_execute_args[@]}"
            else
                error "The application can't be upgraded because the persisted configuration files are not writable"
                return 1
            fi
        else
            info "The database schema version is up-to-date. Skipping upgrade"
        fi
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Generate configuration files with database info
#  - lib/confs/Conf.php
#  - symfony/config/databases.yml
# Globals:
#   ORANGEHRM_*
# Arguments:
#   $1 - database host
#   $2 - database port
#   $3 - database name
#   $4 - database username
#   $5 - database user password (optional)
# Returns:
#   None
#########################
orangehrm_generate_conf_files() {
    local -r db_host="${1:?missing database host}"
    local -r db_port="${2:?missing database port}"
    local -r db_name="${3:?missing database name}"
    local -r db_user="${4:?missing database user}"
    local -r db_pass="${5:-}"

    # The ApplicationSetupUtility methods expect inputs from session and database info needs to be adapted
    php_execute <<EOF
define("ROOT_PATH", "${ORANGEHRM_BASE_DIR}");
require "${ORANGEHRM_BASE_DIR}/installer/ApplicationSetupUtility.php";
\$setup = new ApplicationSetupUtility();

session_start();
\$_SESSION["dbInfo"]["dbHostName"] = "$db_host";
\$_SESSION["dbInfo"]["dbHostPort"] = "$db_port";
\$_SESSION["dbInfo"]["dbName"]     = "$db_name";
\$_SESSION["dbInfo"]["dbUserName"] = "$db_user";
\$_SESSION["dbInfo"]["dbPassword"] = "$db_pass";

\$setup->writeConfFile();
\$setup->writeSymfonyDbConfigFile();
EOF
}

########################
# Get an entry from the OrangeHRM configuration file (lib/confs/Conf.php)
# Globals:
#   ORANGEHRM_*
# Arguments:
#   $1 - key
# Returns:
#   None
#########################
orangehrm_conf_get() {
    local -r key="${1:?key missing}"
    debug "Getting ${key} from OrangeHRM configuration"
    php_execute_print_output <<< "require '${ORANGEHRM_CONF_FILE}'; \$conf = new Conf(); print_r(\$conf->${key});"
}

########################
# Get the application version
# Globals:
#   ORANGEHRM_*
# Arguments:
#   None
# Returns:
#   None
#########################
orangehrm_get_app_version() {
    php_execute_print_output <<< "require '${ORANGEHRM_BASE_DIR}/lib/confs/sysConf.php'; \$sysConf = new sysConf(); print_r(\$sysConf->getVersion());"
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
orangehrm_wait_for_db_connection() {
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
# Pass OrangeHRM wizard
# Globals:
#   *
# Arguments:
#   $1 - database host
#   $2 - database port
#   $3 - database name
#   $4 - database username
#   $5 - database user password (optional)
# Returns:
#   true if the wizard succeeded, false otherwise
#########################
orangehrm_pass_wizard() {
    local -r db_host="${1:?missing database host}"
    local -r db_port="${2:?missing database port}"
    local -r db_name="${3:?missing database name}"
    local -r db_user="${4:?missing database user}"
    local -r db_pass="${5:-}"

    local -r port="${WEB_SERVER_HTTP_PORT_NUMBER:-"$WEB_SERVER_DEFAULT_HTTP_PORT_NUMBER"}"
    local wizard_url cookie_file curl_output
    local -a curl_opts curl_data_opts
    wizard_url="http://127.0.0.1:${port}/install.php"
    cookie_file="/tmp/cookie$(generate_random_string -t alphanumeric -c 8)"
    curl_opts=("--location" "--silent" "--cookie" "$cookie_file" "--cookie-jar" "$cookie_file")
    # Ensure the web server is started
    web_server_start
    # Step 0: Get cookies & Welcome page
    curl "${curl_opts[@]}" "$wizard_url" >/dev/null 2>&1
    curl_data_opts=(
        "--data-urlencode" "txtScreen=0"
        "--data-urlencode" "actionResponse=WELCOMEOK"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "$wizard_url" 2>/dev/null)"
    if [[ "$curl_output" != *"Step 1"* ]]; then
        error "An error occurred while installing OrangeHRM: Step 0"
        debug "$curl_output"
        return 1
    fi
    # Step 1: License acceptance
    curl_data_opts=(
        "--data-urlencode" "txtScreen=1"
        "--data-urlencode" "actionResponse=LICENSEOK"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "$wizard_url" 2>/dev/null)"
    if [[ "$curl_output" != *"Step 2"* ]]; then
        error "An error occurred while installing OrangeHRM: Step 1"
        debug "$curl_output"
        return 1
    fi
    # Step 2: Database configuration
    debug "Configuring database settings"
    curl_data_opts=(
        "--data-urlencode" "txtScreen=2"
        "--data-urlencode" "actionResponse=DBINFO"
        "--data-urlencode" "cMethod=existing"
        "--data-urlencode" "dbCreateMethod=existing"
        "--data-urlencode" "dbHostName=${db_host}"
        "--data-urlencode" "dbHostPort=${db_port}"
        "--data-urlencode" "dbName=${db_name}"
        "--data-urlencode" "dbOHRMUserName=${db_user}"
        "--data-urlencode" "dbOHRMPassword=${db_pass}"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "$wizard_url" 2>/dev/null)"
    if [[ "$curl_output" != *"Step 3"* ]]; then
        error "An error occurred while installing OrangeHRM: Step 2"
        debug "$curl_output"
        return 1
    fi
    # Step 3: System check
    curl_data_opts=(
        "--data-urlencode" "txtScreen=3"
        "--data-urlencode" "actionResponse=SYSCHECKOK"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "$wizard_url" 2>/dev/null)"
    if [[ "$curl_output" != *"Step 4"* ]]; then
        error "An error occurred while installing OrangeHRM: Step 3"
        debug "$curl_output"
        return 1
    fi
    # Step 4: System configuration
    debug "Configuring system settings"
    curl_data_opts=(
        "--data-urlencode" "txtScreen=4"
        "--data-urlencode" "actionResponse=DEFUSERINFO"
        "--data-urlencode" "OHRMAdminUserName=${ORANGEHRM_USERNAME}"
        "--data-urlencode" "OHRMAdminPassword=${ORANGEHRM_PASSWORD}"
        "--data-urlencode" "OHRMAdminPasswordConfirm=${ORANGEHRM_PASSWORD}"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "$wizard_url" 2>/dev/null)"
    if [[ "$curl_output" != *"Step 5"* ]]; then
        error "An error occurred while installing OrangeHRM: Step 4"
        debug "$curl_output"
        return 1
    fi
    # Step 5: Confirmation
    curl_data_opts=(
        "--data-urlencode" "txtScreen=5"
        "--data-urlencode" "actionResponse=CONFIRMED"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "$wizard_url" 2>/dev/null)"
    if [[ "$curl_output" != *"Step 6"* ]]; then
        error "An error occurred while installing OrangeHRM: Step 5"
        debug "$curl_output"
        return 1
    fi
    # Step 6: Installation
    check_installation_progress() {
        local curl_output
        debug "Installation in progress"
        curl_output="$(curl "${curl_opts[@]}" "$wizard_url" 2>/dev/null)"
        [[ "$curl_output" == *"Installation completed successfuly"* ]]
    }
    local -r retries="6"
    local -r interval_time="0"
    retry_while check_installation_progress "$retries" "$interval_time"
    curl_data_opts=(
        "--data-urlencode" "txtScreen=6"
        "--data-urlencode" "actionResponse=LOGIN"
    )
    debug "Installation in progress"
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "$wizard_url" 2>/dev/null)"
    if [[ "$curl_output" != *"successfully installed"* ]]; then
        error "An error occurred while installing OrangeHRM: Step 6"
        debug "$curl_output"
        return 1
    fi
    # Stop the web server afterwards
    web_server_stop
}

########################
# Pass OrangeHRM upgrade wizard
# Globals:
#   *
# Arguments:
#   $1 - database schema version
#   $2 - database host
#   $3 - database port
#   $4 - database name
#   $5 - database username
#   $6 - database user password (optional)
# Returns:
#   true if the wizard succeeded, false otherwise
#########################
orangehrm_pass_upgrade_wizard() {
    local -r db_schema_version="${1:?missing database schema version}"
    local -r db_host="${2:?missing database host}"
    local -r db_port="${3:?missing database port}"
    local -r db_name="${4:?missing database name}"
    local -r db_user="${5:?missing database user}"
    local -r db_pass="${6:-}"

    local -r port="${WEB_SERVER_HTTP_PORT_NUMBER:-"$WEB_SERVER_DEFAULT_HTTP_PORT_NUMBER"}"
    local wizard_url cookie_file curl_output
    local -a curl_opts curl_data_opts
    wizard_url="http://127.0.0.1:${port}/upgrader/web/index.php"
    cookie_file="/tmp/cookie$(generate_random_string -t alphanumeric -c 8)"
    curl_opts=("--location" "--silent" "--cookie" "$cookie_file" "--cookie-jar" "$cookie_file")
    get_csrf_token() {
        # The CSRF token changes on each request. It needs to be evaluated each time
        local -r html="${1:?missing html output}"
        sed -z -E 's/^.+csrf_token.+value="(\w+)".+csrf_token.+$/\1/' <<< "$html"
    }
    # Ensure the web server is started
    web_server_start
    # Step 0: Get cookies and CSRF token
    curl_output="$(curl "${curl_opts[@]}" "$wizard_url" 2>/dev/null)"
    # Step 1: Database information
    curl_data_opts=(
        "--data-urlencode" "databaseInfo[host]=${db_host}"
        "--data-urlencode" "databaseInfo[port]=${db_port}"
        "--data-urlencode" "databaseInfo[database_name]=${db_name}"
        "--data-urlencode" "databaseInfo[username]=${db_user}"
        "--data-urlencode" "databaseInfo[password]=${db_pass}"
        "--data-urlencode" "databaseInfo[submitBy]=databaseInfo"
        "--data-urlencode" "databaseInfo[_csrf_token]=$(get_csrf_token "${curl_output}")"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}/upgrade/getDatabaseInfo" 2>/dev/null)"
    if [[ "$curl_output" != *"System Check"* ]]; then
        error "An error occurred while upgrading OrangeHRM: Step 1"
        debug "$curl_output"
        return 1
    fi
    # Step 2: System check
    curl_data_opts=(
        "--data-urlencode" "systemCheck[submitBy]=systemCheck"
        "--data-urlencode" "systemCheck[_csrf_token]=$(get_csrf_token "${curl_output}")"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}/upgrade/executeSystemCheck" 2>/dev/null)"
    if [[ "$curl_output" != *"Version Details"* ]]; then
        error "An error occurred while upgrading OrangeHRM: Step 2"
        debug "$curl_output"
        return 1
    fi
    # Step 3: Version details
    if ! grep ">${db_schema_version}<" >/dev/null <<< "$curl_output"; then
        error "Upgrade from version ${db_schema_version} is not supported by OrangeHRM"
        debug "$curl_output"
        return 1
    fi
    curl_data_opts=(
        "--data-urlencode" "versionInfo[submitBy]=selectVersion"
        "--data-urlencode" "versionInfo[version]=${db_schema_version}"
        "--data-urlencode" "versionInfo[_csrf_token]=$(get_csrf_token "${curl_output}")"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}/upgrade/calculateIncrementNumbers" 2>/dev/null)"
    if [[ "$curl_output" != *"Version Information"* ]]; then
        error "An error occurred while upgrading OrangeHRM: Step 3"
        debug "$curl_output"
        return 1
    fi
    # Step 4: Database Changes
    get_db_tasks(){
        local -r html="${1:?missing html output}"
        sed -E '/tasks\[/!d ; s/.*tasks\[[0-9]+]=.([0-9]+).;/\1/g' <<< "$html" | tr '\n' ' '
    }
    check_task_progress() {
        local result percentage
        result="$(curl "${curl_opts[@]}" "${wizard_url}/upgrade/dbChangeControl?task=${task}" 2>/dev/null)"
        percentage="$(sed -z -E 's/^.+"progress":([0-9]+).+$/\1/' <<< "$result")"
        debug "Checking task ${task} progress: ${percentage}%"
        [[ "$result" == *'progress":100'* ]]
    }
    curl_output="$(curl "${curl_opts[@]}" "${wizard_url}/upgrade/executeDbChange" 2>/dev/null)"
    read -r -a tasks <<< "$(get_db_tasks "${curl_output}")"
    local -r retries="10"
    local -r interval_time="2"
    for task in "${tasks[@]}"; do
        retry_while check_task_progress "$retries" "$interval_time"
    done
    curl_data_opts=(
        "--data-urlencode" "databaseChange[submitBy]=dbChange"
        "--data-urlencode" "databaseChange[_csrf_token]=$(get_csrf_token "${curl_output}")"
        "--data-urlencode" "dbChangeStartBtn=Proceed"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}/upgrade/executeDbChange" 2>/dev/null)"
    if [[ "$curl_output" != *"Configuration Files"* ]]; then
        error "An error occurred while upgrading OrangeHRM: Step 4"
        debug "$curl_output"
        return 1
    fi
    # Step 5: Configuration files
    curl_data_opts=(
        "--data-urlencode" "configureFile[submitBy]=configureFile"
        "--data-urlencode" "configureFile[_csrf_token]=$(get_csrf_token "${curl_output}")"
        "--data-urlencode" "sumbitButton=Start"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}/upgrade/executeConfChange" 2>/dev/null)"
    if [[ "$curl_output" == *"Pending"* ]]; then
        error "An error occurred while upgrading OrangeHRM: Step 5"
        debug "$curl_output"
        return 1
    fi
    curl_data_opts=(
        "--data-urlencode" "configureFile[submitBy]=configureFile"
        "--data-urlencode" "configureFile[_csrf_token]=$(get_csrf_token "${curl_output}")"
        "--data-urlencode" "sumbitButton=Proceed"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}/upgrade/executeConfChange" 2>/dev/null)"
    if [[ "$curl_output" != *"successfully upgraded"* ]]; then
        error "An error occurred while upgrading OrangeHRM: Step 5"
        debug "$curl_output"
        return 1
    fi
    # Stop the web server afterwards
    web_server_stop
    info "OrangeHRM was successfully upgraded"
    if [[ -f "${ORANGEHRM_BASE_DIR}/upgrader/log/notes.log" ]];then
        warn "Some manual actions may need to be done. See the notes below:"
        cat "${ORANGEHRM_BASE_DIR}/upgrader/log/notes.log"
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
orangehrm_compare_versions() {
    local -r v1="${1:?missing version 1}"
    local -r v2="${2:?missing version 2}"
    local -r operator="${3:?missing operator}"

    ! is_empty_value "$(php_execute_print_output <<< "echo version_compare('${v1}', '${v2}', '${operator}');")"
}
