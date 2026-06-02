#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Enable job control
# ref https://www.gnu.org/software/bash/manual/bash.html#The-Set-Builtin
set -m

# Load Redis environment variables
. /opt/bitnami/scripts/redis-cluster-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/librediscluster.sh

read -ra nodes <<< "$(tr ',;' ' ' <<< "${REDIS_NODES}")"

args=("${REDIS_BASE_DIR}/etc/redis.conf" "--daemonize" "no")
# Add flags specified via the 'REDIS_EXTRA_FLAGS' environment variable
read -r -a extra_flags <<< "$REDIS_EXTRA_FLAGS"
[[ "${#extra_flags[@]}" -gt 0 ]] && args+=("${extra_flags[@]}")
# Add flags passed to this script
args+=("$@")

if is_boolean_yes "$REDIS_CLUSTER_CREATOR" && ! [[ -f "${REDIS_DATA_DIR}/nodes.conf" ]]; then
    # Start Redis in background
    if am_i_root; then
        run_as_user "$REDIS_DAEMON_USER" redis-server "${args[@]}" &
    else
        redis-server "${args[@]}" &
    fi
    # Create the cluster
    redis_cluster_create "${nodes[@]}"
    # Bring redis process to foreground
    fg
else
    if am_i_root; then
        exec_as_user "$REDIS_DAEMON_USER" redis-server "${args[@]}"
    else
        exec redis-server "${args[@]}"
    fi
fi
