#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami ClickHouse library

# shellcheck disable=SC1090
# shellcheck disable=SC1091

# Load generic libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libservice.sh

########################
# Validate settings in CLICKHOUSE_* env vars
# Globals:
#   CLICKHOUSE_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
clickhouse_validate() {
    debug "Validating settings in CLICKHOUSE_* environment variables..."
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

    # Validate user inputs
    ! is_empty_value "$CLICKHOUSE_HTTP_PORT" && check_valid_port "CLICKHOUSE_HTTP_PORT"
    ! is_empty_value "$CLICKHOUSE_TCP_PORT" && check_valid_port "CLICKHOUSE_TCP_PORT"
    ! is_empty_value "$CLICKHOUSE_MYSQL_PORT" && check_valid_port "CLICKHOUSE_MYSQL_PORT"
    ! is_empty_value "$CLICKHOUSE_POSTGRESQL_PORT" && check_valid_port "CLICKHOUSE_POSTGRESQL_PORT"
    ! is_empty_value "$CLICKHOUSE_INTERSERVER_HTTP_PORT" && check_valid_port "CLICKHOUSE_INTERSERVER_HTTP_PORT"

    # Validate credentials
    if is_boolean_yes "${ALLOW_EMPTY_PASSWORD:-}"; then
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD:-}. For safety reasons, do not use this flag in a production environment."
    elif is_empty_value "$CLICKHOUSE_ADMIN_PASSWORD"; then
        print_validation_error "The CLICKHOUSE_ADMIN_PASSWORD environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow a blank password. This is only recommended for development environments."
    fi

    return "$error_code"
}

########################
# Copy configuration from the mounted folder to the etc folder
# In charts mounting directly in the configuration folder would not
# allow the use of multiple ConfigMaps and Secrets
# Globals:
#   CLICKHOUSE_*
# Arguments:
#   None
# Returns:
#   None
#########################
clickhouse_copy_mounted_configuration() {
    if [[ -w "$CLICKHOUSE_CONF_DIR" ]]; then
        if ! is_mounted_dir_empty "$CLICKHOUSE_MOUNTED_CONF_DIR"; then
            info "Copying mounted configuration from $CLICKHOUSE_MOUNTED_CONF_DIR"
            # Copy first the files at the base of the mounted folder to go to ClickHouse
            # base etc folder
            find "$CLICKHOUSE_MOUNTED_CONF_DIR" -maxdepth 1 \( -type f -o -type l \) -exec cp -L -r {} "$CLICKHOUSE_CONF_DIR" \;

            # The ClickHouse override directories (etc/conf.d, etc/config.d and etc/users.d) do not support subfolders. That means we cannot
            # copy directly with cp -RL because we need all override xml files to have at the root of these subfolders. In the helm
            # chart we want to allow overrides from different ConfigMaps and Secrets so we need to use the find command.
            # etc/conf.d is now obselete but still supported.
            for dir in conf.d config.d users.d; do
                if [[ -d "${CLICKHOUSE_MOUNTED_CONF_DIR}/${dir}" ]]; then
                    find "${CLICKHOUSE_MOUNTED_CONF_DIR}/${dir}" \( -type f -o -type l \) -exec cp -L -r {} "${CLICKHOUSE_CONF_DIR}/${dir}" \;
                fi
            done
        fi
    else
        warn "The folder $CLICKHOUSE_CONF_DIR is not writable. This is likely because a read-only filesystem was mounted in that folder. Using $CLICKHOUSE_MOUNTED_CONF_DIR is recommended"
    fi
}

########################
# Add or modify an entry in the ClickHouse configuration file
# Globals:
#   CLICKHOUSE_*
# Arguments:
#   $1 - XPath expression
#   $2 - Value to assign to the variable
#   $3 - Configuration file
# Returns:
#   None
#########################
clickhouse_conf_set() {
    local -r xpath="${1:?key missing}"
    # We allow empty values
    local -r value="${2:-}"
    local -r config_file="${3:-$CLICKHOUSE_CONF_FILE}"
    debug "Setting ${xpath} to '${value}' in ClickHouse configuration file $config_file"
    # Check if the entry exists in the XML file
    if xmlstarlet --quiet sel -t -v "$xpath" "$config_file"; then
        # Base case
        # It exists, so replace the entry
        if ! is_empty_value "$value"; then
            xmlstarlet ed -L -u "$xpath" -v "$value" "$config_file"
        fi
    else
        # It does not exist, so add the subnode
        local -r parentNode="$(dirname "$xpath")"
        local -r newNode="$(basename "$xpath")"
        # Recursive call to add parent nodes
        clickhouse_conf_set "$parentNode"
        if is_empty_value "$value"; then
            xmlstarlet ed -L --subnode "${parentNode}" -t "elem" -n "${newNode}" "$config_file"
        else
            xmlstarlet ed -L --subnode "${parentNode}" -t "elem" -n "${newNode}" -v "$value" "$config_file"
        fi
    fi
}

