#!/bin/bash
#
# Bitnami InfluxDB library

# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Load Generic Libraries
. /liblog.sh
. /libos.sh
. /libvalidations.sh

# Functions

########################
# Load global variables used on InfluxDB configuration
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
influxdb_env() {
    cat <<"EOF"
# Format log messages
export MODULE="influxdb"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"
# Paths
export INFLUXDB_BASE_DIR="/opt/bitnami/influxdb"
export INFLUXDB_VOLUME_DIR="/bitnami/influxdb"
export INFLUXDB_BIN_DIR="${INFLUXDB_BASE_DIR}/bin"
export INFLUXDB_DATA_DIR="${INFLUXDB_DATA_DIR:-${INFLUXDB_VOLUME_DIR}/data}"
export INFLUXDB_DATA_WAL_DIR="${INFLUXDB_DATA_WAL_DIR:-${INFLUXDB_VOLUME_DIR}/wal}"
export INFLUXDB_META_DIR="${INFLUXDB_META_DIR:-${INFLUXDB_VOLUME_DIR}/meta}"
export INFLUXDB_CONF_DIR="${INFLUXDB_BASE_DIR}/etc"
export INFLUXDB_CONF_FILE="${INFLUXDB_CONF_DIR}/influxdb.conf"
export INFLUXDB_INITSCRIPTS_DIR="/docker-entrypoint-initdb.d"
# Users
export INFLUXDB_DAEMON_USER="influxdb"
export INFLUXDB_DAEMON_GROUP="influxdb"
# InfluxDB settings
export INFLUXDB_REPORTING_DISABLED="${INFLUXDB_REPORTING_DISABLED:-true}"
export INFLUXDB_HTTP_PORT_NUMBER="${INFLUXDB_HTTP_PORT_NUMBER:-8086}"
export INFLUXDB_HTTP_BIND_ADDRESS="${INFLUXDB_HTTP_BIND_ADDRESS:-0.0.0.0:${INFLUXDB_HTTP_PORT_NUMBER}}"
export INFLUXDB_PORT_NUMBER="${INFLUXDB_PORT_NUMBER:-8088}"
export INFLUXDB_BIND_ADDRESS="${INFLUXDB_BIND_ADDRESS:-0.0.0.0:${INFLUXDB_PORT_NUMBER}}"
# Authentication
export INFLUXDB_ADMIN_USER="${INFLUXDB_ADMIN_USER:-admin}"
export INFLUXDB_USER="${INFLUXDB_USER:-}"
export INFLUXDB_READ_USER="${INFLUXDB_READ_USER:-}"
export INFLUXDB_WRITE_USER="${INFLUXDB_WRITE_USER:-}"
export INFLUXDB_DB="${INFLUXDB_DB:-}"
EOF
    # The configuration can be provided in a configuration file or environment variables
    # This setting is necessary to determine certain validations/actions during the
    # initialization, so we need to check the config file when existing.
    if [[ -f "/opt/bitnami/influxdb/etc/influxdb.conf" ]]; then
        cat <<"EOF"
INFLUXDB_HTTP_AUTH_ENABLED="${INFLUXDB_HTTP_AUTH_ENABLED:-$(influxdb_conf_get "auth-enabled")}"
export INFLUXDB_HTTP_AUTH_ENABLED="${INFLUXDB_HTTP_AUTH_ENABLED:-true}"
EOF
    else
    cat <<"EOF"
export INFLUXDB_HTTP_AUTH_ENABLED="${INFLUXDB_HTTP_AUTH_ENABLED:-true}"
EOF
    fi
    # Credentials should be allowed to be mounted as files to avoid sensitive data
    # in the environment variables
    if [[ -f "${INFLUXDB_ADMIN_USER_PASSWORD_FILE:-}" ]]; then
        cat <<"EOF"
export INFLUXDB_ADMIN_USER_PASSWORD="$(< "${INFLUXDB_ADMIN_USER_PASSWORD_FILE}")"
EOF
    else
        cat <<"EOF"
export INFLUXDB_ADMIN_USER_PASSWORD="${INFLUXDB_ADMIN_USER_PASSWORD:-}"
EOF
    fi
    if [[ -f "${INFLUXDB_USER_PASSWORD_FILE:-}" ]]; then
        cat <<"EOF"
export INFLUXDB_USER_PASSWORD="$(< "${INFLUXDB_USER_PASSWORD_FILE}")"
EOF
    else
        cat <<"EOF"
export INFLUXDB_USER_PASSWORD="${INFLUXDB_USER_PASSWORD:-}"
EOF
    fi
    if [[ -f "${INFLUXDB_READ_USER_PASSWORD_FILE:-}" ]]; then
        cat <<"EOF"
export INFLUXDB_READ_USER_PASSWORD="$(< "${INFLUXDB_READ_USER_PASSWORD_FILE}")"
EOF
    else
        cat <<"EOF"
export INFLUXDB_READ_USER_PASSWORD="${INFLUXDB_READ_USER_PASSWORD:-}"
EOF
    fi
    if [[ -f "${INFLUXDB_WRITE_USER_PASSWORD_FILE:-}" ]]; then
        cat <<"EOF"
export INFLUXDB_WRITE_USER_PASSWORD="$(< "${INFLUXDB_WRITE_USER_PASSWORD_FILE}")"
EOF
    else
        cat <<"EOF"
export INFLUXDB_WRITE_USER_PASSWORD="${INFLUXDB_WRITE_USER_PASSWORD:-}"
EOF
    fi
}

