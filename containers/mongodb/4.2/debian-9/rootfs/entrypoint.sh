#!/bin/bash
# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail


# Load libraries
. /libbitnami.sh
. /libmongodb.sh

# Load MongoDB env. variables
eval "$(mongodb_env)"

print_welcome_page

if [[ "$*" = "/run.sh" ]]; then
    info "** Starting MongoDB setup **"
    /setup.sh
    info "** MongoDB setup finished! **"
fi

echo ""
exec "$@"

