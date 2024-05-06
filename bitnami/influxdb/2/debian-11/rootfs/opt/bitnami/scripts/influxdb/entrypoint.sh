#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libinfluxdb.sh

# Load InfluxDB environment variables
. /opt/bitnami/scripts/influxdb-env.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/influxdb/run.sh"* ]]; then
    info "** Starting InfluxDB setup **"
    /opt/bitnami/scripts/influxdb/setup.sh
    info "** InfluxDB setup finished! **"
fi

echo ""
exec "$@"
