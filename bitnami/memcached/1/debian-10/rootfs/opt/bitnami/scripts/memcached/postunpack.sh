#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libmemcached.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh # used for resize

# Load Memcached environment variables
. /opt/bitnami/scripts/memcached-env.sh

info "Creating Memcached daemon user"
ensure_user_exists "${MEMCACHED_DAEMON_USER}" "${MEMCACHED_DAEMON_GROUP}"

# Ensure directories used by Memcached exist and have proper ownership and permissions
for dir in "${MEMCACHED_CONF_DIR}" "${SASL_CONF_PATH}"; do
    ensure_dir_exists "${dir}"
    chmod -R g+rwX "${dir}"
done
