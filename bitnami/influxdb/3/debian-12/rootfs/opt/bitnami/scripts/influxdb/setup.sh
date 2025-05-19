#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

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
. /opt/bitnami/scripts/influxdb-env.sh

# Ensure InfluxDB environment variables are valid
influxdb_validate
# Ensure InfluxDB user and group exist when running as 'root'
if am_i_root; then
    chown -R "$INFLUXDB_DAEMON_USER" "$INFLUXDB_VOLUME_DIR" "$INFLUXDB_CONF_DIR"
fi
# Ensure InfluxDB is stopped when this script ends.
trap "influxdb_stop" EXIT
# Ensure InfluxDB is initialized
influxdb_initialize
# Allow running custom initialization scripts
influxdb_custom_init_scripts
