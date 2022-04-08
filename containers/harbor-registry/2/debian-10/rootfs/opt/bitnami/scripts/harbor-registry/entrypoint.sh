#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/harbor-registry/run.sh" ]]; then
    info "** Starting Harbor Registry setup **"
    /opt/bitnami/scripts/harbor-registry/setup.sh
    info "** Harbor Registry setup finished! **"
fi

echo ""
exec "$@"
