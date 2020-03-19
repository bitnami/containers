#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libnginx.sh

# Load NGINX environment variables
eval "$(nginx_env)"

print_welcome_page

if [[ "$*" = "/opt/bitnami/scripts/nginx/run.sh" ]]; then
    info "** Starting NGINX setup **"
    /opt/bitnami/scripts/nginx/setup.sh
    info "** NGINX setup finished! **"
fi

echo ""
exec "$@"
