#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/harbor-jobservice/run.sh" ]]; then
    info "** Starting Harbor Job Service setup **"
    /opt/bitnami/scripts/harbor-jobservice/setup.sh
    info "** Harbor Job Service setup finished! **"
fi

echo ""
exec "$@"
