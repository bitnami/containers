#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libkong.sh

# Load Kong environment variables
. /opt/bitnami/scripts/kong-env.sh

# Ensure users and groups used by Kong exist
ensure_user_exists "$KONG_DAEMON_USER" --group "$KONG_DAEMON_GROUP"
# Ensure directories used by Kong exist and have proper permissions
ensure_dir_exists "$KONG_LOGS_DIR"
ensure_dir_exists "$KONG_SERVER_DIR"
ensure_dir_exists "$KONG_INITSCRIPTS_DIR"
ensure_dir_exists "$KONG_DEFAULT_CONF_DIR"
ensure_dir_exists "$KONG_DEFAULT_SERVER_DIR"
chmod -R g+rwX "$KONG_SERVER_DIR" "$KONG_CONF_DIR" "$KONG_BASE_DIR"
# Copy configuration file and set default values
cp "$KONG_DEFAULT_CONF_FILE" "$KONG_CONF_FILE"
kong_conf_set prefix "$KONG_SERVER_DIR"
kong_conf_set nginx_daemon off
kong_conf_set nginx_user "$KONG_DAEMON_USER"
kong_configure_non_empty_values
install_opentelemetry
configure_lua_paths "/opt/bitnami/scripts/kong-env.sh" "/etc/bash.bashrc"
# Comment out 'resolver_address' setting to force Kong to use values from '/etc/resolv.conf'
replace_in_file "$KONG_CONF_FILE" "^resolver_address\s*=.*" "# resolver_address ="

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "${KONG_CONF_DIR}/"* "$KONG_DEFAULT_CONF_DIR"

if ! is_dir_empty "$KONG_SERVER_DIR"; then
    cp -r "$KONG_SERVER_DIR"/* "$KONG_DEFAULT_SERVER_DIR"
fi