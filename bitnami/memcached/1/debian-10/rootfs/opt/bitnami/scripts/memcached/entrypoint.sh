#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libmemcached.sh

# Load Memcached environment variables
. /opt/bitnami/scripts/memcached-env.sh

print_welcome_page

if [[ "$*" = "/opt/bitnami/scripts/memcached/run.sh" || "$*" = "/run.sh" ]]; then
    info "** Starting Memcached setup **"
    /opt/bitnami/scripts/memcached/setup.sh
    info "** Memcached setup finished! **"
fi

echo ""
exec "$@"
