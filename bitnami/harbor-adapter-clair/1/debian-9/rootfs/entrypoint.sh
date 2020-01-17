#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace 

# Load libraries
. /libbitnami.sh

print_welcome_page

if [[ "$*" = *"/run.sh"* ]]; then
    info "** Starting Harbor Adapter Clair setup **"
    /setup.sh
    info "** Harbor Adapter Clair setup finished! **"
fi

echo ""
exec "$@"
