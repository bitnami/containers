#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libkibana.sh
. /opt/bitnami/scripts/libfs.sh

# Load environment
. /opt/bitnami/scripts/kibana-env.sh

for dir in "$SERVER_TMP_DIR" "$SERVER_LOGS_DIR" "$SERVER_CONF_DIR" "$SERVER_DEFAULT_CONF_DIR" "$SERVER_PLUGINS_DIR" "$SERVER_DEFAULT_PLUGINS_DIR" "$SERVER_VOLUME_DIR" "$SERVER_DATA_DIR" "$SERVER_INITSCRIPTS_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R ug+rwX "$dir"
done

kibana_conf_set "path.data" "$SERVER_DATA_DIR"
# For backwards compatibility, create a symlink to the default path
! is_dir_empty "${SERVER_BASE_DIR}/data" || rm -rf "${SERVER_BASE_DIR}/data" && ln -s "$SERVER_DATA_DIR" "${SERVER_BASE_DIR}/data"

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "${SERVER_CONF_DIR}/"* "$SERVER_DEFAULT_CONF_DIR"
chmod o+rX -R "$SERVER_DEFAULT_CONF_DIR"

if ! is_dir_empty "$SERVER_PLUGINS_DIR"; then
    # Move all initially installed plugins to the default plugins directory.
    for plugin_path in "${SERVER_PLUGINS_DIR}"/*; do
        plugin_name="$(basename "$plugin_path")"
        plugin_moved_path="${SERVER_DEFAULT_PLUGINS_DIR}/${plugin_name}"
        mv "$plugin_path" "$plugin_moved_path"
    done
    chmod o+rX -R "$SERVER_DEFAULT_PLUGINS_DIR"
fi
