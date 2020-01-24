#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /libapache.sh
. /libbitnami.sh
. /liblog.sh

# Load Apache environment
eval "$(apache_env)"

print_welcome_page

if [[ "$*" == *"/run.sh"* ]]; then
    info "** Starting Apache setup **"
    /setup.sh
    info "** Apache setup finished! **"
fi

echo ""
exec "$@"
