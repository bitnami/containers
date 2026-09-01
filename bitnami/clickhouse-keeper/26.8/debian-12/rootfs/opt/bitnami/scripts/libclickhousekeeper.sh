#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami ClickHouse Keeper library

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
# Validate settings in CLICKHOUSE_KEEPER_* env vars
# Globals:
#   CLICKHOUSE_KEEPER_*
# Arguments:
#   None
# Returns:
#   0 if the validation succeeded, 1 otherwise
#########################
keeper_validate() {
    debug "Validating settings in CLICKHOUSE_KEEPER_* environment variables..."
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
    check_empty_value "CLICKHOUSE_KEEPER_SERVER_ID"
    ! is_empty_value "$CLICKHOUSE_KEEPER_TCP_PORT" && check_valid_port "CLICKHOUSE_KEEPER_TCP_PORT"
    ! is_empty_value "$CLICKHOUSE_KEEPER_RAFT_PORT" && check_valid_port "CLICKHOUSE_KEEPER_RAFT_PORT"

    return "$error_code"
}

########################
# Add or modify an entry in the ClickHouse Keeper configuration file
# Globals:
#   CLICKHOUSE_KEEPER_*
# Arguments:
#   $1 - XPath expression
#   $2 - Value to assign to the variable
#   $3 - Configuration file
# Returns:
#   None
#########################
keeper_conf_set() {
    local -r xpath="${1:?key missing}"
    # We allow empty values
    local -r value="${2:-}"
    local -r config_file="${3:-$CLICKHOUSE_KEEPER_CONF_FILE}"
    debug "Setting ${xpath} to '${value}' in ClickHouse Keeper configuration file $config_file"
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
        keeper_conf_set "$parentNode"
        if is_empty_value "$value"; then
            xmlstarlet ed -L --subnode "${parentNode}" -t "elem" -n "${newNode}" "$config_file"
        else
            xmlstarlet ed -L --subnode "${parentNode}" -t "elem" -n "${newNode}" -v "$value" "$config_file"
        fi
    fi
}

########################
# Copy configuration from the mounted folder to the etc folder
# In charts mounting directly in the configuration folder would not
# allow the use of multiple ConfigMaps and Secrets
# Globals:
#   CLICKHOUSE_KEEPER_*
# Arguments:
#   None
# Returns:
#   None
#########################
keeper_copy_mounted_configuration() {
    if ! is_mounted_dir_empty "$CLICKHOUSE_KEEPER_MOUNTED_CONF_DIR"; then
        info "Copying mounted configuration from $CLICKHOUSE_KEEPER_MOUNTED_CONF_DIR"
        # Copy first the files at the base of the mounted folder to go to ClickHouse
        # base etc folder
        find "$CLICKHOUSE_KEEPER_MOUNTED_CONF_DIR" -maxdepth 1 \( -type f -o -type l \) -exec cp -L -r {} "$CLICKHOUSE_KEEPER_CONF_DIR" \;

        # The ClickHouse override directories (etc/conf.d, etc/keeper_config.d and etc/users.d) do not support subfolders. That means we cannot
        # copy directly with cp -RL because we need all override xml files to have at the root of these subfolders. In the Helm
        # chart we want to allow overrides from different ConfigMaps and Secrets so we need to use the find command.
        for dir in conf.d keeper_config.d users.d; do
            if [[ -d "${CLICKHOUSE_KEEPER_MOUNTED_CONF_DIR}/${dir}" ]]; then
                mkdir -p "${CLICKHOUSE_KEEPER_CONF_DIR}/${dir}"
                find "${CLICKHOUSE_KEEPER_MOUNTED_CONF_DIR}/${dir}" \( -type f -o -type l \) -exec cp -L -r {} "${CLICKHOUSE_KEEPER_CONF_DIR}/${dir}" \;
            fi
        done
    fi
}

########################
# Initialize ClickHouse Keeper
# Globals:
#   CLICKHOUSE_KEEPER_*
# Arguments:
#   None
# Returns:
#   None
#########################
keeper_initialize() {
    # This fixes an issue where the trap would kill the entrypoint.sh, if a PID was left over from a previous run
    # Exec replaces the process without creating a new one, and when the container is restarted it may have the same PID
    rm -f "$CLICKHOUSE_KEEPER_PID_FILE"

    keeper_copy_mounted_configuration
    if is_boolean_yes "$CLICKHOUSE_KEEPER_SKIP_SETUP"; then
        info "Skipping ClickHouse Keeper setup"
    else
        # Logic based on the upstream ClickHouse Keeper container
        # For the container itself we keep the logic simple. In the helm chart we rely on the mounting of configuration files with overrides
        # ref: https://github.com/ClickHouse/ClickHouse/blob/master/docker/keeper/entrypoint.sh
        keeper_conf_set "/clickhouse/keeper_server/server_id" "$CLICKHOUSE_KEEPER_SERVER_ID"
        keeper_conf_set "/clickhouse/keeper_server/raft_configuration/server/id" "$CLICKHOUSE_KEEPER_SERVER_ID"
        is_boolean_yes "${BITNAMI_DEBUG}" && keeper_conf_set "/clickhouse/logger/level" "debug"
    fi

    # Avoid exit code of previous commands to affect the result of this function
    true
}
