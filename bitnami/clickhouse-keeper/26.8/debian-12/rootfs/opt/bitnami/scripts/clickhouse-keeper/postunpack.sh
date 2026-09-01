#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libclickhousekeeper.sh

# Load ClickHouse Keeper environment variables
. /opt/bitnami/scripts/clickhouse-keeper-env.sh

# System User
ensure_user_exists "$CLICKHOUSE_DAEMON_USER" --group "$CLICKHOUSE_DAEMON_GROUP" --system

# Create directories
for dir in "$CLICKHOUSE_KEEPER_VOLUME_DIR" "$CLICKHOUSE_KEEPER_DATA_DIR" "$CLICKHOUSE_KEEPER_COORD_LOGS_DIR" "$CLICKHOUSE_KEEPER_COORD_SNAPSHOTS_DIR" "$CLICKHOUSE_KEEPER_CONF_DIR" "$CLICKHOUSE_KEEPER_DEFAULT_CONF_DIR" "$CLICKHOUSE_KEEPER_LOG_DIR" "$CLICKHOUSE_KEEPER_TMP_DIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$CLICKHOUSE_DAEMON_USER" -g "root"
done

# Set default settings in the configuration file

# Set paths
keeper_conf_set "/clickhouse/keeper_server/log_storage_path" "$CLICKHOUSE_KEEPER_COORD_LOGS_DIR"
keeper_conf_set "/clickhouse/keeper_server/snapshot_storage_path" "$CLICKHOUSE_KEEPER_COORD_SNAPSHOTS_DIR"
keeper_conf_set "/clickhouse/logger/log" "$CLICKHOUSE_KEEPER_LOG_FILE"
keeper_conf_set "/clickhouse/logger/errorlog" "$CLICKHOUSE_KEEPER_ERROR_LOG_FILE"

# ClickHouse allow making settings point to environment variables. This change
# will simplify the container logic substantially because we won't need to modify
# the xml files at runtime
# ref: https://clickhouse.com/docs/en/operations/server-configuration-parameters/settings/
xmlstarlet ed -L -d "/clickhouse/keeper_server/tcp_port" "$CLICKHOUSE_KEEPER_CONF_FILE"
keeper_conf_set "/clickhouse/keeper_server/tcp_port"
xmlstarlet ed -L --insert "/clickhouse/keeper_server/tcp_port" -type attr -n "from_env" -v "CLICKHOUSE_KEEPER_TCP_PORT" "$CLICKHOUSE_KEEPER_CONF_FILE"
xmlstarlet ed -L -d "/clickhouse/keeper_server/raft_configuration/server/port" "$CLICKHOUSE_KEEPER_CONF_FILE"
keeper_conf_set "/clickhouse/keeper_server/raft_configuration/server/port"
xmlstarlet ed -L --insert "/clickhouse/keeper_server/raft_configuration/server/port" -type attr -n "from_env" -v "CLICKHOUSE_KEEPER_RAFT_PORT" "$CLICKHOUSE_KEEPER_CONF_FILE"

# Add symlinks to the default paths to make a similar UX as the upstream ClickHouse Keeper configuration
# https://github.com/ClickHouse/ClickHouse/blob/master/programs/keeper/keeper_config.xml
ln -s "$CLICKHOUSE_KEEPER_VOLUME_DIR" "/var/lib/clickhouse-keeper"
ln -s "$CLICKHOUSE_KEEPER_LOG_DIR" "/var/log/clickhouse-keeper"

# ClickHouse Keeper uses some algorithms that are not FIPS compliant
# hence we cannot import the FIPS configuration for OpenSSL
# ref: https://vmw-jira.broadcom.net/browse/TNZ-25623
if [[ "$(get_os_metadata --id)" == "photon" ]]; then
    remove_in_file "/etc/ssl/distro.cnf" "\.include \/etc\/ssl\/provider_fips\.cnf"
fi

# Redirect logs to stdout/stderr
ln -s /dev/stdout "$CLICKHOUSE_KEEPER_LOG_FILE"
ln -s /dev/stderr "$CLICKHOUSE_KEEPER_ERROR_LOG_FILE"

touch /.clickhouse-keeper-client-history
chmod g+rw /.clickhouse-keeper-client-history

# Set logging to console
xmlstarlet ed -L -d "/clickhouse/logger/log" "$CLICKHOUSE_KEEPER_CONF_FILE"
xmlstarlet ed -L -d "/clickhouse/logger/errorlog" "$CLICKHOUSE_KEEPER_CONF_FILE"
keeper_conf_set "/clickhouse/logger/console" "1"
keeper_conf_set "/clickhouse/logger/level" "information"

# Move all initially generated configuration files to the default directory
# so users can skip initialization logic by mounting their own configuration directly
mv "${CLICKHOUSE_KEEPER_CONF_DIR}"/* "$CLICKHOUSE_KEEPER_DEFAULT_CONF_DIR"/
