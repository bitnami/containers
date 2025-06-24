#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libinfluxdb.sh

# Load InfluxDB environment variables
. /opt/bitnami/scripts/influxdb-env.sh

ensure_user_exists "$INFLUXDB_DAEMON_USER" --group "$INFLUXDB_DAEMON_GROUP"

# Ensure directories used by InfluxDB exist and have proper ownership and permissions
dirs_to_exist=("$INFLUXDB_VOLUME_DIR" "$INFLUXDB_INITSCRIPTS_DIR")
[[ ! -f "${INFLUXDB_BIN_DIR}/influxdb3" ]] && dirs_to_exist+=("$INFLUXDB_CONF_DIR" "$INFLUXDB_DEFAULT_CONF_DIR")
for dir in "${dirs_to_exist[@]}"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
    chown -R "${INFLUXDB_DAEMON_USER}:root" "$dir"
done

if [[ ! -f "${INFLUXDB_BIN_DIR}/influxdb3" ]]; then
    touch "/.influx_history" && chmod g+rwX "/.influx_history"
    if ! is_dir_empty "$INFLUXDB_CONF_DIR"; then
        # Copy all initially generated configuration files to the default directory
        # (this is to avoid breaking when entrypoint is being overridden)
        cp -r "${INFLUXDB_CONF_DIR}/"* "$INFLUXDB_DEFAULT_CONF_DIR"
    fi
fi
