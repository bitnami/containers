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
    info "** Starting Harbor Notary Server setup **"
    /setup.sh
    info "** Harbor Notary Server setup finished! **"
fi

echo ""
exec "$@"
