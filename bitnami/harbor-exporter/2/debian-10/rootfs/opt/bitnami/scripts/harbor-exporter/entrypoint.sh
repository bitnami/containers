#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libharbor.sh


print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/harbor-exporter/run.sh" ]]; then
    info "** Starting Harbor Exporter setup **"
    install_custom_certs
    info "** Harbor Exporter setup finished! **"
fi

echo ""
exec "$@"
