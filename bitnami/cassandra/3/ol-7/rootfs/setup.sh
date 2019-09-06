#!/bin/bash
#
# Bitnami Cassandra setup

# shellcheck disable=SC1090
# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

# Load Generic Libraries
. /libvalidations.sh
. /libos.sh
. /libcassandra.sh

# Load Cassandra environment variables
eval "$(cassandra_env)"

# Ensure Cassandra environment variables settings are valid
cassandra_validate
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$CASSANDRA_DAEMON_USER" "$CASSANDRA_DAEMON_GROUP"
# Ensure Cassandra is initialized
cassandra_initialize

# Allow running custom initialization scripts
if ! is_boolean_yes "$CASSANDRA_IGNORE_INITDB_SCRIPTS"; then
    cassandra_custom_init_scripts
fi