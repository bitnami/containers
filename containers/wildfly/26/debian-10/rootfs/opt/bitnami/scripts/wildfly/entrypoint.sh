#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load WildFly environment
. /opt/bitnami/scripts/wildfly-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/wildfly/run.sh" ]]; then
    info "** Starting WildFly setup **"
    /opt/bitnami/scripts/wildfly/setup.sh
    info "** WildFly setup finished! **"
fi

echo ""
exec "$@"
