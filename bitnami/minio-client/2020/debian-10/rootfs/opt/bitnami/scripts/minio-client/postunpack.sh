#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libminioclient.sh

# Load MinIO Client environment variables
eval "$(minio_client_env)"

for dir in "$MINIO_CLIENT_BASEDIR" "$MINIO_CLIENT_CONFIGDIR"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$MINIO_CLIENT_BASEDIR" "$MINIO_CLIENT_CONFIGDIR"
