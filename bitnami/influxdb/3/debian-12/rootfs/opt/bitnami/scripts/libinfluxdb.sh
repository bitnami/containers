#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami InfluxDB library

# shellcheck disable=SC1090,SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libversion.sh

# Functions

########################
# Returns true if InfluxDB version is 3.x
# Globals:
#   None
# Arguments:
#   None
# Returns:
#   true/false
#########################
is_influxdb_3() {
    [[ -z "${APP_VERSION:-}" ]] && return 0
    local -r major_version="$(get_sematic_version "$APP_VERSION" 1)"
    if [[ "$major_version" -eq 3 ]]; then
        return 0
    fi
    return 1
}

########################
# Returns full path to InfluxDB binary
# Globals:
#   INFLUXDB_BIN_DIR
# Arguments:
#   None
# Returns:
#   Path to InfluxDB binary
#########################
influxdb_binary() {
    if is_influxdb_3; then
        echo "${INFLUXDB_BIN_DIR}/influxdb3"
    else
        echo "${INFLUXDB_BIN_DIR}/influxd"
    fi
}

########################
# Returns full path to InfluxDB CLI binary
# Globals:
#   INFLUXDB_BIN_DIR
# Arguments:
#   None
# Returns:
#   Path to InfluxDB CLI binary
#########################
influxdb_cli_binary() {
    if is_influxdb_3; then
        echo "${INFLUXDB_BIN_DIR}/influxdb3"
    else
        echo "${INFLUXDB_BIN_DIR}/influx"
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
        if ! err="$(validate_port -unprivileged "${!port_var}")"; then
            print_validation_error "An invalid port was specified in the environment variable ${port_var}: ${err}."
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

    # Boolean validations
    check_yes_no_value "INFLUXDB_HTTP_AUTH_ENABLED"

    if is_influxdb_3; then
        check_yes_no_value "INFLUXDB_CREATE_ADMIN_TOKEN"
        if [[ -z "$INFLUXDB_NODE_ID" ]]; then
            print_validation_error "Node ID is required. Please, specify it by setting the 'INFLUXDB_NODE_ID' environment variable."
        fi
        if [[ -z "$INFLUXDB_OBJECT_STORE" ]]; then
            print_validation_error "Object store is required. Please, specify it by setting the 'INFLUXDB_OBJECT_STORE' environment variable."
        fi
        # InfluxDB 3.x authentication validations
        if is_boolean_yes "$INFLUXDB_HTTP_AUTH_ENABLED" && is_boolean_yes "$INFLUXDB_CREATE_ADMIN_TOKEN"; then
            if [[ -n "${INFLUXDB_ADMIN_TOKEN:-}" ]]; then
               print_validation_error "The 'INFLUXDB_ADMIN_TOKEN' environment variable is not needed when 'INFLUXDB_CREATE_ADMIN_TOKEN' is set to 'yes'."
            elif [[ "$INFLUXDB_OBJECT_STORE" =~ memory ]]; then
                print_validation_error "No admin token can be created during initialization when using memory object store. Please, ensure 'INFLUXDB_CREATE_ADMIN_TOKEN' is set to 'no'."
            fi
        elif is_boolean_yes "$INFLUXDB_HTTP_AUTH_ENABLED" && [[ "$INFLUXDB_OBJECT_STORE" =~ memory ]] && [[ -n "${INFLUXDB_DATABASES:-}" ]]; then
            print_validation_error "No databases can be created during initialization when using memory object store. Please, ensure 'INFLUXDB_DATABASES' is not set."
        elif is_boolean_yes "$INFLUXDB_HTTP_AUTH_ENABLED" && [[ -z "${INFLUXDB_ADMIN_TOKEN:-}" ]] && [[ -n "${INFLUXDB_DATABASES:-}" ]]; then
            print_validation_error "No admin token to be created during initialization nor provided, hence, no databases can be created. Please, specify the token by setting the 'INFLUXDB_ADMIN_TOKEN' or 'INFLUXDB_ADMIN_TOKEN_FILE' environment variables."
        elif is_boolean_yes "$INFLUXDB_HTTP_AUTH_ENABLED" && [[ -z "${INFLUXDB_ADMIN_TOKEN:-}" ]]; then
            warn "No admin token to be created during initialization, manually creating it will be required to interact with the InfluxDB API."
        fi
    else
        # InfluxDB 2.x authentication validations
        check_yes_no_value "INFLUXDB_CREATE_USER_TOKEN" "INFLUXDB_REPORTING_DISABLED"
        if [[ -z "${INFLUXDB_ADMIN_USER_PASSWORD:-}" ]]; then
            print_validation_error "Admin authentication is required. Please, specify a password for the ${INFLUXDB_ADMIN_USER} user by setting the 'INFLUXDB_ADMIN_USER_PASSWORD' or 'INFLUXDB_ADMIN_USER_PASSWORD_FILE' environment variables."
        fi
        if [[ -z "${INFLUXDB_ADMIN_USER_TOKEN:-}" ]]; then
            warn "No admin token provided. Notice some internal features require it, like performing HTTP API requests."
            warn "A token for the ${INFLUXDB_ADMIN_USER} user can be provided by setting the 'INFLUXDB_ADMIN_USER_TOKEN' or 'INFLUXDB_ADMIN_USER_TOKEN_FILE' environment variables."
        fi
        if [[ -n "${INFLUXDB_USER:-}" ]] && [[ -z "${INFLUXDB_USER_PASSWORD:-}" ]]; then
            print_validation_error "User authentication is required. Please, specify a password for the ${INFLUXDB_USER} user by setting the 'INFLUXDB_USER_PASSWORD' or 'INFLUXDB_USER_PASSWORD_FILE' environment variables."
        fi
        # InfluxDB 1.x to 2.x upgrade validations
        check_multi_value "INFLUXDB_INIT_MODE" "setup upgrade"
        if [[ "$INFLUXDB_INIT_MODE" = "upgrade" ]] && [[ -n "${INFLUXDB_INIT_V1_DIR:-}" ]] && [[ -z "${INFLUXDB_INIT_V1_CONFIG:-}" ]]; then
            print_validation_error "InfluxDB 1.x data not found. Please, specify its location by setting the 'INFLUXDB_INIT_V1_DIR' or 'INFLUXDB_INIT_V1_CONFIG' environment variables."
        fi
        # Validate InfluxDB 2.x configuration file format
        [[ -n "${INFLUXDB_CONF_FILE_FORMAT:-}" ]] && check_multi_value "INFLUXDB_CONF_FILE_FORMAT" "yaml json yml toml"
    fi

    # InfluxDB port validations
    local -a ports_envs=("INFLUXDB_HTTP_PORT_NUMBER")
    ! is_influxdb_3 && ports_envs+=("INFLUXDB_PORT_NUMBER")
    for p in "${ports_envs[@]}"; do
        check_valid_port "$p"
    done
    check_conflicting_ports "${ports_envs[@]}"

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
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
    local config_file="${INFLUXDB_CONF_FILE}"

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
    local -a args=(
        --force
        --name "${INFLUXDB_ADMIN_CONFIG_NAME}"
        --org "${INFLUXDB_ADMIN_ORG}"
        --bucket "${INFLUXDB_ADMIN_BUCKET}"
        --username "${INFLUXDB_ADMIN_USER}"
        --password "${INFLUXDB_ADMIN_USER_PASSWORD}"
        --retention "${INFLUXDB_ADMIN_RETENTION}"
    )

    if [ -n "${INFLUXDB_ADMIN_USER_TOKEN}" ]; then
        args+=('--token' "${INFLUXDB_ADMIN_USER_TOKEN}")
    fi

    local setup_command=("$(influxdb_cli_binary)" setup "${args[@]}")
    am_i_root && setup_command=("run_as_user" "$INFLUXDB_DAEMON_USER" "${setup_command[@]}")
    debug_execute "${setup_command[@]}"
}

