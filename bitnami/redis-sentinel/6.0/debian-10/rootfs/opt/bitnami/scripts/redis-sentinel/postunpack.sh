#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

. /opt/bitnami/scripts/libredissentinel.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh

# Load Redis environment
eval "$(redis_env)"

# Ensure non-root user has write permissions on a set of directories
for dir in "$REDIS_SENTINEL_BASE_DIR" "$REDIS_SENTINEL_CONF_DIR" "$REDIS_SENTINEL_LOG_DIR" "$REDIS_SENTINEL_TMP_DIR" "$REDIS_SENTINEL_VOLUME_DIR" "$REDIS_SENTINEL_VOLUME_DIR/conf"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

ln -sf "/dev/stdout" "${REDIS_SENTINEL_LOG_FILE}"
