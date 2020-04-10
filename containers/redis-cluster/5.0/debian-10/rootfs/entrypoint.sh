#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/librediscluster.sh

# Load Redis environment variables
eval "$(redis_cluster_env)"

print_welcome_page

if [[ "$*" = *"/run.sh"* ]]; then
    info "** Starting Redis setup **"
    /setup.sh
    info "** Redis setup finished! **"
fi

echo ""
exec "$@"
