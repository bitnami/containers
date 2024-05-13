#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libjanusgraph.sh
. /opt/bitnami/scripts/libfs.sh

# Load JanusGraph environment variables
. /opt/bitnami/scripts/janusgraph-env.sh

# Ensure directories used by JanusGraph exist and have proper ownership and permissions
for dir in "$JANUSGRAPH_VOLUME_DIR" "$JANUSGRAPH_CONF_DIR" "$JANUSGRAPH_DATA_DIR" "$JANUSGRAPH_LOGS_DIR" "${JANUSGRAPH_BASE_DIR}/scripts" "$JANUSGRAPH_MOUNTED_CONF_DIR" "$JANUSGRAPH_DEFAULT_CONF_DIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -g "root" -d "775" -f "664"
done

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "${JANUSGRAPH_CONF_DIR}/"* "$JANUSGRAPH_DEFAULT_CONF_DIR"
