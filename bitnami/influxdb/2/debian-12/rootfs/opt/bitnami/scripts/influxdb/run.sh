#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

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
export HOME=/bitnami/influxdb/

if am_i_root; then
    exec_as_user "$INFLUXDB_DAEMON_USER" "${INFLUXDB_BIN_DIR}/influxd" "$@"
else
    exec "${INFLUXDB_BIN_DIR}/influxd" "$@"
fi