########################
# Check if ClickHouse daemon is running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_clickhouse_running() {
    pid="$(get_pid_from_file "$CLICKHOUSE_PID_FILE")"
    if [[ -n "$pid" ]]; then
        is_service_running "$pid"
    else
        false
    fi
}

########################
# Check if ClickHouse daemon is not running
# Arguments:
#   None
# Returns:
#   Boolean
#########################
is_clickhouse_not_running() {
    ! is_clickhouse_running
}

########################
# Stop ClickHouse daemons
# Arguments:
#   None
# Returns:
#   None
#########################
clickhouse_stop() {
    ! is_clickhouse_running && return
    stop_service_using_pid "$CLICKHOUSE_PID_FILE"
}

########################
# Initialize ClickHouse
# Arguments:
#   None
# Returns:
#   None
#########################
clickhouse_initialize() {
    # Logic based on the upstream ClickHouse container
    # For the container itself we keep the logic simple. In the helm chart we rely on the mounting of configuration files with overrides
    # Source: https://github.com/ClickHouse/ClickHouse/blob/master/docker/server/entrypoint.sh

    # This fixes an issue where the trap would kill the entrypoint.sh, if a PID was left over from a previous run
    # Exec replaces the process without creating a new one, and when the container is restarted it may have the same PID
    rm -f "$CLICKHOUSE_PID_FILE"

    clickhouse_copy_mounted_configuration
    if [[ "$CLICKHOUSE_ADMIN_USER" != "default" ]]; then
        # If we need to set an admin user different from default, we create a configuration override
        local -r admin_user_override="${CLICKHOUSE_CONF_DIR}/users.d/__bitnami_default_user.xml"
        cat <<EOF >"${admin_user_override}"
<clickhouse>
  <!-- Docs: <https://clickhouse.com/docs/en/operations/settings/settings_users/> -->
  <users>
    <!-- Remove default user -->
    <default remove="remove">
    </default>

    <${CLICKHOUSE_ADMIN_USER}>
      <profile>default</profile>
      <password from_env="CLICKHOUSE_ADMIN_PASSWORD"></password>
      <networks>
        <ip>::/0</ip>
      </networks>
      <quota>default</quota>
      <access_management>1</access_management>
    </${CLICKHOUSE_ADMIN_USER}>
  </users>
</clickhouse>
EOF
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}

########################
# Start ClickHouse daemon
# Arguments:
#   $1 - Log file to check the startup message
# Returns:
#   None
#########################
clickhouse_start_bg() {
    local -r log_file="${1:-$CLICKHOUSE_LOG_FILE}"
    info "Starting ClickHouse in background"
    is_clickhouse_running && return
    # This function is meant to be called for internal operations like the init scripts
    local -r cmd=("${CLICKHOUSE_BASE_DIR}/bin/clickhouse-server")
    local -r args=("--config-file=${CLICKHOUSE_CONF_FILE}" "--pid-file=${CLICKHOUSE_PID_FILE}" "--" "--listen_host=0.0.0.0")
    if am_i_root; then
        run_as_user "$CLICKHOUSE_DAEMON_USER" "${cmd[@]}" "${args[@]}" >"$log_file" 2>&1 &
    else
        "${cmd[@]}" "${args[@]}" >"$log_file" 2>&1 &
    fi
    if ! retry_while is_clickhouse_running; then
        error "ClickHouse failed to start"
        exit 1
    fi
    wait_for_log_entry "Ready for connections" "$log_file"
    info "ClickHouse started successfully"
}

########################
# Run custom scripts
# Globals:
#   CLICKHOUSE_*
# Arguments:
#   $1 - 'init' or 'start' ('init' runs on first container start, 'start' runs everytime the container starts)
# Returns:
#   None
#########################
clickhouse_custom_scripts() {
    if [[ -n $(find /docker-entrypoint-"$1"db.d/ -type f -regex ".*\.sh") ]] && { [[ ! -f "$CLICKHOUSE_DATA_DIR/.user_scripts_initialized" ]] || [[ $1 == start ]]; }; then
        clickhouse_start_bg "$CLICKHOUSE_LOG_DIR/clickhouse_init_scripts.log"
        info "Loading user's custom files from /docker-entrypoint-$1db.d"
        for f in /docker-entrypoint-"$1"db.d/*; do
            debug "Executing $f"
            case "$f" in
            *.sh)
                if [[ -x "$f" ]]; then
                    if ! "$f"; then
                        error "Failed executing $f"
                        return 1
                    fi
                else
                    warn "Sourcing $f as it is not executable by the current user, any error may cause initialization to fail"
                    . "$f"
                fi
                ;;
            *)
                warn "Skipping $f, supported formats are: .sh"
                ;;
            esac
        done
        touch "${CLICKHOUSE_DATA_DIR}/.user_scripts_initialized"
    fi
}
