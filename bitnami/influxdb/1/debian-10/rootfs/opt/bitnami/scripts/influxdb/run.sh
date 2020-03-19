#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libinfluxdb.sh

# Load InfluxDB environment variables
eval "$(influxdb_env)"

info "** Starting InfluxDB **"
start_command=("${INFLUXDB_BIN_DIR}/influxd" "-config" "$INFLUXDB_CONF_FILE" "$@")
am_i_root && start_command=("gosu" "$INFLUXDB_DAEMON_USER" "${start_command[@]}")

exec "${start_command[@]}"
