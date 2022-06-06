#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Redis environment variables
. /opt/bitnami/scripts/redis-env.sh

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libredis.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/redis/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting Redis setup **"
    /opt/bitnami/scripts/redis/setup.sh
    info "** Redis setup finished! **"
fi

echo ""
exec "$@"
