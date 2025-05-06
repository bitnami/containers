#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Redis Sentinel environment variables
. /opt/bitnami/scripts/redis-sentinel-env.sh

# Load libraries
. /opt/bitnami/scripts/libredissentinel.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

args=("$REDIS_SENTINEL_CONF_FILE" "--daemonize" "no" "$@")

info "** Starting Redis Sentinel **"
if am_i_root; then
    exec_as_user "$REDIS_SENTINEL_DAEMON_USER" redis-sentinel "${args[@]}"
else
    exec redis-sentinel "${args[@]}"
fi
