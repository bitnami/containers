#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libredis.sh
. /opt/bitnami/scripts/libfs.sh

# Load Redis environment variables
eval "$(redis_env)"

for dir in "$REDIS_VOLUME" "${REDIS_VOLUME}/data" ; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX /bitnami "$REDIS_VOLUME" "$REDIS_BASEDIR"
