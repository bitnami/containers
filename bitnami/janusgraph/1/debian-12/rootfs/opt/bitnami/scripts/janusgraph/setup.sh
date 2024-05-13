#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libjanusgraph.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh

# Load JanusGraph environment variables
. /opt/bitnami/scripts/janusgraph-env.sh

# Ensure JanusGraph environment variables are valid
janusgraph_validate

# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$JANUSGRAPH_DAEMON_USER" --group "$JANUSGRAPH_DAEMON_GROUP"
for dir in "$JANUSGRAPH_CONF_DIR" "$JANUSGRAPH_DATA_DIR" "$JANUSGRAPH_LOGS_DIR"; do
    ensure_dir_exists "$dir"
    am_i_root && chown -R "${JANUSGRAPH_DAEMON_USER}:${JANUSGRAPH_DAEMON_GROUP}" "$dir"
done

# Ensure JanusGraph is initialized
janusgraph_initialize
