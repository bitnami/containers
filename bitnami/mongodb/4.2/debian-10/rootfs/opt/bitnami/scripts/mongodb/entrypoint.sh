#!/bin/bash
# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail


# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libmongodb.sh

# Load MongoDB env. variables
eval "$(mongodb_env)"

print_welcome_page

if [[ "$*" = "/opt/bitnami/scripts/mongodb/run.sh" ]]; then
    info "** Starting MongoDB setup **"
    /opt/bitnami/scripts/mongodb/setup.sh
    info "** MongoDB setup finished! **"
fi

echo ""
exec "$@"

