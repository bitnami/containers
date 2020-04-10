#!/bin/bash

# shellcheck disable=SC1091
# shellcheck disable=SC1090

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/librediscluster.sh

# Load Redis environment variables
eval "$(redis_cluster_env)"

IFS=' ' read -ra nodes <<< "$REDIS_NODES"

if ! is_boolean_yes "$REDIS_CLUSTER_CREATOR"; then

  # Constants
  EXEC=$(command -v redis-server)

  ARGS=("--port" "$REDIS_PORT")
  ARGS+=("--include" "${REDIS_BASEDIR}/etc/redis.conf")

  if ! is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
    ARGS+=("--requirepass" "$REDIS_PASSWORD")
    ARGS+=("--masterauth" "$REDIS_PASSWORD")
  else
    ARGS+=("--protected-mode" "no")
  fi

  if am_i_root; then
      exec gosu "$REDIS_DAEMON_USER" "$EXEC" "${ARGS[@]}"
  else
      exec "$EXEC" "${ARGS[@]}"
  fi

else
  redis_cluster_create "${nodes[@]}"
fi
