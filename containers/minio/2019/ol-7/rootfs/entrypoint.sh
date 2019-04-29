#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libbitnami.sh

print_welcome_page

if [[ "$*" = *"/run.sh"* ]]; then
    info "** Starting MinIO setup **"
    /setup.sh
    info "** MinIO setup finished! **"
fi

echo ""
exec "$@"
