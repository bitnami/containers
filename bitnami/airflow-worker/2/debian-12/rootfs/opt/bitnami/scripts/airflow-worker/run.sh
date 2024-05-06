#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Airflow environment variables
. /opt/bitnami/scripts/airflow-worker-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libairflowworker.sh

EXEC="${AIRFLOW_BIN_DIR}/airflow"
args=("celery" "worker")
if [[ -n "$AIRFLOW_QUEUE" ]]; then
    args+=("-q" "$AIRFLOW_QUEUE")
fi
args+=("--pid" "$AIRFLOW_PID_FILE" "$@")

info "** Starting Airflow **"
if am_i_root; then
    exec_as_user "$AIRFLOW_DAEMON_USER" "$EXEC" "${args[@]}"
else
    exec "$EXEC" "${args[@]}"
fi
