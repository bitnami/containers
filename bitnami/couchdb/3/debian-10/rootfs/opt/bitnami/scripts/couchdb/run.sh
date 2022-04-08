#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libcouchdb.sh

# Load environment
. /opt/bitnami/scripts/couchdb-env.sh

info "** Starting CouchDB **"
if am_i_root; then
    exec gosu "$COUCHDB_DAEMON_USER" "${COUCHDB_BIN_DIR}/couchdb"
else
    exec "${COUCHDB_BIN_DIR}/couchdb"
fi
