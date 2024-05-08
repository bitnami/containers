#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libnats.sh
. /opt/bitnami/scripts/liblog.sh

# Load NATS environment
. /opt/bitnami/scripts/nats-env.sh

declare nats_cmd="nats-server"
which "$nats_cmd" >/dev/null 2>&1 || nats_cmd="gnatsd"
declare -a args=("-c" "$NATS_CONF_FILE")

if [[ -n "${NATS_EXTRA_ARGS:-}" ]]; then
    read -r -a extra_args <<<"$NATS_EXTRA_ARGS"
    args+=("${extra_args[@]}")
fi

args+=("$@")

info "** Starting NATS **"
if am_i_root; then
    exec_as_user "$NATS_DAEMON_USER" "$nats_cmd" "${args[@]}"
else
    exec "$nats_cmd" "${args[@]}"
fi
