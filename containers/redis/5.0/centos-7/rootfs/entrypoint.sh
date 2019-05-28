#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libbitnami.sh
. /libredis.sh

# Load Redis environment variables
eval "$(redis_env)"

print_welcome_page

if [[ "$*" = *"/run.sh"* ]]; then
    info "** Starting Redis setup **"
    /setup.sh
    info "** Redis setup finished! **"
fi

echo ""
exec "$@"
