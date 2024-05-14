#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libopensearch.sh

# Load environment
. /opt/bitnami/scripts/opensearch-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users 
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/elasticsearch/conf)
debug "Copying files from $DB_DEFAULT_CONF_DIR to $DB_CONF_DIR"
cp -nr "$DB_DEFAULT_CONF_DIR"/. "$DB_CONF_DIR"

if ! is_dir_empty "$DB_DEFAULT_PLUGINS_DIR"; then
    debug "Copying plugins from $DB_DEFAULT_PLUGINS_DIR to $DB_PLUGINS_DIR"
    # Copy the plugins installed by default to the plugins directory
    # If there is already a plugin with the same name in the plugins folder do nothing
    for plugin_path in "${DB_DEFAULT_PLUGINS_DIR}"/*; do
        plugin_name="$(basename "$plugin_path")"
        plugin_moved_path="${DB_PLUGINS_DIR}/${plugin_name}"
        if ! [[ -d "$plugin_moved_path" ]]; then
            cp -r "$plugin_path" "$plugin_moved_path" 
        fi
    done
fi

if [[ "$1" = "/opt/bitnami/scripts/opensearch/run.sh" ]]; then
    info "** Starting Opensearch setup **"
    /opt/bitnami/scripts/opensearch/setup.sh
    info "** Opensearch setup finished! **"
fi

echo ""
exec "$@"
