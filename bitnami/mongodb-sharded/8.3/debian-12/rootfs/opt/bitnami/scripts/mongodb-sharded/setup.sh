#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libmongodb.sh
. /opt/bitnami/scripts/libmongodb-sharded.sh

# Load MongoDB env. variables
. /opt/bitnami/scripts/mongodb-env.sh

is_boolean_yes "$MONGODB_DISABLE_SYSTEM_LOG" && MONGODB_DISABLE_SYSTEM_LOG="true" || MONGODB_DISABLE_SYSTEM_LOG="false"
is_boolean_yes "$MONGODB_ENABLE_DIRECTORY_PER_DB" && MONGODB_ENABLE_DIRECTORY_PER_DB="true" || MONGODB_ENABLE_DIRECTORY_PER_DB="false"
is_boolean_yes "$MONGODB_ENABLE_IPV6" && MONGODB_ENABLE_IPV6="true" || MONGODB_ENABLE_IPV6="false"

# Ensure MongoDB env var settings are valid
mongodb_sharded_validate
# Ensure MongoDB is stopped when this script ends.
trap "mongodb_stop" EXIT
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$MONGODB_DAEMON_USER" --group "$MONGODB_DAEMON_GROUP"

# Ensure directories used by MongoDB exist and have proper ownership and permissions
for dir in "$MONGODB_TMP_DIR" "$MONGODB_LOG_DIR" "$MONGODB_DATA_DIR"; do
    ensure_dir_exists "$dir"
    am_i_root && chown -R "${MONGODB_DAEMON_USER}:${MONGODB_DAEMON_GROUP}" "$dir"
done

# Ensure MongoDB is initialized
if [[ "$MONGODB_SHARDING_MODE" = "mongos" ]]; then
    mongodb_sharded_mongos_initialize
else
    mongodb_sharded_mongod_initialize
fi

# Allow running custom initialization scripts
mongodb_custom_init_scripts
