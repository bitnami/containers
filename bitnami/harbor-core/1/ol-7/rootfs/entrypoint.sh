#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libbitnami.sh

print_welcome_page

if [[ "$*" = "harbor_core" ]]; then
    info "** Starting Harbor Core setup **"
    /setup.sh
    info "** Harbor Core setup finished! **"
fi

echo ""
exec "$@"
