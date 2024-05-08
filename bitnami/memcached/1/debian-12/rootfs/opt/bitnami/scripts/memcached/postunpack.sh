#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libmemcached.sh
. /opt/bitnami/scripts/libfs.sh

# Load Memcached environment variables
. /opt/bitnami/scripts/memcached-env.sh

# Ensure directories used by Memcached exist and have proper ownership and permissions
for dir in "$MEMCACHED_CONF_DIR" "$MEMCACHED_DEFAULT_CONF_DIR" "$SASL_CONF_PATH"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "${MEMCACHED_CONF_DIR}/"* "$MEMCACHED_DEFAULT_CONF_DIR"