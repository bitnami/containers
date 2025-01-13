#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Gitea library

# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Load generic libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libpersistence.sh

########################
# Validate settings in GITEA_* env vars
# Globals:
#   GITEA_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
gitea_validate() {
    debug "Validating settings in GITEA_* environment variables..."
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
    check_valid_port() {
        local port_var="${1:?missing port variable}"
        local err
        if ! err="$(validate_port "${!port_var}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    check_true_false_value() {
        if ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for $1 are [true, false]"
        fi
    }
    check_multi_value() {
        if [[ " ${2} " != *" ${!1} "* ]]; then
            print_validation_error "The allowed values for ${1} are: ${2}"
        fi
    }

    ! is_empty_value "$GITEA_HTTP_PORT" && check_valid_port "GITEA_HTTP_PORT"
    ! is_empty_value "$GITEA_SSH_PORT" && check_valid_port "GITEA_SSH_PORT"
    ! is_empty_value "$GITEA_SSH_LISTEN_PORT" && check_valid_port "GITEA_SSH_LISTEN_PORT"

    if is_boolean_yes "$GITEA_SMTP_ENABLED"; then
        check_empty_value "GITEA_SMTP_HOST"
        check_empty_value "GITEA_SMTP_FROM"
    fi

    check_true_false_value 'GITEA_OAUTH2_CLIENT_AUTO_REGISTRATION_ENABLED'
    check_multi_value 'GITEA_OAUTH2_CLIENT_USERNAME' 'userid nickname preferred_username email'

    return "$error_code"
}

########################
# Check if Gitea daemon is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_gitea_running() {
    pid="$(get_pid_from_file "$GITEA_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if Gitea daemon is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_gitea_not_running() {
    ! is_gitea_running
}

########################
# Stop Gitea daemons
# Arguments:
#   None
# Returns:
#   None
#########################
gitea_stop() {
    ! is_gitea_running && return
    stop_service_using_pid "$GITEA_PID_FILE"
}

########################
# Initialize Gitea
# Arguments:
#   None
# Returns:
#   None
#########################
gitea_initialize() {
    # Wait for database connection
    local -r database_host="${GITEA_DATABASE_HOST%:*}"
    local database_port="${GITEA_DATABASE_HOST#*:}"
    if is_empty_value "$database_port" || [[ "$database_port" == "$database_host" ]]; then
        if [[ "${GITEA_DATABASE_TYPE}" == "mysql" ]]; then
            database_port="${GITEA_DATABASE_PORT_NUMBER:-3306}"
        else
            # Postgresql default port
            database_port="${GITEA_DATABASE_PORT_NUMBER:-5432}"
        fi
    fi
    info "Waiting for database connection..."
    wait_for_connection "$database_host" "$database_port"
    info "Initializing Gitea..."
    # Check if Gitea has already been initialized and persisted in a previous run
    local -r app_name="gitea"
    if ! is_app_initialized "$app_name" || [[ ! -f "$GITEA_CONF_FILE" ]]; then
        # Run installation steps
        # https://docs.gitea.io/en-us/install-from-binary/
        # Ensure configurable dirs exist
        local -r dirs=(
            "${GITEA_REPO_ROOT_PATH}"
            "${GITEA_LOG_ROOT_PATH}"
            "${GITEA_LFS_ROOT_PATH}"
        )
        for dir in "${dirs[@]}"; do
            if ! is_empty_value "$dir"; then
                ensure_dir_exists "$dir"
                am_i_root && configure_permissions_ownership "$dir" -d "775" -f "664" -u "$GITEA_DAEMON_USER" -g "root"
            fi
        done
        gitea_update_conf_file
        gitea_pass_wizard
        # These config values are not desired for the wizard, as we want to print install output to a specific log file
        # In addition, Gitea overwrites these values after passing the wizard, so we need to set them afterwards anyways
        is_empty_value "$GITEA_LOG_MODE" || gitea_conf_set "log" "MODE" "$GITEA_LOG_MODE"
        is_empty_value "$GITEA_LOG_ROUTER" || gitea_conf_set "log" "ROUTER" "$GITEA_LOG_ROUTER"
        # These OpenID config values are set after passing the wizard, since Gitea overwrites them.
        is_empty_value "$GITEA_ENABLE_OPENID_SIGNIN" || gitea_conf_set "openid" "ENABLE_OPENID_SIGNIN" "$GITEA_ENABLE_OPENID_SIGNIN"
        is_empty_value "$GITEA_ENABLE_OPENID_SIGNUP" || gitea_conf_set "openid" "ENABLE_OPENID_SIGNUP" "$GITEA_ENABLE_OPENID_SIGNUP"
        info "Persisting Gitea installation"
        persist_app "$app_name" "$GITEA_DATA_TO_PERSIST"
    else
        info "Restoring persisted Gitea installation"
        restore_persisted_app "$app_name" "$GITEA_DATA_TO_PERSIST"
        # Update config file with env vars
        gitea_update_conf_file
    fi
    # Avoid exit code of previous commands to affect the result of this function
    true
}

#######################
# Wait until the host and port are accessible
# Globals:
#   *
# Arguments:
#   $1 - database host
#   $2 - database port
# Returns:
#   true if the database connection succeeded, false otherwise
#########################
wait_for_connection() {
    local -r host="${1:?missing database host}"
    local -r port="${2:?missing database port}"
    check_connection() {
        wait-for-port --host "$host" "$port"
    }
    if ! retry_while "check_connection"; then
        error "Could not connect to the ${host}:${port}"
        return 1
    fi
}

########################
# Update the Gitea configuration file with the user inputs
# Globals:
#   GITEA_*
# Arguments:
#   None
# Returns:
#   None
#########################
gitea_update_conf_file() {
    # https://docs.gitea.io/en-us/config-cheat-sheet/
    # That URL contains most of the settings that can be configured as well as their default value.
    gitea_conf_set "" "APP_NAME" "$GITEA_APP_NAME"
    gitea_conf_set "" "RUN_USER" "$GITEA_DAEMON_USER"
    gitea_conf_set "" "RUN_MODE" "$GITEA_RUN_MODE"
    gitea_conf_set "database" "DB_TYPE" "$GITEA_DATABASE_TYPE"
    gitea_conf_set "database" "HOST" "${GITEA_DATABASE_HOST}:${GITEA_DATABASE_PORT_NUMBER}"
    gitea_conf_set "database" "NAME" "$GITEA_DATABASE_NAME"
    gitea_conf_set "database" "USER" "$GITEA_DATABASE_USERNAME"
    is_empty_value "$GITEA_DATABASE_PASSWORD" || gitea_conf_set "database" "PASSWD" "$GITEA_DATABASE_PASSWORD"
    is_empty_value "$GITEA_DATABASE_SCHEMA" || gitea_conf_set "database" "SCHEMA" "$GITEA_DATABASE_SCHEMA"
    is_empty_value "$GITEA_DATABASE_SSL_MODE" || gitea_conf_set "database" "SSL_MODE" "$GITEA_DATABASE_SSL_MODE"

    gitea_conf_set "server" "DOMAIN" "$GITEA_DOMAIN"
    gitea_conf_set "server" "PROTOCOL" "$GITEA_PROTOCOL"
    gitea_conf_set "server" "ROOT_URL" "$GITEA_ROOT_URL"
    gitea_conf_set "server" "SSH_DOMAIN" "$GITEA_SSH_DOMAIN"
    gitea_conf_set "server" "SSH_PORT" "$GITEA_SSH_PORT"
    gitea_conf_set "server" "SSH_LISTEN_PORT" "$GITEA_SSH_LISTEN_PORT"
    gitea_conf_set "server" "HTTP_PORT" "$GITEA_HTTP_PORT"
    gitea_conf_set "log" "ROOT_PATH" "$GITEA_LOG_ROOT_PATH"
    gitea_conf_set "repository" "ROOT" "$GITEA_REPO_ROOT_PATH"
    gitea_conf_set "security" "PASSWORD_HASH_ALGO" "$GITEA_PASSWORD_HASH_ALGO"

    gitea_conf_set "mailer" "ENABLED" "$GITEA_SMTP_ENABLED"
    is_empty_value "$GITEA_SMTP_HOST" || gitea_conf_set "mailer" "SMTP_ADDR" "$GITEA_SMTP_HOST"
    is_empty_value "$GITEA_SMTP_PORT" || gitea_conf_set "mailer" "SMTP_PORT" "$GITEA_SMTP_PORT"
    is_empty_value "$GITEA_SMTP_FROM" || gitea_conf_set "mailer" "FROM" "$GITEA_SMTP_FROM"
    is_empty_value "$GITEA_SMTP_USER" || gitea_conf_set "mailer" "USER" "$GITEA_SMTP_USER"
    is_empty_value "$GITEA_SMTP_PASSWORD" || gitea_conf_set "mailer" "PASSWD" "$GITEA_SMTP_PASSWORD"
    is_empty_value "$GITEA_LFS_ROOT_PATH" || gitea_conf_set "lfs" "PATH" "$GITEA_LFS_ROOT_PATH"

    is_empty_value "$GITEA_OAUTH2_CLIENT_AUTO_REGISTRATION_ENABLED" || gitea_conf_set "oauth2_client" "ENABLE_AUTO_REGISTRATION" "$GITEA_OAUTH2_CLIENT_AUTO_REGISTRATION_ENABLED"
    is_empty_value "$GITEA_OAUTH2_CLIENT_USERNAME" || gitea_conf_set "oauth2_client" "USERNAME" "$GITEA_OAUTH2_CLIENT_USERNAME"
}

########################
# Set property in the configuration file
# Globals:
#   GITEA_*
# Arguments:
#   $1 - section
#   $2 - key
#   $3 - value
#   $4 - file
# Returns:
#   None
#########################
gitea_conf_set() {
    local -r section="${1}"
    local -r key="${2:?key is required}"
    local -r value="${3:?value is required}"
    local -r file="${4:-${GITEA_CONF_FILE}}"

    debug "Setting ${section:+"${section}."}${key} to '${value}' in Gitea configuration"
    ini-file set --section "$section" --key "$key" --value "$value" "$file"
}

#######################
# Pass Gitea wizard
# Globals:
#   *
# Arguments:
#   None
# Returns:
#   true if the wizard succeeded, false otherwise
#########################
gitea_pass_wizard() {
    local -r port="${GITEA_HTTP_PORT}"
    local wizard_url cookie_file curl_output
    local -a curl_opts curl_data_opts

    info "Running Gitea installation wizard"
    wizard_url="http://127.0.0.1:${port}"
    cookie_file="/tmp/cookie$(generate_random_string -t alphanumeric -c 8)"
    curl_opts=("--location" "--silent" "--cookie" "$cookie_file" "--cookie-jar" "$cookie_file")
    # Ensure gitea is started
    gitea_start_bg
    # Step 0: Get cookies
    debug "Getting cookies"
    curl "${curl_opts[@]}" "$wizard_url" >/dev/null 2>/dev/null
    # Step 1: Install database
    debug "Install"
    curl_data_opts=(
        "--data-urlencode" "db_type=${GITEA_DATABASE_TYPE}"
        "--data-urlencode" "db_host=${GITEA_DATABASE_HOST}:${GITEA_DATABASE_PORT_NUMBER}"
        "--data-urlencode" "db_user=${GITEA_DATABASE_USERNAME}"
        "--data-urlencode" "db_passwd=${GITEA_DATABASE_PASSWORD}"
        "--data-urlencode" "db_name=${GITEA_DATABASE_NAME}"
        "--data-urlencode" "ssl_mode=${GITEA_DATABASE_SSL_MODE}"
        "--data-urlencode" "db_schema=${GITEA_DATABASE_SCHEMA}"
        "--data-urlencode" "charset=${GITEA_DATABASE_CHARSET}"
        "--data-urlencode" "app_name=${GITEA_APP_NAME}"
        "--data-urlencode" "repo_root_path=${GITEA_REPO_ROOT_PATH}"
        "--data-urlencode" "lfs_root_path=${GITEA_LFS_ROOT_PATH}"
        "--data-urlencode" "run_user=${GITEA_DAEMON_USER}"
        "--data-urlencode" "domain=${GITEA_DOMAIN}"
        "--data-urlencode" "ssh_port=${GITEA_SSH_PORT}"
        "--data-urlencode" "http_port=${GITEA_HTTP_PORT}"
        "--data-urlencode" "app_url=${GITEA_ROOT_URL}"
        "--data-urlencode" "log_root_path=${GITEA_LOG_ROOT_PATH}"

        "--data-urlencode" "password_algorithm=${GITEA_PASSWORD_HASH_ALGO}"
        "--data-urlencode" "admin_name=${GITEA_ADMIN_USER}"
        "--data-urlencode" "admin_passwd=${GITEA_ADMIN_PASSWORD}"
        "--data-urlencode" "admin_confirm_passwd=${GITEA_ADMIN_PASSWORD}"
        "--data-urlencode" "admin_email=${GITEA_ADMIN_EMAIL}"
    )
    # Note in version 1.18 SMTP configuration is different
    if is_boolean_yes "${GITEA_SMTP_ENABLED}"; then
        curl_data_opts+=(
            "--data-urlencode" "smtp_addr=${GITEA_SMTP_HOST}"
            "--data-urlencode" "smtp_port=${GITEA_SMTP_PORT}"
            "--data-urlencode" "smtp_from=${GITEA_SMTP_FROM}"
            "--data-urlencode" "smtp_user=${GITEA_SMTP_USER}"
            "--data-urlencode" "smtp_passwd=${GITEA_SMTP_PASSWORD}"
        )
    fi
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "$wizard_url" 2>/dev/null)"
    if [[ "$curl_output" == *"flash-error"* ]]; then
        error "An error occurred while installing Gitea"
        debug "Curl output: $curl_output"
        return 1
    fi
    gitea_stop
    info "Gitea installation finished"
    true
}