########################
# Validate settings in INFLUXDB_* env vars
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
influxdb_validate() {
    local error_code=0
    debug "Validating settings in INFLUXDB_* env vars..."

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }
    check_password_file() {
        if ! is_empty_value "${!1:-}" && ! [[ -f "${!1:-}" ]]; then
            print_validation_error "The variable $1 is defined but the file ${!1} is not accessible or does not exist."
        fi
    }
    check_true_false_value() {
        if ! is_true_false_value "${!1}"; then
            print_validation_error "The allowed values for $1 are [true, false]"
        fi
    }
    check_conflicting_ports() {
        local -r total="$#"
        for i in $(seq 1 "$((total - 1))"); do
            for j in $(seq "$((i + 1))" "$total"); do
                if [[ "${!i}" -eq "${!j}" ]]; then
                    print_validation_error "${!i} and ${!j} are bound to the same port"
                fi
            done
        done
    }

    # InfluxDB secret files validations
    local -a user_envs=("INFLUXDB_ADMIN_USER" "INFLUXDB_USER" "INFLUXDB_READ_USER" "INFLUXDB_WRITE_USER")
    local -a pwd_file_envs=( "${user_envs[@]/%/_PASSWORD_FILE}" )
    for pwd_file in "${pwd_file_envs[@]}"; do
        check_password_file "$pwd_file"
    done

    # InfluxDB booleans validations
    read -r -a boolean_envs <<< "$(compgen -A variable | grep -E "INFLUXDB_.*_(ENABLED|DISABLED)" | tr '\r\n' ' ')"
    for boolean_env in "${boolean_envs[@]}"; do
        check_true_false_value "$boolean_env"
    done

    # InfluxDB authentication validations
    if ! is_boolean_yes "$INFLUXDB_HTTP_AUTH_ENABLED"; then
        warn "Authentication is disabled over HTTP and HTTPS. For safety reasons, enable it in a production environment."
        for user in "${user_envs[@]}"; do
            if [[ -n "${!user:-}" ]]; then
                warn "The ${user} environment variable will be ignored since authentication is disabled."
            fi
        done
    else
        for user in "${user_envs[@]}"; do
            pwd="${user/%/_PASSWORD}"
            if [[ -n "${!user:-}" ]] && [[ -z "${!pwd:-}" ]]; then
                print_validation_error "Authentication is enabled over HTTP and HTTPS and you did not provide a password for the ${!user} user. Please, specify a password for the ${!user} user by setting the '${user/%/_PASSWORD}' or '${user/%/_PASSWORD_FILE}' environment variables."
            fi
        done
    fi

    # InfluxDB port validations
    local -a ports_envs=("INFLUXDB_PORT_NUMBER" "INFLUXDB_HTTP_PORT_NUMBER")
    for p in "${ports_envs[@]}"; do
        if ! is_empty_value "${!p}" && ! err=$(validate_port -unprivileged "${!p}"); then
            print_validation_error "An invalid port was specified in the environment variable ${p}: ${err}"
        fi
    done
    check_conflicting_ports "${ports_envs[@]}"

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Get a property's value from the the influxdb.conf file
# Globals:
#   INFLUXDB_*
# Arguments:
#   $1 - key
#   $2 - section
# Returns:
#   None
#########################
# TODO: use a golan binary (toml-parser)
influxdb_conf_get() {
    local -r key="${1:?missing key}"
#     local -r section="${2:?missing section}"

    sed -n -e "s/^ *$key *= *//p" "$INFLUXDB_CONF_FILE"
#     toml-parser -r "$section" "$key" "$INFLUXDB_CONF_FILE"
}

