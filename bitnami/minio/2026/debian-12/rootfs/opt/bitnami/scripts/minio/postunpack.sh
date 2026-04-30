#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libminio.sh

# Load MinIO environment
. /opt/bitnami/scripts/minio-env.sh

# Ensure non-root user has write permissions on a set of directories
for dir in "$MINIO_DATA_DIR" "$MINIO_CERTS_DIR" "$MINIO_LOGS_DIR" "$MINIO_TMP_DIR" "$MINIO_SECRETS_DIR"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$MINIO_DATA_DIR" "$MINIO_CERTS_DIR" "$MINIO_LOGS_DIR" "$MINIO_SECRETS_DIR" "$MINIO_TMP_DIR"

# Redirect all logging to stdout/stderr
ln -sf /dev/stdout "$MINIO_LOGS_DIR/minio-http.log"
