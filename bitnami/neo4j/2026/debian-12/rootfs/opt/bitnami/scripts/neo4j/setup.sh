#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Neo4j environment
. /opt/bitnami/scripts/neo4j-env.sh

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
