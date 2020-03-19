#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libcouchdb.sh

# Load CouchDB environment variables
eval "$(couchdb_env)"

# Ensure directories used by CouchDB exist and have proper ownership and permissions
for dir in "$COUCHDB_DATA_DIR" "$COUCHDB_CONF_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# Add default configuration to vm.args
echo -e "\n# Set a well-known cluster port" >> "${COUCHDB_CONF_DIR}/vm.args"
couchdb_vm_args_set "-kernel inet_dist_listen_min" "9100"
couchdb_vm_args_set "-kernel inet_dist_listen_max" "9100"
couchdb_vm_args_set "-name" "couchdb@127.0.0.1"
