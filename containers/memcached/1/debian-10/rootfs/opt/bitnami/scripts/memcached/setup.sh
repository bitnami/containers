#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libmemcached.sh

# Load Memcached environment variables
. /opt/bitnami/scripts/memcached-env.sh

# Ensure Memcached environment variables are valid
memcached_validate

# Create Memcached system user and group
if am_i_root; then
    info "Creating Memcached daemon user"
    ensure_user_exists "${MEMCACHED_DAEMON_USER}" "${MEMCACHED_DAEMON_GROUP}"
fi

# Ensure Memcached is initialized
memcached_initialize
