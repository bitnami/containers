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

# Load ClickHouse Keeper environment variables
. /opt/bitnami/scripts/clickhouse-keeper-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file at /opt/bitnami/clickhouse-keeper/etc)
debug "Copying files from $CLICKHOUSE_KEEPER_DEFAULT_CONF_DIR to $CLICKHOUSE_KEEPER_CONF_DIR"
if [[ -w "$CLICKHOUSE_KEEPER_CONF_DIR" ]]; then
    cp -nr "$CLICKHOUSE_KEEPER_DEFAULT_CONF_DIR"/. "$CLICKHOUSE_KEEPER_CONF_DIR"
else
    error "The folder $CLICKHOUSE_KEEPER_CONF_DIR is not writable. This is likely because a read-only filesystem is used, please ensure you mount a writable volume on this path."
    exit 1
fi

if [[ "$1" = "/opt/bitnami/scripts/clickhouse-keeper/run.sh" ]]; then
    info "** Starting ClickHouse Keeper setup **"
    /opt/bitnami/scripts/clickhouse-keeper/setup.sh
    info "** ClickHouse Keeper setup finished! **"
fi

echo ""
exec "$@"
