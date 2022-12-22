#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/chartmuseum/run.sh"* ]]; then
    info "** Starting ChartMuseum setup **"
    /opt/bitnami/scripts/chartmuseum/setup.sh
    info "** ChartMuseum setup finished! **"
fi

echo ""
exec "$@"
