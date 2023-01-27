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
. /opt/bitnami/scripts/influxdb-env.sh

info "** Starting InfluxDB **"
start_command=("${INFLUXDB_BIN_DIR}/influxd" "$@")
am_i_root && start_command=("gosu" "$INFLUXDB_DAEMON_USER" "${start_command[@]}")

if [[ -f "$INFLUXDB_CONF_FILE" ]]; then
  export INFLUXD_CONFIG_PATH=${INFLUXDB_CONF_FILE:-}
fi

export HOME=/bitnami/influxdb/

exec "${start_command[@]}"
