#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Redis environment variables
. /opt/bitnami/scripts/redis-cluster-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/librediscluster.sh

IFS=' ' read -ra nodes <<< "$REDIS_NODES"

if ! is_boolean_yes "$REDIS_CLUSTER_CREATOR"; then
    ARGS=("--port" "$REDIS_PORT_NUMBER")
    ARGS+=("--include" "${REDIS_BASE_DIR}/etc/redis.conf")

    if ! is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        ARGS+=("--requirepass" "$REDIS_PASSWORD")
        ARGS+=("--masterauth" "$REDIS_PASSWORD")
    else
        ARGS+=("--protected-mode" "no")
    fi

    ARGS+=("$@")

    if am_i_root; then
        exec gosu "$REDIS_DAEMON_USER" redis-server "${ARGS[@]}"
    else
        exec redis-server "${ARGS[@]}"
    fi
else
    redis_cluster_create "${nodes[@]}"
fi
