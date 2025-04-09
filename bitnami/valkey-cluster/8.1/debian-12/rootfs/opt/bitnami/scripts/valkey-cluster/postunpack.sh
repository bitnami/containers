#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Valkey environment variables
. /opt/bitnami/scripts/valkey-cluster-env.sh

# Load libraries
. /opt/bitnami/scripts/libvalkeycluster.sh
. /opt/bitnami/scripts/libfs.sh

for dir in "$VALKEY_VOLUME_DIR" "$VALKEY_DATA_DIR" "$VALKEY_BASE_DIR" "$VALKEY_CONF_DIR" "$VALKEY_DEFAULT_CONF_DIR"; do
    ensure_dir_exists "$dir"
done

cp "${VALKEY_BASE_DIR}/etc/valkey-default.conf" "$VALKEY_CONF_FILE"

info "Setting Valkey config file..."
valkey_conf_set port "$VALKEY_DEFAULT_PORT_NUMBER"
valkey_conf_set dir "$VALKEY_DATA_DIR"
valkey_conf_set pidfile "$VALKEY_PID_FILE"
valkey_conf_set daemonize no
valkey_conf_set cluster-enabled yes
valkey_conf_set cluster-config-file "${VALKEY_DATA_DIR}/nodes.conf"

chmod -R g+rwX  "$VALKEY_BASE_DIR" /bitnami/valkey

valkey_conf_set logfile "" # Log to stdout

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "${VALKEY_CONF_DIR}/"* "$VALKEY_DEFAULT_CONF_DIR"