#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /libredissentinel.sh
. /libbitnami.sh
. /liblog.sh

# Load Redis environment
eval "$(redis_env)"

print_welcome_page

if [[ "$*" == *"/run.sh"* ]]; then
    info "** Starting Redis sentinel setup **"
    /setup.sh
    info "** Redis sentinel setup finished! **"
fi

echo ""
exec "$@"
