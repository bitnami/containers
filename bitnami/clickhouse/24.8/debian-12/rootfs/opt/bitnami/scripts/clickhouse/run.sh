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
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libclickhouse.sh

# Load ClickHouse environment variables
. /opt/bitnami/scripts/clickhouse-env.sh

declare -a cmd=("${CLICKHOUSE_BASE_DIR}/bin/clickhouse-server")
declare -a args=("--config-file=${CLICKHOUSE_CONF_FILE}" "--pid-file=${CLICKHOUSE_PID_FILE}")
args+=("$@")

info "** Starting ClickHouse **"
if am_i_root; then
    exec_as_user "$CLICKHOUSE_DAEMON_USER" "${cmd[@]}" "${args[@]}"
else
    exec "${cmd[@]}" "${args[@]}"
fi
