#!/bin/bash

# shellcheck disable=SC1090

# Load libraries
. "${BITNAMI_SCRIPTS_DIR:-}"/libmemcached.sh
. "${BITNAMI_SCRIPTS_DIR:-}"/libfs.sh
. "${BITNAMI_SCRIPTS_DIR:-}"/libos.sh # used for resize

# Load Memcached environment variables
. "${BITNAMI_SCRIPTS_DIR:-}"/memcached-env.sh

info "Creating Memcached daemon user"
ensure_user_exists "${MEMCACHED_DAEMON_USER}" "${MEMCACHED_DAEMON_GROUP}"

# Ensure directories used by Memcached exist and have proper ownership and permissions
for dir in "${MEMCACHED_CONF_DIR}" "${SASL_CONF_PATH}"; do
    ensure_dir_exists "${dir}"
    chmod -R g+rwX "${dir}"
done
