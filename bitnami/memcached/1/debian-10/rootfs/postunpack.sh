#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /libmemcached.sh
. /libfs.sh

# Load Memcached environment variables
eval "$(memcached_env)"

# Ensure directories used by Memcached exist and have proper ownership and permissions
for dir in "${MEMCACHED_CONF_DIR}" "${SASL_CONF_PATH}"; do
    ensure_dir_exists "${dir}"
    chmod -R g+rwX "${dir}"
done
