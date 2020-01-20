#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libbitnami.sh

print_welcome_page

info "** Starting MinIO Client setup **"
/setup.sh
info "** MinIO Client setup finished! **"

echo ""
exec "/run.sh" "$@"
