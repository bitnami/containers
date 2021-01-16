#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libkong.sh

# Auxiliar functions

########################
# Set a configuration to Kong's configuration file
# Globals:
#   KONG_CONF_FILE
# Arguments:
#   $1 - key
#   $2 - value
# Returns:
#   None
#########################
kong_conf_set() {
    local -r key="${1:?missing key}"
    local -r value="${2:-}"

    # Check if the value was commented or set before
    if grep -q "^#*${key}\s*=[^#]*" "$KONG_CONF_FILE"; then
        debug "Updating entry for property '${key}' in configuration file"
        # Update the existing key (leave trailing space for comments)
        sed -ri "s|^(#*${key}\s*=)[^#]*|\1 ${value} |" "$KONG_CONF_FILE"
    else
        debug "Adding new entry for property '${key}' in configuration file"
        # Add a new key
        printf '/opt/bitnami/scripts/kong = %s\n' "$key" "$value" >>"$KONG_CONF_FILE"
    fi
}

########################
# Uncomment non-empty entries in Kong configuration
# Globals:
#   KONG_CONF_FILE
# Arguments:
#   None
# Returns:
#   None
#########################
kong_configure_non_empty_values() {
    # Uncomment all non-empty keys in the main Kong configuration file
    sed -ri 's/^#+([a-z_ ]+)=(\s*[^# ]+)/\1=\2 /' "$KONG_CONF_FILE"

    # Comment read-only postgres connection parameters again, as default values fail to work properly
    sed -ri 's/(^pg_ro_.+)=(\s*[^# ]+)/#\1=\2 /' "$KONG_CONF_FILE"
}

# Load Kong environment variables
eval "$(kong_env)"

# Ensure users and groups used by Kong exist
ensure_user_exists "$KONG_DAEMON_USER" --group "$KONG_DAEMON_GROUP"
# Ensure directories used by Kong exist and have proper permissions
ensure_dir_exists "$KONG_SERVER_DIR"
ensure_dir_exists "$KONG_INITSCRIPTS_DIR"
chmod -R g+rwX "$KONG_SERVER_DIR" "$KONG_CONF_DIR"
# Copy configuration file and set default values
cp "$KONG_DEFAULT_CONF_FILE" "$KONG_CONF_FILE"
kong_conf_set prefix "$KONG_SERVER_DIR"
kong_conf_set nginx_daemon off
kong_conf_set lua_package_path
kong_conf_set nginx_user
kong_configure_non_empty_values
