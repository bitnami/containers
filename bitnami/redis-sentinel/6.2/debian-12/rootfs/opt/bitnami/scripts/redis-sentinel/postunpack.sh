#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Redis Sentinel environment variables
. /opt/bitnami/scripts/redis-sentinel-env.sh

# Load libraries
. /opt/bitnami/scripts/libredissentinel.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh

# Ensure non-root user has write permissions on a set of directories
for dir in "$REDIS_SENTINEL_BASE_DIR" "$REDIS_SENTINEL_CONF_DIR" "$REDIS_SENTINEL_LOG_DIR" "$REDIS_SENTINEL_TMP_DIR" "$REDIS_SENTINEL_VOLUME_DIR" "${REDIS_SENTINEL_VOLUME_DIR}/conf" "$REDIS_SENTINEL_DEFAULT_CONF_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# Redis Sentinel defaults
redis_conf_set "port" "$REDIS_SENTINEL_DEFAULT_PORT_NUMBER"
redis_conf_set "bind" "0.0.0.0 ::"
redis_conf_set "pidfile" "$REDIS_SENTINEL_PID_FILE"
# Send logs to stdout
redis_conf_set "daemonize" "no"
redis_conf_set "logfile" ""

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "${REDIS_SENTINEL_CONF_DIR}/"* "$REDIS_SENTINEL_DEFAULT_CONF_DIR"