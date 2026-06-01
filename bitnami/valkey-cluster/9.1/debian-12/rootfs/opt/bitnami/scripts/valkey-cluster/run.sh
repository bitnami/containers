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

# Load Valkey environment variables
. /opt/bitnami/scripts/valkey-cluster-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalkeycluster.sh

read -ra nodes <<< "$(tr ',;' ' ' <<< "${VALKEY_NODES}")"

args=("${REDIS_BASE_DIR}/etc/valkey.conf" "--daemonize" "no")
# Add flags specified via the 'VALKEY_EXTRA_FLAGS' environment variable
read -r -a extra_flags <<< "$VALKEY_EXTRA_FLAGS"
[[ "${#extra_flags[@]}" -gt 0 ]] && args+=("${extra_flags[@]}")
# Add flags passed to this script
args+=("$@")

if is_boolean_yes "$VALKEY_CLUSTER_CREATOR" && ! [[ -f "${VALKEY_DATA_DIR}/nodes.conf" ]]; then
    # Start Valkey in background
    if am_i_root; then
        run_as_user "$VALKEY_DAEMON_USER" valkey-server "${args[@]}" &
    else
        valkey-server "${args[@]}" &
    fi
    # Create the cluster
    valkey_cluster_create "${nodes[@]}"
    # Bring valkey process to foreground
    fg
else
    if am_i_root; then
        exec_as_user "$VALKEY_DAEMON_USER" valkey-server "${args[@]}"
    else
        exec valkey-server "${args[@]}"
    fi
fi
