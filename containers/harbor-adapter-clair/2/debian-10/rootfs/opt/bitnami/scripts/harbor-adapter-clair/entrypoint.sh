#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace 

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/harbor-adapter-clair/run.sh"* ]]; then
    info "** Starting Harbor Adapter Clair setup **"
    /opt/bitnami/scripts/harbor-adapter-clair/setup.sh
    info "** Harbor Adapter Clair setup finished! **"
fi

echo ""
exec "$@"
