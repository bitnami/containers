#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Valkey Sentinel environment variables
. /opt/bitnami/scripts/valkey-sentinel-env.sh

# Load libraries
. /opt/bitnami/scripts/libvalkeysentinel.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

args=("$VALKEY_SENTINEL_CONF_FILE" "--daemonize" "no" "$@")

info "** Starting Valkey Sentinel **"
if am_i_root; then
    exec_as_user "$VALKEY_SENTINEL_DAEMON_USER" valkey-sentinel "${args[@]}"
else
    exec valkey-sentinel "${args[@]}"
fi
