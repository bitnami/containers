#!/bin/bash
#
# Bitnami InfluxDB library

# shellcheck disable=SC1090,SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh

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
export INFLUXDB_HTTP_READINESS_TIMEOUT="${INFLUXDB_HTTP_READINESS_TIMEOUT:-60}"
export INFLUXDB_PORT_NUMBER="${INFLUXDB_PORT_NUMBER:-8088}"
export INFLUXDB_BIND_ADDRESS="${INFLUXDB_BIND_ADDRESS:-0.0.0.0:${INFLUXDB_PORT_NUMBER}}"
export INFLUXDB_PORT_READINESS_TIMEOUT="${INFLUXDB_PORT_READINESS_TIMEOUT:-30}"
# Authentication
export INFLUXDB_ADMIN_USER="${INFLUXDB_ADMIN_USER:-admin}"
export INFLUXDB_ADMIN_CONFIG_NAME="${INFLUXDB_ADMIN_CONFIG_NAME:-default}"
export INFLUXDB_ADMIN_ORG="${INFLUXDB_ADMIN_ORG:-primary}"
export INFLUXDB_ADMIN_BUCKET="${INFLUXDB_ADMIN_BUCKET:-primary}"
export INFLUXDB_ADMIN_RETENTION="${INFLUXDB_ADMIN_RETENTION:-0}"
export INFLUXDB_USER="${INFLUXDB_USER:-}"
export INFLUXDB_USER_ORG="${INFLUXDB_USER_ORG:-${INFLUXDB_ADMIN_ORG}}"
export INFLUXDB_USER_BUCKET="${INFLUXDB_USER_BUCKET:-}"
export INFLUXDB_CREATE_USER_TOKEN="${INFLUXDB_CREATE_USER_TOKEN:-no}"
export INFLUXDB_READ_USER="${INFLUXDB_READ_USER:-}"
export INFLUXDB_WRITE_USER="${INFLUXDB_WRITE_USER:-}"
export INFLUXDB_DB="${INFLUXDB_DB:-}"

# V2 required env vars aliases
export INFLUXD_ENGINE_PATH="${INFLUXDB_VOLUME_DIR}"
export INFLUXD_BOLT_PATH="${INFLUXDB_VOLUME_DIR}/influxd.bolt"
export INFLUXD_CONFIG_PATH="${INFLUXDB_CONF_DIR}/influxdb.conf"
export INFLUX_CONFIGS_PATH="${INFLUXDB_VOLUME_DIR}/configs"

export INFLUXD_HTTP_BIND_ADDRESS="${INFLUXDB_HTTP_BIND_ADDRESS}"

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
    if [[ -f "${INFLUXDB_ADMIN_USER_TOKEN_FILE:-}" ]]; then
        cat <<"EOF"
export INFLUXDB_ADMIN_USER_TOKEN="$(< "${INFLUXDB_ADMIN_USER_TOKEN_FILE}")"
EOF
    else
        cat <<"EOF"
export INFLUXDB_ADMIN_USER_TOKEN="${INFLUXDB_ADMIN_USER_TOKEN:-}"
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
    local -a pwd_file_envs=("INFLUXDB_ADMIN_USER_PASSWORD_FILE" "INFLUXDB_ADMIN_USER_TOKEN_FILE" "INFLUXDB_USER_PASSWORD_FILE")

    for pwd_file in "${pwd_file_envs[@]}"; do
        check_password_file "$pwd_file"
    done

    # InfluxDB authentication validations
    if [[ -z "${INFLUXDB_ADMIN_USER_PASSWORD:-}" ]]; then
        print_validation_error "Primary config authentication is required. Please, specify a password for the ${INFLUXDB_ADMIN_USER} user by setting the 'INFLUXDB_ADMIN_USER_PASSWORD' or 'INFLUXDB_ADMIN_USER_PASSWORD_FILE' environment variables."
    fi
    if [[ -z "${INFLUXDB_ADMIN_USER_TOKEN:-}" ]]; then
        print_validation_error "Primary config authentication is required. Please, specify a token for the ${INFLUXDB_ADMIN_USER} user by setting the 'INFLUXDB_ADMIN_USER_TOKEN' or 'INFLUXDB_ADMIN_USER_TOKEN_FILE' environment variables."
    fi

    if [[ -n "${INFLUXDB_USER:-}" ]] && [[ -z "${INFLUXDB_USER_PASSWORD:-}" ]]; then
        print_validation_error "User authentication is required. Please, specify a password for the ${INFLUXDB_USER} user by setting the 'INFLUXDB_USER_PASSWORD' or 'INFLUXDB_USER_PASSWORD_FILE' environment variables."
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
# Create basic influxdb.conf file using the example provided in the etc/ folder
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
influxdb_create_config() {
    local config_file="${INFLUXD_CONFIG_PATH}"

    if [[ -f "${config_file}" ]]; then
        info "Custom configuration ${INFLUXDB_CONF_FILE} detected!"
        warn "The 'INFLUXDB_' environment variables override the equivalent options in the configuration file."
        warn "If a configuration option is not specified in either the configuration file or in an environment variable, InfluxDB uses its internal default configuration"
    else
        info "No injected configuration files found. Creating default config files..."
        touch "${config_file}"
    fi
}

