#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libmongodb.sh
. /opt/bitnami/scripts/libmongodb-sharded.sh

# Load MongoDB env. variables
. /opt/bitnami/scripts/mongodb-env.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/mongodb-sharded/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting MongoDB Sharded setup **"
    /opt/bitnami/scripts/mongodb-sharded/setup.sh
    info "** MongoDB Sharded setup finished! **"
fi

echo ""
exec "$@"

