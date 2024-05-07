#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Valkey environment variables
. /opt/bitnami/scripts/valkey-env.sh

# Load libraries
. /opt/bitnami/scripts/libvalkey.sh
. /opt/bitnami/scripts/libfs.sh

for dir in "$VALKEY_VOLUME_DIR" "$VALKEY_DATA_DIR" "$VALKEY_BASE_DIR" "$VALKEY_CONF_DIR" "$VALKEY_DEFAULT_CONF_DIR"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX /bitnami "$VALKEY_VOLUME_DIR" "$VALKEY_BASE_DIR"

cp "${VALKEY_BASE_DIR}/etc/valkey-default.conf" "$VALKEY_CONF_FILE"
chmod g+rw "$VALKEY_CONF_FILE"
# Default Valkey config
info "Setting Valkey config file..."
valkey_conf_set port "$VALKEY_DEFAULT_PORT_NUMBER"
valkey_conf_set dir "$VALKEY_DATA_DIR"
valkey_conf_set pidfile "$VALKEY_PID_FILE"
valkey_conf_set daemonize yes

valkey_conf_set logfile "" # Log to stdout

# Disable RDB persistence, AOF persistence already enabled.
# Ref: https://valkey.io/topics/persistence#interactions-between-aof-and-rdb-persistence
# Ref 2: https://github.com/bitnami/bitnami-docker-valkey/pull/115
valkey_conf_set save ""

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "${VALKEY_CONF_DIR}/"* "$VALKEY_DEFAULT_CONF_DIR"
