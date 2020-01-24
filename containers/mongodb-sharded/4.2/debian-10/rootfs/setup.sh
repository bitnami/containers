#!/bin/bash
# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

# Load libraries
. /libfs.sh
. /libos.sh
. /libmongodb.sh
. /libmongodb-sharded.sh

# Load MongoDB env. variables
eval "$(mongodb_env)"
eval "$(mongodb_sharded_env)"

is_boolean_yes "$MONGODB_DISABLE_SYSTEM_LOG" && MONGODB_DISABLE_SYSTEM_LOG="true" || MONGODB_DISABLE_SYSTEM_LOG="false"
is_boolean_yes "$MONGODB_ENABLE_DIRECTORY_PER_DB" && MONGODB_ENABLE_DIRECTORY_PER_DB="true" || MONGODB_ENABLE_DIRECTORY_PER_DB="false"
is_boolean_yes "$MONGODB_ENABLE_IPV6" && MONGODB_ENABLE_IPV6="true" || MONGODB_ENABLE_IPV6="false"

# Ensure MongoDB env var settings are valid
mongodb_sharded_validate
# Ensure MongoDB is stopped when this script ends.
trap "mongodb_stop" EXIT
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$MONGODB_DAEMON_USER" "$MONGODB_DAEMON_GROUP"

# Ensure MongoDB is initialized
if [[ "$MONGODB_SHARDING_MODE" = "mongos" ]]; then
    mongodb_sharded_mongos_initialize
else
    mongodb_sharded_mongod_initialize
fi

mongodb_set_listen_all_conf

# Allow running custom initialization scripts
mongodb_custom_init_scripts
