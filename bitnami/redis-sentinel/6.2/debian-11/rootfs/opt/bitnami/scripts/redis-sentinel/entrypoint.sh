#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Redis Sentinel environment variables
. /opt/bitnami/scripts/redis-sentinel-env.sh

# Load libraries
. /opt/bitnami/scripts/libredissentinel.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

print_welcome_page

if [[ "$*" == *"/opt/bitnami/scripts/redis-sentinel/run.sh"* ]]; then
    info "** Starting Redis sentinel setup **"
    /opt/bitnami/scripts/redis-sentinel/setup.sh
    info "** Redis sentinel setup finished! **"
fi

echo ""
exec "$@"
