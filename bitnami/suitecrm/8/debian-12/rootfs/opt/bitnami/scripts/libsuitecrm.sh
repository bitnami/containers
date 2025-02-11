#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami SuiteCRM library

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

# Rewrite env variables if SuiteCRM 7 is detected
if [[ ! -d "${SUITECRM_BASE_DIR}/public" ]]; then
    export SUITECRM_CONF_FILE="${SUITECRM_BASE_DIR}/config.php"
    export SUITECRM_SILENT_INSTALL_CONF_FILE="${SUITECRM_BASE_DIR}/config_si.php"
fi

########################
# Validate settings in SUITECRM_* env vars
# Globals:
#   SUITECRM_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
suitecrm_validate() {
    debug "Validating settings in SUITECRM_* environment variables..."
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
    check_true_false_value() {
        if ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for $1 are [true, false]"
        fi
    }
    check_valid_port() {
        local port_var="${1:?missing port variable}"
        local err
        if ! err="$(validate_port "${!port_var}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    # Validate user inputs
    ! is_empty_value "$SUITECRM_VALIDATE_USER_IP" && check_true_false_value "SUITECRM_VALIDATE_USER_IP"

    check_yes_no_value "SUITECRM_ENABLE_HTTPS"

    # Validate credentials
    for empty_env_var in "SUITECRM_DATABASE_PASSWORD" "SUITECRM_PASSWORD"; do
        is_empty_value "${!empty_env_var}" && print_validation_error "The ${empty_env_var} environment variable is empty or not set."
    done

    # Validate SMTP credentials
    if ! is_empty_value "$SUITECRM_SMTP_HOST"; then
        for empty_env_var in "SUITECRM_SMTP_USER" "SUITECRM_SMTP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && warn "The ${empty_env_var} environment variable is empty or not set."
        done
        is_empty_value "$SUITECRM_SMTP_PORT_NUMBER" && print_validation_error "The SUITECRM_SMTP_PORT_NUMBER environment variable is empty or not set."
        ! is_empty_value "$SUITECRM_SMTP_PORT_NUMBER" && check_valid_port "SUITECRM_SMTP_PORT_NUMBER"
        ! is_empty_value "$SUITECRM_SMTP_PROTOCOL" && check_multi_value "SUITECRM_SMTP_PROTOCOL" "ssl tls"
    fi

    # Check that the web server is properly set up
    web_server_validate || print_validation_error "Web server validation failed"

    return "$error_code"
}

########################
# Ensure SuiteCRM is initialized
# Globals:
#   SUITECRM_*
# Arguments:
#   None
# Returns:
#   None
#########################
suitecrm_initialize() {
    # Check if SuiteCRM has already been initialized and persisted in a previous run
    local db_host db_port db_name db_user db_pass cron_script
    local -r app_name="suitecrm"
    if ! is_app_initialized "$app_name"; then
        # Ensure SuiteCRM persisted directories exist (i.e. when a volume has been mounted to /bitnami)
        info "Ensuring SuiteCRM directories exist"
        ensure_dir_exists "$SUITECRM_VOLUME_DIR"
        # Use daemon:daemon ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$SUITECRM_VOLUME_DIR" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "$WEB_SERVER_DAEMON_GROUP"
        info "Trying to connect to the database server"
        db_host="$SUITECRM_DATABASE_HOST"
        db_port="$SUITECRM_DATABASE_PORT_NUMBER"
        db_name="$SUITECRM_DATABASE_NAME"
        db_user="$SUITECRM_DATABASE_USER"
        db_pass="$SUITECRM_DATABASE_PASSWORD"
        suitecrm_wait_for_db_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"

        local -r template_dir="${BITNAMI_ROOT_DIR}/scripts/suitecrm/bitnami-templates"
        if ! is_boolean_yes "$SUITECRM_SKIP_BOOTSTRAP"; then
            # If SuiteCRM 7, use legacy install wizard
            if [[ ! -d "${SUITECRM_BASE_DIR}/public" ]]; then
                # Render configuration file for silent install ('config_si.php')
                (
                    export url_protocol=http
                    is_boolean_yes "$SUITECRM_ENABLE_HTTPS" && url_protocol=https
                    render-template "${template_dir}/config_si.php.tpl" > "$SUITECRM_SILENT_INSTALL_CONF_FILE"
                )
                web_server_start
                suitecrm_7_pass_wizard
                # Configure SMTP via application wizard
                if ! is_empty_value "$SUITECRM_SMTP_HOST"; then
                    info "Configuring SMTP"
                    suitecrm_pass_smtp_wizard
                fi
                web_server_stop
                # Delete configuration file for silent install as it's not needed anymore
                rm "$SUITECRM_SILENT_INSTALL_CONF_FILE"
            else
                web_server_start
                suitecrm_pass_wizard
                # Configure SMTP via application wizard
                if ! is_empty_value "$SUITECRM_SMTP_HOST"; then
                    info "Configuring SMTP"
                    suitecrm_pass_smtp_wizard
                fi
                web_server_stop
            fi

        else
            info "An already initialized SuiteCRM database was provided, configuration will be skipped"
            # A very basic 'config.php' will be generated with enough information for the application to be able to connect to the database
            # Afterwards we will make use of the application's 'Rebuild Config File' functionality to create a complete configuration file
            # Then we will be able to use the application's scripts to generate cache files, '.htaccess' and other required files
            info "Generating SuiteCRM configuration file"
            (
                export db_host db_port db_name db_user db_pass
                render-template "${template_dir}/config_db.php.tpl" > "$SUITECRM_CONF_FILE"
                # Ensure the configuration file is writable by the web server
                # Negate the condition to always return true and avoid causing exit code
                ! am_i_root || configure_permissions_ownership "$SUITECRM_CONF_FILE" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
            )
            suitecrm_rebuild_files
        fi

        info "Persisting SuiteCRM installation"
        persist_app "$app_name" "$SUITECRM_DATA_TO_PERSIST"
    else
        info "Restoring persisted SuiteCRM installation"
        restore_persisted_app "$app_name" "$SUITECRM_DATA_TO_PERSIST"
        info "Trying to connect to the database server"
        db_host="$(suitecrm_conf_get "dbconfig" "db_host_name")"
        db_port="$(suitecrm_conf_get "dbconfig" "db_port")"
        db_name="$(suitecrm_conf_get "dbconfig" "db_name")"
        db_user="$(suitecrm_conf_get "dbconfig" "db_user_name")"
        db_pass="$(suitecrm_conf_get "dbconfig" "db_password")"
        suitecrm_wait_for_db_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
    fi

    # Logs directory must be owned by the web server daemon user, the PHP code doesn't
    # check for write permissions but ownership
    if am_i_root; then
        for log_file in "${SUITECRM_VOLUME_DIR}/logs/legacy/suitecrm.log" "${SUITECRM_VOLUME_DIR}/logs/prod/prod.log"; do
            ensure_dir_exists "$(dirname "$log_file")"
            touch "$log_file"
        done
        configure_permissions_ownership "${SUITECRM_VOLUME_DIR}/logs" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "$WEB_SERVER_DAEMON_GROUP"
    fi

    # Ensure SuiteCRM cron jobs are created when running setup with a root user
    # https://docs.suitecrm.com/blog/scheduler-jobs/
    cron_script="${SUITECRM_BASE_DIR}/cron.php"
    [[ "$(get_sematic_version "$APP_VERSION" 1)" -ge 8 ]] && cron_script="${SUITECRM_BASE_DIR}/public/legacy/cron.php"
    local -a cron_cmd=("${PHP_BIN_DIR}/php" "$cron_script")
    if am_i_root; then
        generate_cron_conf "suitecrm" "${cron_cmd[*]} > /dev/null 2>&1" --run-as "$WEB_SERVER_DAEMON_USER" --schedule "* * * * *"
    else
        warn "Skipping cron configuration for SuiteCRM because of running as a non-root user"
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Get an entry from the SuiteCRM configuration file ('config.php')
# Globals:
#   SUITECRM_*
# Arguments:
#   $1 - PHP variable name
# Returns:
#   None
#########################
suitecrm_conf_get() {
    local key="${1:?key missing}"
    # Construct a PHP array path for the configuration, so each key is passed as a separate argument
    local path="\$sugar_config"
    for key in "$@"; do
        path="${path}['${key}']"
    done
    debug "Getting ${key} from SuiteCRM configuration"
    php -r "require ('${SUITECRM_CONF_FILE}'); print_r($path);"
}

########################
# Set an entry into the SuiteCRM configuration file ('config.php')
# Globals:
#   SUITECRM_*
# Arguments:
#   $1 - PHP variable name
# Returns:
#   None
#########################
suitecrm_conf_set() {
    local -r key="${1:?key missing}"
    local -r value="${2:?missing value}"
    debug "Setting ${key} to '${value}' in SuiteCRM configuration"
    # Sanitize key (sed does not support fixed string substitutions)
    local sanitized_pattern
    sanitized_pattern="$(sed 's/[]\[^$.*/]/\\&/g' <<< "$key")"
    # Check if the configuration exists in the file
    if grep -q -E "$sanitized_pattern" "$SUITECRM_CONF_FILE"; then
        # It exists, so replace the line
        replace_in_file "$SUITECRM_CONF_FILE" "('${sanitized_pattern}' => ').*(',)" "\1${value}\2"
    else
        # The SuiteCRM configuration file includes all supported keys, but because of its format,
        # we cannot append contents to the end. We can assume thi
        warn "Could not set the SuiteCRM '${key}' configuration. Check that the file has not been modified externally."
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
suitecrm_wait_for_db_connection() {
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
# Pass SuiteCRM SMTP wizard
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   true if the wizard succeeded, false otherwise
#########################
suitecrm_pass_smtp_wizard() {
    local -r port="${APACHE_HTTP_PORT_NUMBER:-"$APACHE_DEFAULT_HTTP_PORT_NUMBER"}"
    local wizard_url curl_output
    local -a curl_opts curl_data_opts
    local url_protocol=http
    is_boolean_yes "$SUITECRM_ENABLE_HTTPS" && url_protocol=https
    local site_url="${url_protocol}://127.0.0.1:${port}/index.php"
    cookie_file="/tmp/cookie$(generate_random_string -t alphanumeric -c 8)"
    curl_opts=(
        "--location"
        "--silent"
        "--cookie-jar" "$cookie_file"
        "--cookie" "$cookie_file"
        # Used to avoid XSRF warning
        "--referer" "http://localhost"
    )
    # Step 1: Login to SuiteCRM and check that SMTP is not configured yet
    wizard_url="${site_url}?action=Login&module=Users"
    curl_data_opts=(
        "--data-urlencode" "username_password=${SUITECRM_PASSWORD}"
        "--data-urlencode" "user_name=${SUITECRM_USERNAME}"
        "--data-urlencode" "return_action=Login"
        "--data-urlencode" "module=Users"
        "--data-urlencode" "action=Authenticate"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}")"
    if [[ "$curl_output" != *"an SMTP server must be configured"* ]]; then
        error "An error occurred while trying to login to configure SMTP"
        return 1
    fi

    # Step 2: Configure SMTP and check the message to warn about SMTP has gone
    wizard_url="${site_url}?module=EmailMan&action=config"

    # Check if SMTP should go over SSL
    local smtp_protocol=""
    [[ "$SUITECRM_SMTP_PROTOCOL" = "ssl" ]] && smtp_protocol="1"
    [[ "$SUITECRM_SMTP_PROTOCOL" = "tls" ]] && smtp_protocol="2"

    # Check if SMTP user:pass is configured
    local smtp_auth_req=0
    ! is_empty_value "$SUITECRM_SMTP_USER" && smtp_auth_req=1

    curl_data_opts=(
        "--data-urlencode" "mail_allowusersend=0"
        "--data-urlencode" "mail_sendtype=SMTP"
        "--data-urlencode" "mail_smtpauth_req=${smtp_auth_req}"
        "--data-urlencode" "module=EmailMan"
        "--data-urlencode" "mail_smtppass=${SUITECRM_SMTP_PASSWORD}"
        "--data-urlencode" "mail_smtpport=${SUITECRM_SMTP_PORT_NUMBER}"
        "--data-urlencode" "mail_smtpserver=${SUITECRM_SMTP_HOST}"
        "--data-urlencode" "mail_smtptype=other"
        "--data-urlencode" "mail_smtpuser=${SUITECRM_SMTP_USER}"
        "--data-urlencode" "mail_smtpssl=${smtp_protocol}"
        "--data-urlencode" "notify_fromaddress=${SUITECRM_SMTP_NOTIFY_ADDRESS}"
        "--data-urlencode" "notify_fromname=${SUITECRM_SMTP_NOTIFY_NAME}"
        "--data-urlencode" "action=Save"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}")"
    if [[ "$curl_output" == *"an SMTP server must be configured"* ]]; then
        error "An error occurred configuring SMTP for SuiteCRM"
        return 1
    fi
}

########################
# Pass SuiteCRM wizard
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   true if the wizard succeeded, false otherwise
#########################
suitecrm_pass_wizard() {
    local -a install_args
    local url_protocol=http
    local -r url_port="${APACHE_HTTP_PORT_NUMBER:-"$APACHE_DEFAULT_HTTP_PORT_NUMBER"}"
    info "Running setup wizard"
    is_boolean_yes "$SUITECRM_ENABLE_HTTPS" && url_protocol=https url_port="${APACHE_HTTPS_PORT_NUMBER:-"$APACHE_DEFAULT_HTTPS_PORT_NUMBER"}"

    install_args=(
        "--site_host=${url_protocol}://${SUITECRM_HOST}:${url_port}"
        "--site_username=${SUITECRM_USERNAME}"
        "--site_password=${SUITECRM_PASSWORD}"
        "--db_username=${SUITECRM_DATABASE_USER}"
        "--db_password=${SUITECRM_DATABASE_PASSWORD}"
        "--db_host=${SUITECRM_DATABASE_HOST}"
        "--db_port=${SUITECRM_DATABASE_PORT_NUMBER}"
        "--db_name=${SUITECRM_DATABASE_NAME}"
        "--no-interaction"
    )

    suitecrm_execute suitecrm:app:install "${install_args[@]}"
}

########################
# Pass SuiteCRM 7 wizard
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   true if the wizard succeeded, false otherwise
#########################
suitecrm_7_pass_wizard() {
    local -r port="${APACHE_HTTP_PORT_NUMBER:-"$APACHE_DEFAULT_HTTP_PORT_NUMBER"}"
    local wizard_url curl_output
    local -a curl_opts curl_data_opts
    local url_protocol=http
    info "Running setup wizard"
    is_boolean_yes "$SUITECRM_ENABLE_HTTPS" && url_protocol=https
    wizard_url="${url_protocol}://127.0.0.1:${port}/install.php?goto=SilentInstall&cli=true"
    curl_opts=("--location" "--silent")
    curl_data_opts=(
        "--data-urlencode" "current_step=8"
        "--data-urlencode" "goto=Next"
    )
    local wizard_exit_code=0
    wizard_error() {
        error "An error occurred while installing SuiteCRM: ${*}"
        wizard_exit_code=1
    }
    if ! debug_execute curl "${curl_opts[@]}" "${wizard_url}"; then
        wizard_error "The wizard could not be accessed"
    fi
    if ! grep -q "Save user settings" "${SUITECRM_BASE_DIR}/install.log"; then
        wizard_error "Installation failed"
    fi
    return "$wizard_exit_code"
}

########################
# Rebuild SuiteCRM's configuration file
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   true if succeded, false otherwise
#########################
suitecrm_rebuild_files() {
    # The below script executes the code from "Repair > Rebuild Config File" to regenerate the configuration file
    # We prefer to run a script rather than via cURL requests because it would require to login, and could cause
    # issues with SUITECRM_SKIP_BOOTSTRAP
    php_execute <<EOF
chdir('$SUITECRM_BASE_DIR');
define('sugarEntry', true);
require_once('include/utils.php');

// Based on 'install.php' includes
require_once('include/SugarLogger/LoggerManager.php');
require_once('sugar_version.php');
require_once('suitecrm_version.php');
require_once('include/TimeDate.php');
require_once('include/Localization/Localization.php');
require_once('include/SugarTheme/SugarTheme.php');
require_once('include/utils/LogicHook.php');
require_once('data/SugarBean.php');
// Include files that are loaded by 'entryPoint.php'
// (Note: We cannot include 'entryPoint.sh' since it is only expected to work via HTTP requests)
require_once('include/SugarEmailAddress/SugarEmailAddress.php');
require_once('include/utils/file_utils.php');

// Rebuild the configuration file
// Based on the RebuildConfig action in the admin panel
\$clean_config = loadCleanConfig();
rebuildConfigFile(\$clean_config, \$sugar_version);

// Rebuild the .htaccess file
// Based on the UpgradeAccess action in the admin panel
require_once 'include/upload_file.php';
UploadStream::register();
require('modules/Administration/UpgradeAccess.php');
EOF
}

########################
# Execute SuiteCRM console command
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   true if the wizard succeeded, false otherwise
#########################
suitecrm_execute() {
    local -a cmd=("php" "${SUITECRM_BASE_DIR}/bin/console" "$@")
    # Run as web server user to avoid having to change permissions/ownership afterwards
    am_i_root && cmd=("run_as_user" "$WEB_SERVER_DAEMON_USER" "${cmd[@]}")
    (
        cd "${SUITECRM_BASE_DIR}" || false
        debug_execute "${cmd[@]}"
    )
}
