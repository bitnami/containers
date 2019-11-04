#!/bin/bash
# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail


# Load libraries
. /libbitnami.sh
. /libmongodb.sh
. /libmongodb-sharded.sh

# Load MongoDB env. variables
eval "$(mongodb_env)"
eval "$(mongodb_sharded_env)"

print_welcome_page

if [[ "$*" = "/run.sh" ]]; then
    info "** Starting MongoDB Sharded setup **"
    /setup.sh
    info "** MongoDB Sharded setup finished! **"
fi

echo ""
exec "$@"

