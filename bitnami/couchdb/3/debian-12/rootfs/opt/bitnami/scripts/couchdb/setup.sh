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
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libcouchdb.sh

# Load environment
. /opt/bitnami/scripts/couchdb-env.sh

# Ensure CouchDB environment variables are valid
couchdb_validate
# Ensure CouchDB user and group exist when running as 'root'
if am_i_root; then
    info "Creating CouchDB daemon user"
    ensure_user_exists "$COUCHDB_DAEMON_USER" --group "$COUCHDB_DAEMON_GROUP"
fi
# Ensure directories used by CouchDB exist and have proper ownership and permissions
for dir in "$COUCHDB_DATA_DIR" "$COUCHDB_CONF_DIR"; do
    ensure_dir_exists "$dir"
    am_i_root && chown -R "${COUCHDB_DAEMON_USER}:${COUCHDB_DAEMON_GROUP}" "$dir"
done
# Ensure CouchDB is initialized
couchdb_initialize
