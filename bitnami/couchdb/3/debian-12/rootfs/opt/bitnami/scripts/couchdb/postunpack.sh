#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libcouchdb.sh

# Load environment
. /opt/bitnami/scripts/couchdb-env.sh

# Ensure directories used by CouchDB exist
for dir in "$COUCHDB_DATA_DIR" "$COUCHDB_CONF_DIR" "$(dirname "$COUCHDB_CONF_FILE")"; do
    ensure_dir_exists "$dir"
done

# Add default configuration to vm.args
echo -e "\n# Set a well-known cluster port" >> "${COUCHDB_CONF_DIR}/vm.args"
couchdb_vm_args_set "-kernel inet_dist_listen_min" "9100"
couchdb_vm_args_set "-kernel inet_dist_listen_max" "9100"
couchdb_vm_args_set "-name" "couchdb@127.0.0.1"

# Ensure directories used by CouchDB have proper permissions
for dir in "$COUCHDB_DATA_DIR" "$COUCHDB_CONF_DIR"; do
    chmod -R g+rwX "$dir"
done
