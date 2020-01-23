#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /libos.sh
. /liblog.sh
. /libcouchdb.sh

# Load CouchDB environment variables
eval "$(couchdb_env)"

info "** Starting CouchDB **"
if am_i_root; then
    exec gosu "$COUCHDB_DAEMON_USER" "${COUCHDB_BIN_DIR}/couchdb"
else
    exec "${COUCHDB_BIN_DIR}/couchdb"
fi
