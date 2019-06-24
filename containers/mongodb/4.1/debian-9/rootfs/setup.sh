#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# shellcheck disable=SC1091

# Load libraries
. /libfs.sh
. /libos.sh
. /libmongodb.sh

# Load MongoDB env. variables
eval "$(mongodb_env)"

is_boolean_yes "$MONGODB_DISABLE_SYSTEM_LOG" && MONGODB_DISABLE_SYSTEM_LOG="true" || MONGODB_DISABLE_SYSTEM_LOG="false"
is_boolean_yes "$MONGODB_ENABLE_DIRECTORY_PER_DB" && MONGODB_ENABLE_DIRECTORY_PER_DB="true" || MONGODB_ENABLE_DIRECTORY_PER_DB="false"
is_boolean_yes "$MONGODB_ENABLE_IPV6" && MONGODB_ENABLE_IPV6="true" || MONGODB_ENABLE_IPV6="false"

# Ensure MySQL env var settings are valid
mongodb_validate
# Ensure MongoDB is stopped when this script ends.
trap "mongodb_stop" EXIT
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$MONGODB_DAEMON_USER" "$MONGODB_DAEMON_GROUP"

# Ensure MongoDB is initialized
mongodb_initialize
