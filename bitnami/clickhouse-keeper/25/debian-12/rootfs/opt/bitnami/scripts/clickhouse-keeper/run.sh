#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libclickhousekeeper.sh

# Load ClickHouse Keeper environment variables
. /opt/bitnami/scripts/clickhouse-keeper-env.sh

declare -a cmd=("${CLICKHOUSE_KEEPER_BASE_DIR}/bin/clickhouse-keeper")
declare -a args=("--config-file=${CLICKHOUSE_KEEPER_CONF_FILE}" "--pid-file=${CLICKHOUSE_KEEPER_PID_FILE}")
args+=("$@")

info "** Starting ClickHouse Keeper **"
if am_i_root; then
    exec_as_user "$CLICKHOUSE_DAEMON_USER" "${cmd[@]}" "${args[@]}"
else
    exec "${cmd[@]}" "${args[@]}"
fi
