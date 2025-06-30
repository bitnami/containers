#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Superset environment variables
. /opt/bitnami/scripts/superset-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libsuperset.sh

if [[ "$SUPERSET_ROLE" = "webserver" ]]; then
    command="gunicorn"
    args=(
        "--bind" "${SUPERSET_WEBSERVER_HOST}:${SUPERSET_WEBSERVER_PORT_NUMBER}"
        "--access-logfile" "${SUPERSET_WEBSERVER_ACCESS_LOG_FILE}"
        "--error-logfile" "${SUPERSET_WEBSERVER_ERROR_LOG_FILE}"
        "--workers" "${SUPERSET_WEBSERVER_WORKERS}"
        "--worker-class" "${SUPERSET_WEBSERVER_WORKER_CLASS}"
        "--threads" "${SUPERSET_WEBSERVER_THREADS}"
        "--timeout" "${SUPERSET_WEBSERVER_TIMEOUT}"
        "--keep-alive" "${SUPERSET_WEBSERVER_KEEPALIVE}"
        "--max-requests" "${SUPERSET_WEBSERVER_MAX_REQUESTS}"
        "--max-requests-jitter" "${SUPERSET_WEBSERVER_MAX_REQUESTS_JITTER}"
        "--limit-request-line" "${SUPERSET_WEBSERVER_LIMIT_REQUEST_LINE}"
        "--limit-request-field_size" "${SUPERSET_WEBSERVER_LIMIT_REQUEST_FIELD_SIZE}"
        "${FLASK_APP}"
    )
elif [[ "$SUPERSET_ROLE" = "celery-worker" ]]; then
    command="celery"
    args=("--app=superset.tasks.celery_app:app" "worker")
elif [[ "$SUPERSET_ROLE" = "celery-beat" ]]; then
    command="celery"
    args=("--app=superset.tasks.celery_app:app" "beat" "--pidfile" "${SUPERSET_CELERY_BEAT_PID}" --schedule "${SUPERSET_CELERY_BEAT_SCHEDULE}")
elif [[ "$SUPERSET_ROLE" = "celery-flower" ]]; then
    command="celery"
    args=("--app=superset.tasks.celery_app:app" "flower")
elif [[ "$SUPERSET_ROLE" = "init" ]]; then
    # Run superset initialization process
    superset_run_init
    exit
fi

info "** Starting Superset ${SUPERSET_ROLE} **"
if am_i_root; then
    exec_as_user "$SUPERSET_DAEMON_USER" "${command}" "${args[@]}"
else
    exec "${command}" "${args[@]}"
fi
