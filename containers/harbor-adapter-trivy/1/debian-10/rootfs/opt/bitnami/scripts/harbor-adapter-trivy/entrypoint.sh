#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/harboradaptertrivy-env.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/harbor-adapter-trivy/run.sh"* ]]; then
    info "** Starting Harbor Adapter Trivy setup **"
    /opt/bitnami/scripts/harbor-adapter-trivy/setup.sh
    info "** Harbor Adapter Trivy setup finished! **"
fi

echo ""
exec "$@"


