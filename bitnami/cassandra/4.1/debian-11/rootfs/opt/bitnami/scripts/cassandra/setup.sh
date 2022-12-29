#!/bin/bash
#
# Bitnami Cassandra setup

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

# Load Generic Libraries
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libcassandra.sh

# Load Cassandra environment variables
. /opt/bitnami/scripts/cassandra-env.sh

# Set default Cassandra host environment variable
cassandra_set_default_host
# Ensure Cassandra environment variables settings are valid
cassandra_validate
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$CASSANDRA_DAEMON_USER" --group "$CASSANDRA_DAEMON_GROUP"
# Ensure Cassandra is initialized
cassandra_initialize

# Allow running custom initialization scripts
if ! is_boolean_yes "$CASSANDRA_IGNORE_INITDB_SCRIPTS"; then
    cassandra_custom_init_scripts
fi
