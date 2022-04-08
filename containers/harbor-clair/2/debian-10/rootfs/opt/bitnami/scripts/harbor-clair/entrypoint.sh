#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/harbor-clair/run.sh" ]]; then
    info "** Starting Harbor Clair setup **"
    /opt/bitnami/scripts/harbor-clair/setup.sh
    info "** Harbor Clair setup finished! **"
fi

echo ""
exec "$@"