########################
# Upgrade V1 data into the V2 format
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
influxdb_run_upgrade() {
    local -a args=(
        --force
        --org "${INFLUXDB_ADMIN_ORG}"
        --bucket "${INFLUXDB_ADMIN_BUCKET}"
        --username "${INFLUXDB_ADMIN_USER}"
        --password "${INFLUXDB_ADMIN_USER_PASSWORD}"
        --retention "${INFLUXDB_ADMIN_RETENTION}"
        --v2-config-path "${INFLUXDB_CONF_FILE}"
        --influx-configs-path "${INFLUX_CONFIGS_PATH}"
        --continuous-query-export-path "${INFLUXDB_CONTINUOUS_QUERY_EXPORT_FILE}"
        --log-path "${INFLUXDB_UPGRADE_LOG_FILE}"
        --bolt-path "${INFLUXD_BOLT_PATH}"
        --engine-path "${INFLUXD_ENGINE_PATH}"
        --v1-dir "${INFLUXDB_INIT_V1_DIR}"
    )

    if [ -n "${INFLUXDB_ADMIN_USER_TOKEN}" ]; then
        args+=('--token' "${INFLUXDB_ADMIN_USER_TOKEN}")
    fi

    local logLevel="info"
    is_boolean_yes "${BITNAMI_DEBUG}" && logLevel="debug"
    args+=('--log-level' "${logLevel}")


    local upgrade_command=("$(influxdb_binary)" upgrade "${args[@]}")
    am_i_root && upgrade_command=("run_as_user" "$INFLUXDB_DAEMON_USER" "${upgrade_command[@]}")
    debug_execute "${upgrade_command[@]}"
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
    INFLUX_ACTIVE_CONFIG="${INFLUXDB_ADMIN_CONFIG_NAME}" "$(influxdb_cli_binary)" org create --name "${INFLUXDB_USER_ORG}"
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
    INFLUX_ACTIVE_CONFIG="${INFLUXDB_ADMIN_CONFIG_NAME}" "$(influxdb_cli_binary)" bucket create \
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
    INFLUX_ACTIVE_CONFIG="${INFLUXDB_ADMIN_CONFIG_NAME}" "$(influxdb_cli_binary)" user create "${params[@]}"

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

        INFLUX_ACTIVE_CONFIG="${INFLUXDB_ADMIN_CONFIG_NAME}" "$(influxdb_cli_binary)" auth create \
            --user "${username}" \
            --org "${INFLUXDB_USER_ORG:-${INFLUXDB_ADMIN_ORG}}" "${grants[@]}"
    fi
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
wait_for_influxdb() {
    curl -sSL -I "127.0.0.1:${INFLUXDB_HTTP_PORT_NUMBER}/ping?wait_for_leader=${INFLUXDB_HTTP_READINESS_TIMEOUT}s" >/dev/null 2>&1
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
influxdb_start_bg() {
    is_influxdb_running && return

    info "Starting InfluxDB in background..."
    local start_command=("$(influxdb_binary)")
    # if root user then run it with chroot
    am_i_root && start_command=("run_as_user" "$INFLUXDB_DAEMON_USER" "${start_command[@]}")

    if is_influxdb_3; then
        start_command+=("serve" "--node-id" "$INFLUXDB_NODE_ID" "--object-store" "$INFLUXDB_OBJECT_STORE" "--http-bind" "127.0.0.1:${INFLUXDB_HTTP_PORT_NUMBER}")
        ! is_boolean_yes "$INFLUXDB_HTTP_AUTH_ENABLED" && start_command+=("--without-auth")
        debug_execute "${start_command[@]}" &
        wait-for-port "$INFLUXDB_HTTP_PORT_NUMBER"
    else
        INFLUXDB_HTTP_HTTPS_ENABLED=false INFLUXDB_HTTP_BIND_ADDRESS="127.0.0.1:${INFLUXDB_HTTP_PORT_NUMBER}" debug_execute "${start_command[@]}" &
        wait-for-port --timeout="$INFLUXDB_PORT_READINESS_TIMEOUT" "$INFLUXDB_HTTP_PORT_NUMBER"
        wait_for_influxdb
    fi
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
    # VMs use a PID file, but containers do not, so check if the variable exists to cover both scenarios
    binary_fullpath="$(influxdb_binary)"
    if [[ -n "${INFLUXDB_PID_FILE:-}" ]]; then
        # influxdb does not create any PID file
        # We regenerate the PID file for each time we query it to avoid getting outdated
        pgrep "$(basename "$binary_fullpath")" | head -n 1 > "$INFLUXDB_PID_FILE"

        local pid
        pid="$(get_pid_from_file "$INFLUXDB_PID_FILE")"
        if [[ -z "$pid" ]]; then
            false
        else
            is_service_running "$pid"
        fi
    elif pgrep "$(basename "$binary_fullpath")" >/dev/null 2>&1; then
        true
    else
        false
    fi
}

########################
# Check if InfluxDB is not running
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_influxdb_not_running() {
    ! is_influxdb_running
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
    is_influxdb_not_running && return

    info "Stopping InfluxDB..."
    pkill --full --signal TERM "$(influxdb_binary)"
    wait-for-port --state free "$INFLUXDB_HTTP_PORT_NUMBER"
}

########################
# Creates the admin token
# Ref: https://docs.influxdata.com/influxdb3/core/get-started/#authentication-and-authorization
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
influxdb3_create_admin_token() {
    local create_command=("$(influxdb_binary)" "create" "token" "--admin" "--host" "http://127.0.0.1:${INFLUXDB_HTTP_PORT_NUMBER}" "--format" "json")

    info "Creating admin token..."
    "${create_command[@]}" | jq -r ".token" > "$INFLUXDB_AUTOGEN_ADMIN_TOKEN_FILE"
    chmod 600 "$INFLUXDB_AUTOGEN_ADMIN_TOKEN_FILE"
    warn "Auto-generated admin token saved in ${INFLUXDB_AUTOGEN_ADMIN_TOKEN_FILE} for later use. Please, ensure you use it to regenerate it and remove the file afterwards."
}

########################
# Creates the databases
# Ref: https://docs.influxdata.com/influxdb3/core/admin/databases/create/
# Globals:
#   INFLUXDB_*
# Arguments:
#   None
# Returns:
#   None
#########################
influxdb3_create_databases() {
    local admin_token
    local -r binary_fullpath="$(influxdb_binary)"

    if [[ -n "${INFLUXDB_ADMIN_TOKEN:-}" ]]; then
        admin_token="$INFLUXDB_ADMIN_TOKEN"
    elif [[ -f "$INFLUXDB_AUTOGEN_ADMIN_TOKEN_FILE}" ]]; then
        admin_token="$(<"${INFLUXDB_AUTOGEN_ADMIN_TOKEN_FILE}")"
    else
        error "No admin token found"
        return 1
    fi

    read -r -a dbs <<< "$(tr ',;' ' ' <<< "$INFLUXDB_DATABASES")"
    read -r -a existingDbs <<< "$($binary_fullpath show databases --host "http://127.0.0.1:${INFLUXDB_HTTP_PORT_NUMBER}" --token "$admin_token" --format json | jq -r '.[]."iox::database"' | tr -s '\n' ' ')"
    info "Creating databases: ${dbs[*]}..."
    for db in "${dbs[@]}"; do
        if [[ "${existingDbs[*]}" =~ $db ]]; then
            debug "Database \"${db}\" already exists. Skipping..."
            continue
        fi
        debug "Creating database \"${db}\"..."
        "$binary_fullpath" create database "$db" --host "http://127.0.0.1:${INFLUXDB_HTTP_PORT_NUMBER}" --token "$admin_token" || true
    done
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
    if is_influxdb_3; then
        local create_admin="no"
        if is_boolean_yes "$INFLUXDB_HTTP_AUTH_ENABLED" && is_boolean_yes "$INFLUXDB_CREATE_ADMIN_TOKEN" && [[ "$INFLUXDB_OBJECT_STORE" = "file" ]] && ! is_dir_empty "$INFLUXDB_DATA_DIR"; then
            warn "InfluxDB data directory is not empty, admin token creation will be skipped"
        elif is_boolean_yes "$INFLUXDB_HTTP_AUTH_ENABLED" && is_boolean_yes "$INFLUXDB_CREATE_ADMIN_TOKEN" && [[ -f "$INFLUXDB_AUTOGEN_ADMIN_TOKEN_FILE" ]]; then
            warn "Admin token file found, admin token creation will be skipped"
        elif is_boolean_yes "$INFLUXDB_HTTP_AUTH_ENABLED" && is_boolean_yes "$INFLUXDB_CREATE_ADMIN_TOKEN"; then
            create_admin="yes"
        fi
        # We create the databases regardless there's existing data or not
        if (is_boolean_yes "$create_admin" || [[ -n "${INFLUXDB_DATABASES:-}" ]]) && [[ ! "$INFLUXDB_OBJECT_STORE" =~ memory ]]; then
            info "Initializing..."
            influxdb_start_bg
            is_boolean_yes "$create_admin" && influxdb3_create_admin_token
            [[ -n "${INFLUXDB_DATABASES:-}" ]] && influxdb3_create_databases
        else
            info "Skipping initialization..."
        fi
    elif [[ ! -f "${INFLUX_CONFIGS_PATH}" ]]; then
        if [[ "${INFLUXDB_INIT_MODE}" = "setup" ]]; then
            influxdb_create_config
            influxdb_start_bg
            info "Deploying InfluxDB from scratch"
            info "Creating primary setup..."
            influxdb_create_primary_setup
        elif [[ "${INFLUXDB_INIT_MODE}" = "upgrade" ]]; then
            info "Migrating InfluxDB 1.x data into 2.x format"
            influxdb_run_upgrade
            influxdb_start_bg
        else
            error "INFLUXDB_INIT_MODE only accepts 'setup' (default) or 'upgrade' values"
            exit 1
        fi

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

    true
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
    debug_execute "$(influxdb_cli_binary)" "${flags[@]}" "-execute" "$query"
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
        is_influxdb_not_running && influxdb_start_bg
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
                if is_influxdb_3; then
                    debug "Ignoring $f"
                else
                    debug "Executing $f"
                    influxdb_execute_query "$(<"$f")"
                fi
                ;;
            *) debug "Ignoring $f" ;;
            esac
        done <$tmp_file
        rm -f "$tmp_file"
        touch "$INFLUXDB_VOLUME_DIR"/.user_scripts_initialized
    fi
}
