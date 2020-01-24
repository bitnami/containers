#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /libfs.sh
. /libinfluxdb.sh

# Load InfluxDB environment variables
eval "$(influxdb_env)"

# Ensure directories used by InfluxDB exist and have proper ownership and permissions
for dir in "$INFLUXDB_DATA_DIR" "$INFLUXDB_DATA_WAL_DIR" "$INFLUXDB_META_DIR" "$INFLUXDB_CONF_DIR" "$INFLUXDB_INITSCRIPTS_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

touch "$HOME/.influx_history" && chmod g+rwX "$HOME/.influx_history"
