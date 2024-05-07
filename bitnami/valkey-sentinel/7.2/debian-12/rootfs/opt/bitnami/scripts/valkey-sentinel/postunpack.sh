#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Valkey Sentinel environment variables
. /opt/bitnami/scripts/valkey-sentinel-env.sh

# Load libraries
. /opt/bitnami/scripts/libvalkeysentinel.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh

# Ensure non-root user has write permissions on a set of directories
for dir in "$VALKEY_SENTINEL_BASE_DIR" "$VALKEY_SENTINEL_CONF_DIR" "$VALKEY_SENTINEL_LOG_DIR" "$VALKEY_SENTINEL_TMP_DIR" "$VALKEY_SENTINEL_VOLUME_DIR" "${VALKEY_SENTINEL_VOLUME_DIR}/conf" "$VALKEY_SENTINEL_DEFAULT_CONF_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# Valkey Sentinel defaults
valkey_conf_set "port" "$VALKEY_SENTINEL_DEFAULT_PORT_NUMBER"
valkey_conf_set "bind" "0.0.0.0"
valkey_conf_set "pidfile" "$VALKEY_SENTINEL_PID_FILE"
# Send logs to stdout
valkey_conf_set "daemonize" "no"
valkey_conf_set "logfile" ""

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "${VALKEY_SENTINEL_CONF_DIR}/"* "$VALKEY_SENTINEL_DEFAULT_CONF_DIR"
