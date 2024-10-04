#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libmongodb.sh
. /opt/bitnami/scripts/libos.sh

# Load environment
. /opt/bitnami/scripts/mongodb-env.sh

cmd=$(command -v mongod)

flags=("--config=$MONGODB_CONF_FILE")

if [[ -n "${MONGODB_EXTRA_FLAGS:-}" ]]; then
    read -r -a extra_flags <<< "$MONGODB_EXTRA_FLAGS"
    flags+=("${extra_flags[@]}")
fi

flags+=("$@")

info "** Starting MongoDB **"
if am_i_root; then
    if is_boolean_yes "$MONGODB_ENABLE_NUMACTL"; then
        exec_as_user "$MONGODB_DAEMON_USER" numactl --interleave=all "$cmd" "${flags[@]}"
    else
        exec_as_user "$MONGODB_DAEMON_USER" "$cmd" "${flags[@]}"
    fi
else
    if is_boolean_yes "$MONGODB_ENABLE_NUMACTL"; then
        exec numactl --interleave=all "$cmd" "${flags[@]}"
    else
        exec "$cmd" "${flags[@]}"
    fi
fi
