#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /libbitnami.sh
. /liblog.sh
. /libmemcached.sh

# Load Memcached environment variables
eval "$(memcached_env)"

print_welcome_page

if [[ "$*" = "/run.sh" ]]; then
    info "** Starting Memcached setup **"
    /setup.sh
    info "** Memcached setup finished! **"
fi

echo ""
exec "$@"
