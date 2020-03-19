#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libbitnami.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/couchdb/run.sh"* ]]; then
    info "** Starting CouchDB setup **"
    /opt/bitnami/scripts/couchdb/setup.sh
    info "** CouchDB setup finished! **"
fi

echo ""
exec "$@"
