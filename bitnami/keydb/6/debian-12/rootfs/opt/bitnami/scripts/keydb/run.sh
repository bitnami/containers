#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load KeyDB environment variables
. /opt/bitnami/scripts/keydb-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libkeydb.sh

# Parse CLI flags to pass to the 'keydb-server' call
args=("$KEYDB_CONF_FILE" "--daemonize" "no")
# Add flags specified via the 'KEYDB_EXTRA_FLAGS' environment variable
read -r -a extra_flags <<< "$KEYDB_EXTRA_FLAGS"
[[ "${#extra_flags[@]}" -gt 0 ]] && args+=("${extra_flags[@]}")
# Add flags passed to this script
args+=("$@")

info "** Starting KeyDB **"
if am_i_root; then
    exec_as_user "$KEYDB_DAEMON_USER" keydb-server "${args[@]}"
else
    exec keydb-server "${args[@]}"
fi
