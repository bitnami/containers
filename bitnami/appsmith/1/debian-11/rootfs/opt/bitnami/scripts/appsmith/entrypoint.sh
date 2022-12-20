#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load Appsmith environment variables
. /opt/bitnami/scripts/appsmith-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/appsmith/run.sh" ]]; then
    info "** Starting Appsmith ${APPSMITH_MODE} setup **"
    /opt/bitnami/scripts/appsmith/setup.sh
    if [[ "$APPSMITH_MODE" == "client" ]]; then
        # In the case of the frontend, we need to configure nginx too
        /opt/bitnami/scripts/nginx/setup.sh
    fi
    info "** Appsmith ${APPSMITH_MODE} setup finished! **"
fi

echo ""
exec "$@"
