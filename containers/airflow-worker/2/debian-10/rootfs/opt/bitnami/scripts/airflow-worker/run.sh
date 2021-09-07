#!/bin/bash

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

args=("--pid" "$AIRFLOW_PID_FILE" "$@")

info "** Starting Airflow **"
if am_i_root; then
    exec gosu "$AIRFLOW_DAEMON_USER" "${AIRFLOW_BIN_DIR}/airflow" "celery" "worker ${AIRFLOW_QUEUE:+-q $AIRFLOW_QUEUE}" "${args[@]}"
else
    exec "${AIRFLOW_BIN_DIR}/airflow" "celery" "worker ${AIRFLOW_QUEUE:+-q $AIRFLOW_QUEUE}" "${args[@]}"
fi
