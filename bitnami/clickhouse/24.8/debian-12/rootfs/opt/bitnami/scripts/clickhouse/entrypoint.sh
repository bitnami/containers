#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load ClickHouse environment variables
. /opt/bitnami/scripts/clickhouse-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users 
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/clickhouse/etc)
debug "Copying files from $CLICKHOUSE_DEFAULT_CONF_DIR to $CLICKHOUSE_CONF_DIR"
cp -nr "$CLICKHOUSE_DEFAULT_CONF_DIR"/. "$CLICKHOUSE_CONF_DIR"

if [[ "$1" = "/opt/bitnami/scripts/clickhouse/run.sh" ]]; then
    info "** Starting ClickHouse setup **"
    /opt/bitnami/scripts/clickhouse/setup.sh
    info "** ClickHouse setup finished! **"
fi

echo ""
exec "$@"
