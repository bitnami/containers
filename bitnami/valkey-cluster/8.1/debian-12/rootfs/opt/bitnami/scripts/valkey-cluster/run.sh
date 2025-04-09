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

ARGS=("--port" "$VALKEY_PORT_NUMBER")
ARGS+=("--include" "${VALKEY_BASE_DIR}/etc/valkey.conf")

if ! is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
    ARGS+=("--requirepass" "$VALKEY_PASSWORD")
    ARGS+=("--primaryauth" "$VALKEY_PASSWORD")
else
    ARGS+=("--protected-mode" "no")
fi

ARGS+=("$@")

if is_boolean_yes "$VALKEY_CLUSTER_CREATOR" && ! [[ -f "${VALKEY_DATA_DIR}/nodes.conf" ]]; then
    # Start Valkey in background
    if am_i_root; then
        run_as_user "$VALKEY_DAEMON_USER" valkey-server "${ARGS[@]}" &
    else
        valkey-server "${ARGS[@]}" &
    fi
    # Create the cluster
    valkey_cluster_create "${nodes[@]}"
    # Bring valkey process to foreground
    fg
else
    if am_i_root; then
        exec_as_user "$VALKEY_DAEMON_USER" valkey-server "${ARGS[@]}"
    else
        exec valkey-server "${ARGS[@]}"
    fi
fi
