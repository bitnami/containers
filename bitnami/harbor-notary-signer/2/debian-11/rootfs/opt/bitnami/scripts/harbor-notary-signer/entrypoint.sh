#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/harbor-notary-signer/run.sh" ]]; then
    info "** Starting Harbor Notary Signer setup **"
    /opt/bitnami/scripts/harbor-notary-signer/setup.sh
    info "** Harbor Notary Signer setup finished! **"
fi

echo ""
exec "$@"
