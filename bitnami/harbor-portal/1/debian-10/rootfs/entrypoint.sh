#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libbitnami.sh
. /libnginx.sh

# Load NGINX environment variables
eval "$(nginx_env)"

print_welcome_page

if [[ "$*" = "/run.sh" ]]; then
    info "** Starting NGINX setup **"
    /setup.sh
    info "** NGINX setup finished! **"
fi

echo ""
exec "$@"
