#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/librediscluster.sh
. /opt/bitnami/scripts/libfs.sh

# Load Redis environment variables
eval "$(redis_cluster_env)"

for dir in "${REDIS_VOLUME}/data" $REDIS_BASEDIR "${REDIS_BASEDIR}/etc"; do
    ensure_dir_exists "$dir"
done

chmod -R g+rwX  "$REDIS_BASEDIR" /bitnami/redis
