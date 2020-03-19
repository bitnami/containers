#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/chartmuseum/run.sh"* ]]; then
    info "** Starting chartmuseum setup **"
    /opt/bitnami/scripts/chartmuseum/setup.sh
    info "** chartmuseum setup finished! **"
fi

echo ""
exec "$@"
