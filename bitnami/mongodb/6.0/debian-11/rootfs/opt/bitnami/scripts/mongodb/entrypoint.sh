#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libmongodb.sh

# Load environment
. /opt/bitnami/scripts/mongodb-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/mongodb/run.sh" ]]; then
    info "** Starting MongoDB setup **"
    /opt/bitnami/scripts/mongodb/setup.sh
    info "** MongoDB setup finished! **"
fi

echo ""
exec "$@"

