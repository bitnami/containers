#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Valkey environment variables
. /opt/bitnami/scripts/valkey-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalkey.sh

# Parse CLI flags to pass to the 'valkey-server' call
args=("${VALKEY_BASE_DIR}/etc/valkey.conf" "--daemonize" "no")
# Add flags specified via the 'VALKEY_EXTRA_FLAGS' environment variable
read -r -a extra_flags <<< "$VALKEY_EXTRA_FLAGS"
[[ "${#extra_flags[@]}" -gt 0 ]] && args+=("${extra_flags[@]}")
# Add flags passed to this script
args+=("$@")

info "** Starting Valkey **"
if am_i_root; then
    exec_as_user "$VALKEY_DAEMON_USER" valkey-server "${args[@]}"
else
    exec valkey-server "${args[@]}"
fi