########################
# Start Gitea daemon
# Arguments:
#   None
# Returns:
#   None
#########################
gitea_start_bg() {
    local -r log_file="${GITEA_LOG_ROOT_PATH}/boot.log"
    info "Starting Gitea in background"
    is_gitea_running && return
    # This function is meant to be called for internal operations like the init scripts
    local -r cmd=("${GITEA_BASE_DIR}/bin/gitea")
    local -r args=("web" "--config=${GITEA_CONF_FILE}" "--pid=${GITEA_PID_FILE}" "--custom-path=${GITEA_CUSTOM_DIR}" "--work-path=${GITEA_WORK_DIR}")

    if am_i_root; then
        run_as_user "$GITEA_DAEMON_USER" "${cmd[@]}" "${args[@]}" >"$log_file" 2>&1 &
    else
        "${cmd[@]}" "${args[@]}" >"$log_file" 2>&1 &
    fi
    if ! retry_while is_gitea_running; then
        error "Gitea failed to start"
        exit 1
    fi
    wait_for_log_entry "Starting new Web server" "$log_file"
    info "Gitea started successfully"
}

########################
# Check if Gitea is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_gitea_running() {
    pid="$(get_pid_from_file "$GITEA_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if Gitea is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_gitea_not_running() {
    ! is_gitea_running
}

########################
# Stop Gitea
# Arguments:
#   None
# Returns:
#   None
#########################
gitea_stop() {
    ! is_gitea_running && return
    stop_service_using_pid "$GITEA_PID_FILE"
}