########################
# Create primary setup
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
influxdb_create_primary_setup() {
    "${INFLUXDB_BIN_DIR}/influx" setup -f --name "${INFLUXDB_ADMIN_CONFIG_NAME}" \
        --org "${INFLUXDB_ADMIN_ORG}" \
        --bucket "${INFLUXDB_ADMIN_BUCKET}" \
        --username "${INFLUXDB_ADMIN_USER}" \
        --password "${INFLUXDB_ADMIN_USER_PASSWORD}" \
        --token "${INFLUXDB_ADMIN_USER_TOKEN}" \
        --retention "${INFLUXDB_ADMIN_RETENTION}"
}

########################
# Create organization
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
influxdb_create_org() {
    INFLUX_ACTIVE_CONFIG="${INFLUXDB_ADMIN_CONFIG_NAME}" "${INFLUXDB_BIN_DIR}/influx" org create --name "${INFLUXDB_USER_ORG}"
}

########################
# Create bucket
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
influxdb_create_bucket() {
    INFLUX_ACTIVE_CONFIG="${INFLUXDB_ADMIN_CONFIG_NAME}" "${INFLUXDB_BIN_DIR}/influx" bucket create \
        "--org" "${INFLUXDB_USER_ORG:-${INFLUXDB_ADMIN_ORG}}" \
        "--name" "${INFLUXDB_USER_BUCKET}"
}

########################
# Create user
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
influxdb_create_user() {
    local username=${1:?missing username}
    local password=${2:?missing password}
    local kind=${3:-"admin"}

    local params=("--org" "${INFLUXDB_USER_ORG:-${INFLUXDB_ADMIN_ORG}}" "--name" "${username}" "--password" "${password}")
    INFLUX_ACTIVE_CONFIG="${INFLUXDB_ADMIN_CONFIG_NAME}" "${INFLUXDB_BIN_DIR}/influx" user create "${params[@]}"

    if is_boolean_yes "${INFLUXDB_CREATE_USER_TOKEN}"; then
        local read_grants=("--read-buckets" "--read-checks" "--read-dashboards" "--read-dbrp" "--read-notificationEndpoints" "--read-notificationRules" "--read-orgs" "--read-tasks")
        local write_grants=("--write-buckets" "--write-checks" "--write-dashboards" "--write-dbrp" "--write-notificationEndpoints" "--write-notificationRules" "--write-orgs" "--write-tasks")

        local -a grants
        if [[ ${kind} = "admin" ]] || [[ ${kind} = "write" ]]; then
            grants+=("${read_grants[@]}" "${write_grants[@]}")
        elif [[ ${kind} = "read" ]]; then
            grants+=("${read_grants[@]}")
        else
            echo "not supported user kind: ${kind}" && exit 1
        fi

        INFLUX_ACTIVE_CONFIG="${INFLUXDB_ADMIN_CONFIG_NAME}" "${INFLUXDB_BIN_DIR}/influx" auth create \
            --user "${username}" \
            --org "${INFLUXDB_USER_ORG:-${INFLUXDB_ADMIN_ORG}}" "${grants[@]}"
    fi
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

    local start_command=("${INFLUXDB_BIN_DIR}/influxd")
    # if root user then run it with gosu
    am_i_root && start_command=("gosu" "$INFLUXDB_DAEMON_USER" "${start_command[@]}")

    INFLUXDB_HTTP_HTTPS_ENABLED=false INFLUXDB_HTTP_BIND_ADDRESS="127.0.0.1:${INFLUXDB_HTTP_PORT_NUMBER}" debug_execute "${start_command[@]}" &

    wait-for-port --timeout="$INFLUXDB_PORT_READINESS_TIMEOUT" "$INFLUXDB_HTTP_PORT_NUMBER"

    wait-for-influxdb
}

