#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh

print_welcome_page

if [[ "$*" = "harbor_core" ]]; then
    info "** Starting Harbor Core setup **"
    /opt/bitnami/scripts/harbor-core/setup.sh
    info "** Harbor Core setup finished! **"
fi

echo ""
exec "$@"
