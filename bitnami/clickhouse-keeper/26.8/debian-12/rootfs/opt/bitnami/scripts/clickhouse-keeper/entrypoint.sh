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
. /opt/bitnami/scripts/libfs.sh
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
# For compatibility with running the image via Altiny's Operator, we need to
# ensure the specific config files mounted at /etc/clickhouse-keeper
# are copied to Bitnami's config directory
[[ -f "/etc/clickhouse-keeper/keeper_config.xml" ]] && cp "/etc/clickhouse-keeper/keeper_config.xml" "$CLICKHOUSE_KEEPER_CONF_FILE"
for dir in "conf.d" "keeper_config.d" "users.d"; do
  ! is_mounted_dir_empty "/etc/clickhouse-keeper/${dir}" && cp -r "/etc/clickhouse-keeper/${dir}" "$CLICKHOUSE_KEEPER_CONF_DIR"
done

if [[ "$1" = "/opt/bitnami/scripts/clickhouse-keeper/run.sh" ]]; then
    info "** Starting ClickHouse Keeper setup **"
    /opt/bitnami/scripts/clickhouse-keeper/setup.sh
    info "** ClickHouse Keeper setup finished! **"
fi

echo ""
exec "$@"
