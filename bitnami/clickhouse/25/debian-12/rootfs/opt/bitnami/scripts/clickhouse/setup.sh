#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libclickhouse.sh

# Load ClickHouse environment settings
. /opt/bitnami/scripts/clickhouse-env.sh

# Ensure ClickHouse environment settings are valid
clickhouse_validate
# Ensure ClickHouse is stopped when this script ends.
trap "clickhouse_stop" EXIT
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$CLICKHOUSE_DAEMON_USER" --group "$CLICKHOUSE_DAEMON_GROUP"
# Ensure  is initialized
clickhouse_initialize
# Allow running custom initialization scripts
clickhouse_custom_scripts 'init'
# Allow running custom start scripts
clickhouse_custom_scripts 'start'
# Stop ClickHouse before flagging it as fully initialized.
# Relying only on the trap defined above could produce a race condition.
clickhouse_stop
