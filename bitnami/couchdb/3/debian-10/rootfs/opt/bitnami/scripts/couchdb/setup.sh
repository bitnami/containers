#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libcouchdb.sh

# Load CouchDB environment variables
eval "$(couchdb_env)"

# Ensure CouchDB environment variables are valid
couchdb_validate
# Ensure CouchDB user and group exist when running as 'root'
if am_i_root; then
    ensure_user_exists "$COUCHDB_DAEMON_USER" "$COUCHDB_DAEMON_GROUP"
    COUCHDB_OWNERSHIP_USER="$COUCHDB_DAEMON_USER"
else
    COUCHDB_OWNERSHIP_USER=""
fi
# Ensure directories used by CouchDB exist and have proper ownership and permissions
for dir in "$COUCHDB_DATA_DIR" "$COUCHDB_CONF_DIR"; do
    ensure_dir_exists "$dir" "$COUCHDB_OWNERSHIP_USER"
done
# Ensure CouchDB is initialized
couchdb_initialize
