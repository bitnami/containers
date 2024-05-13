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
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libzookeeper.sh

# Load ZooKeeper environment variables
. /opt/bitnami/scripts/zookeeper-env.sh

# Ensure ZooKeeper environment variables are valid
zookeeper_validate
# Ensure ZooKeeper user and group exist when running as 'root'
if am_i_root; then
    ensure_user_exists "$ZOO_DAEMON_USER" --group "$ZOO_DAEMON_GROUP"
    ZOOKEEPER_OWNERSHIP_USER="$ZOO_DAEMON_USER"
else
    ZOOKEEPER_OWNERSHIP_USER=""
fi
# Ensure directories used by ZooKeeper exist and have proper ownership and permissions
for dir in "$ZOO_DATA_DIR" "$ZOO_CONF_DIR" "$ZOO_LOG_DIR"; do
    ensure_dir_exists "$dir" "$ZOOKEEPER_OWNERSHIP_USER"
done
# Ensure ZooKeeper is initialized
zookeeper_initialize
