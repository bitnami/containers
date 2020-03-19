#!/bin/bash
# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail


# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libmongodb.sh
. /opt/bitnami/scripts/libmongodb-sharded.sh

# Load MongoDB env. variables
eval "$(mongodb_env)"
eval "$(mongodb_sharded_env)"

print_welcome_page

if [[ "$*" = "/opt/bitnami/scripts/mongodb-sharded/run.sh" || "$*" = "/run.sh" ]]; then
    info "** Starting MongoDB Sharded setup **"
    /opt/bitnami/scripts/mongodb-sharded/setup.sh
    info "** MongoDB Sharded setup finished! **"
fi

echo ""
exec "$@"

