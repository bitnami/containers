#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Ghost library

# shellcheck disable=SC1091

# Load generic libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libpersistence.sh
. /opt/bitnami/scripts/libservice.sh

# Load database library
if [[ -f /opt/bitnami/scripts/libmysqlclient.sh ]]; then
    . /opt/bitnami/scripts/libmysqlclient.sh
elif [[ -f /opt/bitnami/scripts/libmysql.sh ]]; then
    . /opt/bitnami/scripts/libmysql.sh
elif [[ -f /opt/bitnami/scripts/libmariadb.sh ]]; then
    . /opt/bitnami/scripts/libmariadb.sh
fi

########################
# Check if Ghost is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_ghost_running() {
    local pid

    pgrep -f "^ghost" >"$GHOST_PID_FILE"
    pid="$(get_pid_from_file "$GHOST_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if Ghost is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_ghost_not_running() {
    ! is_ghost_running
}

########################
# Stop Ghost
# Arguments:
#   None
# Returns:
#   None
#########################
ghost_stop() {
    is_ghost_not_running && return

    info "Stopping Ghost"
    cd "$GHOST_BASE_DIR" || return 1
    if am_i_root; then
        debug_execute run_as_user "$GHOST_DAEMON_USER" ghost stop
    else
        debug_execute ghost stop
    fi
}

########################
# Start Ghost in background
# Arguments:
#   None
# Returns:
#   None
#########################
ghost_start_bg() {
    is_ghost_running && return

    info "Starting Ghost in background"
    cd "$GHOST_BASE_DIR" || return 1
    if am_i_root; then
        touch "$GHOST_LOG_FILE"
        configure_permissions_ownership "$GHOST_LOG_FILE" -u "$GHOST_DAEMON_USER" -g "$GHOST_DAEMON_GROUP"
        run_as_user "$GHOST_DAEMON_USER" ghost start --no-enable >>"$GHOST_LOG_FILE" 2>&1
    else
        ghost start --no-enable >>"$GHOST_LOG_FILE" 2>&1
    fi
    wait_for_log_entry "Your admin interface is located at" "$GHOST_LOG_FILE"
    sleep 5
}

########################
# Validate settings in GHOST_* env vars
# Globals:
#   GHOST_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
ghost_validate() {
    debug "Validating settings in GHOST_* environment variables..."
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
    check_valid_port() {
        local port_var="${1:?missing port variable}"
        local err
        if ! err="$(validate_port "${!port_var}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
        fi
    }

    # Validate user inputs
    check_empty_value "GHOST_HOST"
    ! is_empty_value "$GHOST_ENABLE_HTTPS" && check_yes_no_value "GHOST_ENABLE_HTTPS"
    ! is_empty_value "$GHOST_SKIP_BOOTSTRAP" && check_yes_no_value "GHOST_SKIP_BOOTSTRAP"
    ! is_empty_value "$GHOST_DATABASE_HOST" && check_resolved_hostname "$GHOST_DATABASE_HOST"
    ! is_empty_value "$GHOST_DATABASE_PORT_NUMBER" && check_valid_port "GHOST_DATABASE_PORT_NUMBER"

    # Validate SSL configuration
    ! is_empty_value "$GHOST_DATABASE_ENABLE_SSL" && check_yes_no_value "GHOST_DATABASE_ENABLE_SSL"

    # Validate credentials
    check_empty_value "GHOST_PASSWORD"
    # ref: https://github.com/TryGhost/Ghost/issues/9150
    if ((${#GHOST_PASSWORD} < 10)); then
        print_validation_error "The admin password must be at least 10 characters long. Set the environment variable GHOST_PASSWORD with a longer value"
    fi
    if is_boolean_yes "${ALLOW_EMPTY_PASSWORD:-}"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD:-}. For safety reasons, do not use this flag in a production environment."
    else
        is_empty_value "$GHOST_DATABASE_PASSWORD" && print_validation_error "The GHOST_DATABASE_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
    fi

    # Validate SMTP credentials
    if ! is_empty_value "$GHOST_SMTP_HOST"; then
        for empty_env_var in "GHOST_SMTP_USER" "GHOST_SMTP_PASSWORD"; do
            is_empty_value "${!empty_env_var}" && warn "The ${empty_env_var} environment variable is empty or not set."
        done
        is_empty_value "$GHOST_SMTP_PORT_NUMBER" && print_validation_error "The GHOST_SMTP_PORT_NUMBER environment variable is empty or not set."
        ! is_empty_value "$GHOST_SMTP_PORT_NUMBER" && check_valid_port "GHOST_SMTP_PORT_NUMBER"
        ! is_empty_value "$GHOST_SMTP_PROTOCOL" && check_multi_value "GHOST_SMTP_PROTOCOL" "ssl tls"
    fi

    return "$error_code"
}

########################
# Add or modify an entry in the Ghost configuration file
# Globals:
#   GHOST_*
# Arguments:
#   $1 - Variable name
#   $2 - Value to assign to the variable
#   $3 - YAML type (string, int, bool or json)
# Returns:
#   None
#########################
ghost_conf_set() {
    local -r key="${1:?Missing key}"
    local -r value="${2:-}"
    local -r type="${3:-string}"
    local -r tempfile=$(mktemp)

    case "$type" in
    string)
        jq "(.${key}) |= \"${value}\"" "$GHOST_CONF_FILE" > "$tempfile"
        ;;
    int)
        jq "(.${key}) |= (${value} | tonumber)" "$GHOST_CONF_FILE" > "$tempfile"
        ;;
    bool)
        jq "(.${key}) |= (\"${value}\" | test(\"true\"))" "$GHOST_CONF_FILE" > "$tempfile"
        ;;
    json)
        jq "(.${key}) |= ${value}" "$GHOST_CONF_FILE" > "$tempfile"
        ;;
    *)
        error "Type unknown: ${type}"
        return 1
        ;;
    esac
    cp "$tempfile" "$GHOST_CONF_FILE"
}