########################
# Modify the influxdb.conf file by setting a property
# Globals:
#   INFLUXDB_*
# Arguments:
#   $1 - section
#   $2 - key
#   $3 - value
# Returns:
#   None
#########################
# TODO: use a golan binary (toml-parser) to perform these substitutions
# influxdb_conf_set() {
#     local -r section="${1:?missing section}"
#     local -r key="${2:?missing key}"
#     local -r value="${2:-}"
#
#     toml-parser -w "$section" "$key" "$value" "$INFLUXDB_CONF_FILE"
# }

########################
# Create basic influxdb.conf file using the example provided in the etc/ folder
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
influxdb_create_config() {
    cp "${INFLUXDB_CONF_DIR}/influxdb.conf.default" "$INFLUXDB_CONF_FILE"

    # TODO: use a golan binary (toml-parser) to perform these substitutions
    # These settings:
    # - [meta] dir
    # - [data] dir
    # - [data] wal-dir
    # will be ignored and the values at the environment variables below will be used instead:
    # - INFLUXDB_META_DIR
    # - INFLUXDB_DATA_DIR
    # - INFLUXDB_DATA_WAL_DIR
    # However, to avoid confussion for users checking the configuration file,
    # we'll update them to reflec the same values.
    # influxdb_set_property "meta" "dir" "$INFLUXDB_META_DIR"
    # influxdb_set_property "data" "dir" "$INFLUXDB_DATA_DIR"
    # influxdb_set_property "data" "wal-dir" "$INFLUXDB_DATA_WAL_DIR"
}

########################
# Start InfluxDB in background disabling authentication and waits until it's ready
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
influxdb_start_bg_noauth() {
    info "Starting InfluxDB in background..."
    local start_command=("${INFLUXDB_BIN_DIR}/influxd" "-config" "$INFLUXDB_CONF_FILE")
    am_i_root && start_command=("gosu" "$INFLUXDB_DAEMON_USER" "${start_command[@]}")
    INFLUXDB_HTTP_HTTPS_ENABLED=false INFLUXDB_HTTP_BIND_ADDRESS="127.0.0.1:${INFLUXDB_HTTP_PORT_NUMBER}" debug_execute "${start_command[@]}" &
    wait-for-port "$INFLUXDB_PORT_NUMBER"
}

########################
# Check if InfluxDB is running
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_influxdb_running() {
    if pgrep "influxd" >/dev/null 2>&1; then
        true
    else
        false
    fi
}

########################
# Stop InfluxDB
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
influxdb_stop() {
    info "Stopping InfluxDB..."
    ! is_influxdb_running && return
    pkill --full --signal TERM "influxd"
    wait-for-port --state free "$INFLUXDB_PORT_NUMBER"
}

########################
# Execute an arbitrary query using InfluxDB CLI
# Globals:
#   INFLUXDB_*
# Arguments:
#   $1 - Query to execute
#   $2 - Whether to use admin credentials to run the command or not
# Returns:
#   None
#########################
influxdb_execute_query() {
    local -r query="${1:-query is required}"
    local authenticate="${2:-false}"
    local flags=("-host" "127.0.0.1" "-port" "$INFLUXDB_HTTP_PORT_NUMBER")

    is_boolean_yes "$authenticate" && flags+=("-username" "${INFLUXDB_ADMIN_USER}" "-password" "${INFLUXDB_ADMIN_USER_PASSWORD}")
    debug_execute "${INFLUXDB_BIN_DIR}/influx" "${flags[@]}" "-execute" "$query"
}

########################
# Creates the admin user
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
influxdb_create_admin_user() {
    debug "Creating admin user..."
    influxdb_execute_query "CREATE USER \"${INFLUXDB_ADMIN_USER}\" WITH PASSWORD '${INFLUXDB_ADMIN_USER_PASSWORD}' WITH ALL PRIVILEGES"
}

########################
# Creates a database
# Globals:
#   INFLUXDB_*
# Arguments:
#   $1  - Database name
# Returns:
#   None
#########################
influxdb_create_db() {
    local -r db="${1:?db is required}"
    debug "Creating database \"${db}\"..."
    influxdb_execute_query "CREATE DATABASE ${db}" "true"
}

