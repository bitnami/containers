#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libspark.sh

# Load Spark environment settings
. /opt/bitnami/scripts/spark-env.sh

for dir in "$SPARK_TMP_DIR" "$SPARK_LOG_DIR" "$SPARK_CONF_DIR" "$SPARK_DEFAULT_CONF_DIR" "$SPARK_WORK_DIR" "$SPARK_JARS_DIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664" -g "root"
done

# Set correct owner in installation directory
chown -R "1001:root" "$SPARK_BASE_DIR"

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "${SPARK_CONF_DIR}/"* "$SPARK_DEFAULT_CONF_DIR"