########################
# Waits for InfluxDB to be ready
# Times out after 60 seconds
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   None
########################
wait-for-influxdb() {
    curl -sSL -I "127.0.0.1:${INFLUXDB_HTTP_PORT_NUMBER}/ping?wait_for_leader=${INFLUXDB_HTTP_READINESS_TIMEOUT}s" >/dev/null 2>&1
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
    pkill --full --signal TERM "$INFLUXDB_BASE_DIR"
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
    role="${user//_/}"
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
    influxdb_create_config

    if [[ ! -f "${INFLUX_CONFIGS_PATH}" ]]; then
        influxdb_start_bg_noauth
        info "Deploying InfluxDB from scratch"
        info "Creating primary setup..."
        influxdb_create_primary_setup

        if [[ -n "${INFLUXDB_USER_ORG}" ]] && [[ "${INFLUXDB_USER_ORG}" != "${INFLUXDB_ADMIN_ORG}" ]]; then
            info "Creating custom org with id: ${INFLUXDB_USER_ORG}..."
            influxdb_create_org
        fi

        if [[ -n "${INFLUXDB_USER_BUCKET}" ]]; then
            info "Creating custom bucket with id: ${INFLUXDB_USER_BUCKET} in org with id: ${INFLUXDB_USER_ORG:-${INFLUXDB_ADMIN_ORG}}..."
            influxdb_create_bucket
        fi

        if [[ -n "${INFLUXDB_USER}" ]]; then
            info "Creating custom user with username: ${INFLUXDB_USER} in org with id: ${INFLUXDB_USER_ORG:-${INFLUXDB_ADMIN_ORG}}..."
            influxdb_create_user "${INFLUXDB_USER}" "${INFLUXDB_USER_PASSWORD}"
        fi
        if [[ -n "${INFLUXDB_READ_USER}" ]]; then
            info "Creating custom user with username: ${INFLUXDB_READ_USER} in org with id: ${INFLUXDB_USER_ORG:-${INFLUXDB_ADMIN_ORG}}..."
            influxdb_create_user "${INFLUXDB_READ_USER}" "${INFLUXDB_READ_USER_PASSWORD}" "read"
        fi
        if [[ -n "${INFLUXDB_WRITE_USER}" ]]; then
            info "Creating custom user with username: ${INFLUXDB_WRITE_USER} in org with id: ${INFLUXDB_USER_ORG:-${INFLUXDB_ADMIN_ORG}}..."
            influxdb_create_user "${INFLUXDB_WRITE_USER}" "${INFLUXDB_WRITE_USER_PASSWORD}" "write"
        fi
    else
        info "influx CLI configuration ${INFLUXDB_CONF_FILE} detected!"
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
    if [[ -n $(find "${INFLUXDB_INITSCRIPTS_DIR}/" -type f -regex ".*\.\(sh\|txt\)") ]] && [[ ! -f "${INFLUXDB_VOLUME_DIR}/.user_scripts_initialized" ]]; then
        info "Loading user's custom files from ${INFLUXDB_INITSCRIPTS_DIR} ..."
        local -r tmp_file="/tmp/filelist"
        if ! is_influxdb_running; then
            influxdb_start_bg_noauth
        fi
        find "${INFLUXDB_INITSCRIPTS_DIR}/" -type f -regex ".*\.\(sh\|txt\)" | sort >"$tmp_file"
        while read -r f; do
            case "$f" in
            *.sh)
                if [[ -x "$f" ]]; then
                    debug "Executing $f"
                    "$f"
                else
                    debug "Sourcing $f"
                    . "$f"
                fi
                ;;
            *.txt)
                debug "Executing $f"
                influxdb_execute_query "$(<"$f")"
                ;;
            *) debug "Ignoring $f" ;;
            esac
        done <$tmp_file
        rm -f "$tmp_file"
        touch "$INFLUXDB_VOLUME_DIR"/.user_scripts_initialized
    fi
}
