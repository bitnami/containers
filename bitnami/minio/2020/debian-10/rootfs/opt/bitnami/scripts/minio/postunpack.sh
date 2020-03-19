#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libminio.sh

# Load MinIO environment variables
eval "$(minio_env)"

# Ensure non-root user has write permissions on a set of directories
for dir in "$MINIO_DATADIR" "$MINIO_CERTSDIR" "$MINIO_LOGDIR" "$MINIO_SECRETSDIR"; do
    ensure_dir_exists "$dir"
done
# Redirect all logging to stdout/stderr
ln -sf /dev/stdout "$MINIO_LOGDIR/minio-http.log"
chmod -R g+rwX "$MINIO_DATADIR" "$MINIO_CERTSDIR" "$MINIO_LOGDIR" "$MINIO_SECRETSDIR"

# Load MinIO Client environment variables
eval "$(minio_client_env)"

for dir in "$MINIO_CLIENT_BASEDIR" "$MINIO_CLIENT_CONFIGDIR"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$MINIO_CLIENT_BASEDIR" "$MINIO_CLIENT_CONFIGDIR"
