#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /liblog.sh
. /libbitnami.sh

print_welcome_page

if [[ "$*" = *"/run.sh"* ]]; then
    info "** Starting CouchDB setup **"
    /setup.sh
    info "** CouchDB setup finished! **"
fi

echo ""
exec "$@"
