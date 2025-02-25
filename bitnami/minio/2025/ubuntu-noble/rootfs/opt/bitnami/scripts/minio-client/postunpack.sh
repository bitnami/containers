#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libminioclient.sh

# Load MinIO Client environment
. /opt/bitnami/scripts/minio-client-env.sh

for dir in "$MINIO_CLIENT_BASE_DIR" "$MINIO_CLIENT_CONF_DIR"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$MINIO_CLIENT_BASE_DIR" "$MINIO_CLIENT_CONF_DIR"
