#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libinfluxdb.sh

# Load InfluxDB environment variables
. /opt/bitnami/scripts/influxdb-env.sh

print_welcome_page

if ! is_dir_empty "$INFLUXDB_DEFAULT_CONF_DIR"; then
    # We add the copy from default config in the entrypoint to not break users 
    # bypassing the setup.sh logic. If the file already exists do not overwrite (in
    # case someone mounts a configuration file in /opt/bitnami/influxdb/etc)
    debug "Copying files from $INFLUXDB_DEFAULT_CONF_DIR to $INFLUXDB_CONF_DIR"
    cp -nr "$INFLUXDB_DEFAULT_CONF_DIR"/. "$INFLUXDB_CONF_DIR"
fi

if [[ "$*" = *"/opt/bitnami/scripts/influxdb/run.sh"* ]]; then
    info "** Starting InfluxDB setup **"
    /opt/bitnami/scripts/influxdb/setup.sh
    info "** InfluxDB setup finished! **"
fi

echo ""
exec "$@"
