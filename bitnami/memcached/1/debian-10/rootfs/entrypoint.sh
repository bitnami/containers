#!/bin/bash

# shellcheck disable=SC1090

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. "${BITNAMI_SCRIPTS_DIR:-}"/libbitnami.sh
. "${BITNAMI_SCRIPTS_DIR:-}"/liblog.sh
. "${BITNAMI_SCRIPTS_DIR:-}"/libmemcached.sh

# Load Memcached environment variables
. "${BITNAMI_SCRIPTS_DIR:-}"/memcached-env.sh

print_welcome_page

if [[ "$*" = "/run.sh" ]]; then
    info "** Starting Memcached setup **"
    /setup.sh
    info "** Memcached setup finished! **"
fi

echo ""
exec "$@"
