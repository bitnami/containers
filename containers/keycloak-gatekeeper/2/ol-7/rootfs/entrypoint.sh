#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose
# shellcheck disable=SC1091

# Load libraries
. /libbitnami.sh
. /liblog.sh

print_welcome_page

if [[ "$*" = *"/run.sh"* ]]; then
    info "** Starting Keycloak Gatekeeper setup **"
    /setup.sh "${@:2}"
    info "** Keycloak Gatekeeper setup finished! **"
fi

echo ""
exec "$@"
