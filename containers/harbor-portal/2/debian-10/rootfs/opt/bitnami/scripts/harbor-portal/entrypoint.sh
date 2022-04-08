#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libnginx.sh

# Load NGINX environment variables
. /opt/bitnami/scripts/nginx-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/nginx/run.sh" ]]; then
    info "** Starting Harbor Portal setup **"
    /opt/bitnami/scripts/nginx/setup.sh
    /opt/bitnami/scripts/harbor-portal/setup.sh
    info "** Harbor Portal setup finished! **"
fi

echo ""
exec "$@"
