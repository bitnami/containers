#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Neo4j environment
. /opt/bitnami/scripts/neo4j-env.sh

# Load MongoDB&reg; Client environment for 'mongodb_remote_execute' (after 'neo4j-env.sh' so that MODULE is not set to a wrong value)
if [[ -f /opt/bitnami/scripts/mongodb-client-env.sh ]]; then
    . /opt/bitnami/scripts/mongodb-client-env.sh
elif [[ -f /opt/bitnami/scripts/mongodb-env.sh ]]; then
    . /opt/bitnami/scripts/mongodb-env.sh
fi

# Load libraries
. /opt/bitnami/scripts/libneo4j.sh

# Ensure Neo4j environment variables are valid
neo4j_validate

# Ensure Neo4j daemon user exists when running as 'root'
am_i_root && ensure_user_exists "$NEO4J_DAEMON_USER" --group "$NEO4J_DAEMON_GROUP"

# Initialize Neo4j
neo4j_initialize

# Allow custom init scripts
neo4j_custom_init_scripts
