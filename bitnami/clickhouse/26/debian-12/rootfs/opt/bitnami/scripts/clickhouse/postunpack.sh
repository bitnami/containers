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
. /opt/bitnami/scripts/libclickhouse.sh

# Load ClickHouse environment variables
. /opt/bitnami/scripts/clickhouse-env.sh

# System User
ensure_user_exists "$CLICKHOUSE_DAEMON_USER" --group "$CLICKHOUSE_DAEMON_GROUP" --system

# Create directories
for dir in "$CLICKHOUSE_DATA_DIR" "$CLICKHOUSE_CONF_DIR" "${CLICKHOUSE_CONF_DIR}/conf.d" "${CLICKHOUSE_CONF_DIR}/config.d" "${CLICKHOUSE_CONF_DIR}/users.d" "$CLICKHOUSE_DEFAULT_CONF_DIR" "$CLICKHOUSE_LOG_DIR" "$CLICKHOUSE_TMP_DIR" "$CLICKHOUSE_MOUNTED_CONF_DIR" "/docker-entrypoint-startdb.d" "/docker-entrypoint-initdb.d"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$CLICKHOUSE_DAEMON_USER" -g "root"
done

# Set default settings in the configuration file

# Delete default cluster configurations (it contains example configurations that adds noise) and add an empty one
xmlstarlet ed -L -d "/clickhouse/remote_servers" "$CLICKHOUSE_CONF_FILE"

# Set paths
clickhouse_conf_set "/clickhouse/path" "$CLICKHOUSE_DATA_DIR"
clickhouse_conf_set "/clickhouse/logger/log" "$CLICKHOUSE_LOG_FILE"
clickhouse_conf_set "/clickhouse/logger/errorlog" "$CLICKHOUSE_ERROR_LOG_FILE"

# ClickHouse allow making settings point to environment variables. This change
# will simplify the container logic substantially because we won't need to modify
# the xml files at runtime
# Source: https://clickhouse.com/docs/en/operations/server-configuration-parameters/settings/
env_vars_mapping=(
    "http_port=CLICKHOUSE_HTTP_PORT"
    "tcp_port=CLICKHOUSE_TCP_PORT"
    "mysql_port=CLICKHOUSE_MYSQL_PORT"
    "postgresql_port=CLICKHOUSE_POSTGRESQL_PORT"
    "interserver_http_port=CLICKHOUSE_INTERSERVER_HTTP_PORT"
)

for pair in "${env_vars_mapping[@]}"; do
    setting="${pair%=*}"
    env_var="${pair#*=}"
    # Delete the existing node
    xmlstarlet ed -L -d "/clickhouse/${setting}" "$CLICKHOUSE_CONF_FILE"
    # Recreate the node so it has the following structure
    # <NAME_OF_THE_SETTING from_env="NAME_OF_THE_ENVVAR" />
    clickhouse_conf_set "/clickhouse/${setting}"
    xmlstarlet ed -L --insert "/clickhouse/${setting}" -type attr -n "from_env" -v "${env_var}" "$CLICKHOUSE_CONF_FILE"
done

# Set default password to point to the CLICKHOUSE_ADMIN_PASSWORD variable
xmlstarlet ed -L --insert "/clickhouse/users/default/password" -type attr -n "from_env" -v "CLICKHOUSE_ADMIN_PASSWORD" "${CLICKHOUSE_CONF_DIR}/users.xml"

# Add symlinks to the default paths to make a similar UX as the upstream ClickHouse configuration
# https://github.com/ClickHouse/ClickHouse/blob/master/programs/server/config.xml
ln -s "$CLICKHOUSE_DATA_DIR" "/var/lib/clickhouse"
ln -s "$CLICKHOUSE_CONF_DIR" "/etc/clickhouse-server"
ln -s "$CLICKHOUSE_LOG_DIR" "/var/log/clickhouse-server"
ln -s "$CLICKHOUSE_TMP_DIR" "/var/lib/clickhouse/tmp"

# ClickHouse uses some algorithms that are not FIPS compliant
# hence we cannot import the FIPS configuration for OpenSSL
# ref: https://vmw-jira.broadcom.net/browse/TNZ-25623
if [[ "$(get_os_metadata --id)" == "photon" ]]; then
    remove_in_file "/etc/ssl/distro.cnf" "\.include \/etc\/ssl\/provider_fips\.cnf"
fi

ln -s /dev/stdout "$CLICKHOUSE_LOG_FILE"
ln -s /dev/stderr "$CLICKHOUSE_ERROR_LOG_FILE"

touch /.clickhouse-client-history
chmod g+rw /.clickhouse-client-history

# Set logging to console
xmlstarlet ed -L -d "/clickhouse/logger/log" "$CLICKHOUSE_CONF_FILE"
xmlstarlet ed -L -d "/clickhouse/logger/errorlog" "$CLICKHOUSE_CONF_FILE"
clickhouse_conf_set "/clickhouse/logger/console" "1"

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "${CLICKHOUSE_CONF_DIR}/"* "$CLICKHOUSE_DEFAULT_CONF_DIR"