########################
# Get an entry from the Parse configuration file
# Globals:
#   GHOST_*
# Arguments:
#   $1 - Variable name
# Returns:
#   None
#########################
ghost_conf_get() {
    local -r key="${1:?key missing}"
    debug "Getting ${key} from Ghost configuration"
    jq -r ".${key}" "$GHOST_CONF_FILE"
}

########################
# Ensure Ghost is initialized
# Globals:
#   GHOST_*
# Arguments:
#   None
# Returns:
#   None
#########################
ghost_initialize() {
    # Check if Ghost has already been initialized and persisted in a previous run
    local -r app_name="ghost"
    local -r port="${GHOST_PORT_NUMBER:-"$GHOST_DEFAULT_PORT_NUMBER"}"

    if ! is_app_initialized "$app_name"; then
        # Ensure Ghost persisted directories exist (i.e. when a volume has been mounted to /bitnami)
        info "Ensuring Ghost directories exist"
        ensure_dir_exists "$GHOST_VOLUME_DIR"
        # Use ghost:root ownership for compatibility when running as a non-root user
        am_i_root && configure_permissions_ownership "$GHOST_VOLUME_DIR" -d "775" -f "664" -u "$GHOST_DAEMON_USER" -g "root"
        info "Trying to connect to the database server"
        ghost_wait_for_mysql_connection "$GHOST_DATABASE_HOST" "$GHOST_DATABASE_PORT_NUMBER" "$GHOST_DATABASE_NAME" "$GHOST_DATABASE_USER" "$GHOST_DATABASE_PASSWORD"
        # Configure database
        info "Configuring database"
        jq -n -r \
            --arg host "$GHOST_DATABASE_HOST" \
            --arg port "$GHOST_DATABASE_PORT_NUMBER" \
            --arg database "$GHOST_DATABASE_NAME" \
            --arg user "$GHOST_DATABASE_USER" \
            --arg password "$GHOST_DATABASE_PASSWORD" \
            '{
              "database": {
                "client": "mysql",
                "connection": {
                  host: $host,
                  port: $port|tonumber,
                  database: $database,
                  user: $user,
                  password: $password,
                  ssl: false
                }
              }
            }' > "$GHOST_CONF_FILE"

        if ! is_empty_value "$GHOST_DATABASE_SSL_CA_FILE"; then
            ca_json="{\"ca\": \"$(cat "${GHOST_DATABASE_SSL_CA_FILE}")\"}"
            ghost_conf_set "database.connection.ssl" "$ca_json" "json"
        elif is_boolean_yes "$GHOST_DATABASE_ENABLE_SSL"; then
            ghost_conf_set "database.connection.ssl" true "bool"
        fi

        am_i_root && chown "${GHOST_DAEMON_USER}:root" "$GHOST_CONF_FILE"
        if ! is_boolean_yes "$GHOST_SKIP_BOOTSTRAP"; then
            # Setup Ghost
            # ref: https://ghost.org/docs/ghost-cli/#ghost-setup
            info "Setting up Ghost"
            cd "$GHOST_BASE_DIR" || false
            local base_url
            base_url="$(ghost_base_url "$GHOST_HOST")"
            local -a setup_flags=(
                "--no-setup-ssl" "--no-setup-nginx" "--no-setup-mysql"
                "--no-setup-systemd" "--no-setup-linux-user"
                "--url" "$base_url"
                "--ip" "0.0.0.0"
                "--port" "$port"
                "--log" "file"
                "--process" "local" "--no-prompt" "--no-start" "--no-enable"
            )
            if am_i_root; then
                debug_execute run_as_user "$GHOST_DAEMON_USER" ghost setup "${setup_flags[@]}"
            else
                debug_execute ghost setup "${setup_flags[@]}"
            fi
            # Configure Host
            ghost_configure_host "$GHOST_HOST"
            # Configure smtp
            # https://ghost.org/docs/config/#mail
            if ! is_empty_value "$GHOST_SMTP_HOST"; then
                info "Configuring SMTP settings"
                ghost_conf_set "mail.from" "$GHOST_SMTP_FROM_ADDRESS"
                ghost_conf_set "mail.transport" "SMTP"
                ghost_conf_set "mail.options.host" "$GHOST_SMTP_HOST"
                ghost_conf_set "mail.options.port" "$GHOST_SMTP_PORT_NUMBER" "int"
                ghost_conf_set "mail.options.secure" "$([[ "$GHOST_SMTP_PROTOCOL" = "ssl" || "$GHOST_SMTP_PROTOCOL" = "tls" ]] && echo "true" || echo "false")" "bool"
                ghost_conf_set "mail.options.auth.user" "$GHOST_SMTP_USER"
                ghost_conf_set "mail.options.auth.pass" "$GHOST_SMTP_PASSWORD"
            fi
            # Configure Admin account
            ghost_pass_wizard
            mv "$GHOST_LOG_FILE" "${GHOST_BASE_DIR}/content/logs/ghost.setup.log"
        else
            info "An already initialized Ghost database was provided, configuration will be skipped"
        fi

        info "Persisting Ghost installation"
        persist_app "$app_name" "$GHOST_DATA_TO_PERSIST"
    else
        info "Restoring persisted Ghost installation"
        restore_persisted_app "$app_name" "$GHOST_DATA_TO_PERSIST"
        info "Trying to connect to the database server"
        local db_host db_port db_name db_user db_pass
        db_host="$(ghost_conf_get "database.connection.host")"
        db_port="$(ghost_conf_get "database.connection.port")"
        db_name="$(ghost_conf_get "database.connection.database")"
        db_user="$(ghost_conf_get "database.connection.user")"
        db_pass="$(ghost_conf_get "database.connection.password")"
        ghost_wait_for_mysql_connection "$db_host" "$db_port" "$db_name" "$db_user" "$db_pass"
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
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
ghost_wait_for_mysql_connection() {
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
# Create Ghost user and set Ghost blog title passing the wizard
# Globals:
#   GHOST_*
# Arguments:
#   None
# Returns:
#   true if the wizard succeeded, false otherwise
#########################
ghost_pass_wizard() {
    local -r port="${GHOST_PORT_NUMBER:-"$GHOST_DEFAULT_PORT_NUMBER"}"
    local wizard_url curl_output
    local -a curl_opts curl_data_opts

    info "Passing admin user creation wizard"
    # Ghost API reference: https://ghost.org/docs/admin-api/
    wizard_url="http://127.0.0.1:${port}/ghost/api/v3/admin/authentication/setup/"
    curl_opts=(
        "--silent"
        "-H" "Content-Type: application/json"
        "-H" "Cache-Control: no-cache"
    )
    # Ensure Ghost is started
    ghost_start_bg
    # User creation & Blog Title configuration
    data="$(
        jq '.' <<EOF
{
  "setup": [{
    "name": "${GHOST_USERNAME}",
    "email": "${GHOST_EMAIL}",
    "password": "${GHOST_PASSWORD}",
    "blogTitle": "${GHOST_BLOG_TITLE}"
  }]
}
EOF
    )"
    curl_data_opts=(
        "--data" "$data"
    )
    curl_output="$(curl "${curl_opts[@]}" "${curl_data_opts[@]}" "${wizard_url}" 2>/dev/null)"
    debug_execute echo "$curl_output"
    if [[ "$curl_output" != *"\"id\":\"1\",\"name\":\"${GHOST_USERNAME}\""* ]]; then
        error "An error occurred while installing Ghost"
        return 1
    fi
    # Stop Ghost afterwards
    ghost_stop
}

#########################
# Returns Ghost base URL
# Globals:
#   GHOST_*
# Arguments:
#   $1 - host
# Returns:
#   String
#########################
ghost_base_url() {
    local host="${1:?missing host}"
    local scheme

    if is_boolean_yes "$GHOST_ENABLE_HTTPS"; then
        scheme="https"
        [[ "$GHOST_EXTERNAL_HTTPS_PORT_NUMBER" != "443" ]] && host+=":${GHOST_EXTERNAL_HTTPS_PORT_NUMBER}"
    else
        scheme="http"
        [[ "$GHOST_EXTERNAL_HTTP_PORT_NUMBER" != "80" ]] && host+=":${GHOST_EXTERNAL_HTTP_PORT_NUMBER}"
    fi
    echo "${scheme}://${host}"
}

#########################
# Configure Ghost host
# Globals:
#   GHOST_*
# Arguments:
#   $1 - host
# Returns:
#   None
#########################
ghost_configure_host() {
    local -r host="${1:?missing host}"
    local base_url

    base_url="$(ghost_base_url "$host")"
    info "Configuring Ghost URL to ${base_url}"
    ghost_conf_set "url" "$base_url"
}
