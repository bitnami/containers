#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libbitnami.sh

print_welcome_page

if [[ "$*" = "/run.sh" ]]; then
    info "** Starting Harbor Clair setup **"
    /setup.sh
    info "** Harbor Clair setup finished! **"
fi

echo ""
exec "$@"
