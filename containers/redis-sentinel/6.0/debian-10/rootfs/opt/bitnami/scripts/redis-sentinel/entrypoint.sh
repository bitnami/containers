#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libredissentinel.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load Redis environment
eval "$(redis_env)"

print_welcome_page

if [[ "$*" == *"/opt/bitnami/scripts/redis-sentinel/run.sh"* ]]; then
    info "** Starting Redis sentinel setup **"
    /opt/bitnami/scripts/redis-sentinel/setup.sh
    info "** Redis sentinel setup finished! **"
fi

echo ""
exec "$@"