########################
# Creates an user
# Globals:
#   INFLUXDB_*
# Arguments:
#   $1  - User name
#   $2  - User password
# Returns:
#   None
#########################
influxdb_create_user() {
    local -r user="${1:?user is required}"
    local -r pwd="${2:?pwd is required}"
    debug "Creating user \"${user}\"..."
    influxdb_execute_query "CREATE USER \"${user}\" WITH PASSWORD '${pwd}'" "true"
    influxdb_execute_query "REVOKE ALL PRIVILEGES FROM \"${user}\"" "true"
}

########################
# Creates a database
# Globals:
#   INFLUXDB_*
# Arguments:
#   $1  - User name
#   $2  - Database name
#   $3  - Role
# Returns:
#   None
#########################
influxdb_grant() {
    local -r user="${1:?user is required}"
    local -r db="${2:?db is required}"
    local -r role="${3:?role is required}"
    debug "Granting \"${role}\" permissions to user ${user} on database \"${db}\"..."
    influxdb_execute_query "GRANT ${role} ON \"${db}\" TO \"${user}\"" "true"
}

########################
# Gets the role for an user
# Arguments:
#   $1 - user
# Returns:
#   String
#########################
influxdb_user_role() {
    local role
    local -r user="${1:?user is required}"
    role="${user//_}"
    role="${role%USER}"
    role="${role#INFLUXDB}"
    echo "${role:-ALL}"
}

########################
# Ensure InfluxDB is initialized
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
influxdb_initialize() {
    info "Initializing InfluxDB..."

    # Detect custom configuration files
    if [[ -f "$INFLUXDB_CONF_FILE" ]]; then
        info "Custom configuration ${INFLUXDB_CONF_FILE} detected!"
        warn "The 'INFLUXDB_' environment variables override the equivalent options in the configuration file."
        warn "If a configuration option is not specified in either the configuration file or in an environment variable, InfluxDB uses its internal default configuration"
    else
        info "No injected configuration files found. Creating default config files..."
        influxdb_create_config
    fi

    if is_dir_empty "$INFLUXDB_DATA_DIR"; then
        info "Deploying InfluxDB from scratch"
        if is_boolean_yes "$INFLUXDB_HTTP_AUTH_ENABLED"; then
            influxdb_start_bg_noauth
            info "Creating users and databases..."
            influxdb_create_admin_user
            [[ -n "$INFLUXDB_DB" ]] && influxdb_create_db "$INFLUXDB_DB"
            local -a user_envs=("INFLUXDB_USER" "INFLUXDB_READ_USER" "INFLUXDB_WRITE_USER")
            for user in "${user_envs[@]}"; do
                pwd="${user/%/_PASSWORD}"
                if [[ -n "${!user}" ]]; then
                    influxdb_create_user "${!user}" "${!pwd}"
                    [[ -n "$INFLUXDB_DB" ]] && influxdb_grant "${!user}" "$INFLUXDB_DB" "$(influxdb_user_role "$user")"
                fi
            done
        fi
    else
        info "Deploying InfluxDB with persisted data"
    fi
}

########################
# Run custom initialization scripts
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
influxdb_custom_init_scripts() {
    if [[ -n $(find "${INFLUXDB_INITSCRIPTS_DIR}/" -type f -regex ".*\.\(sh\|txt\)") ]] && [[ ! -f "${INFLUXDB_INITSCRIPTS_DIR}/.user_scripts_initialized" ]] ; then
        info "Loading user's custom files from ${INFLUXDB_INITSCRIPTS_DIR} ..."
        local -r tmp_file="/tmp/filelist"
        if ! is_influxdb_running; then
            influxdb_start_bg_noauth
        fi
        find "${INFLUXDB_INITSCRIPTS_DIR}/" -type f -regex ".*\.\(sh\|txt\)" | sort > "$tmp_file"
        while read -r f; do
            case "$f" in
                *.sh)
                    if [[ -x "$f" ]]; then
                        debug "Executing $f"; "$f"
                    else
                        debug "Sourcing $f"; . "$f"
                    fi
                    ;;
                *.txt)    debug "Executing $f"; influxdb_execute_query "$(<"$f")";;
                *)        debug "Ignoring $f" ;;
            esac
        done < $tmp_file
        rm -f "$tmp_file"
        touch "$INFLUXDB_VOLUME_DIR"/.user_scripts_initialized
    fi
}
