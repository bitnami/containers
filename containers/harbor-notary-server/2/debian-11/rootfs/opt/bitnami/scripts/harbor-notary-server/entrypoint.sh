#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/harbor-notary-server/run.sh" ]]; then
    info "** Starting Harbor Notary Server setup **"
    /opt/bitnami/scripts/harbor-notary-server/setup.sh
    info "** Harbor Notary Server setup finished! **"
fi

echo ""
exec "$@"
