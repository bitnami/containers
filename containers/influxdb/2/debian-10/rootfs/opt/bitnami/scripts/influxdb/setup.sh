#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libinfluxdb.sh

# Load InfluxDB environment variables
eval "$(influxdb_env)"

# Ensure InfluxDB environment variables are valid
influxdb_validate
# Ensure InfluxDB user and group exist when running as 'root'
if am_i_root; then
    ensure_user_exists "$INFLUXDB_DAEMON_USER" --group "$INFLUXDB_DAEMON_GROUP"
    chown -R "$INFLUXDB_DAEMON_USER" "$INFLUXDB_DATA_DIR" "$INFLUXDB_CONF_DIR"
fi
# Ensure InfluxDB is stopped when this script ends.
trap "influxdb_stop" EXIT
# Ensure InfluxDB is initialized
influxdb_initialize
# Allow running custom initialization scripts
influxdb_custom_init_scripts
