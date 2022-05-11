#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libkeycloak.sh

# Load keycloak environment variables
. /opt/bitnami/scripts/keycloak-env.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/keycloak/run.sh"* ]]; then
    info "** Starting keycloak setup **"
    /opt/bitnami/scripts/keycloak/setup.sh
    info "** keycloak setup finished! **"
fi

echo ""
exec "$@"
