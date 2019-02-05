#!/bin/bash

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

USER=airflow
DAEMON=airflow
EXEC=$(which $DAEMON)
START_COMMAND="${EXEC} worker | tee /opt/bitnami/airflow/logs/airflow-worker.log"

info "Starting ${DAEMON}..."
# If container is started as `root` user
if [ $EUID -eq 0 ]; then
    exec gosu ${USER} bash -c "${START_COMMAND}"
else
    exec bash -c "${START_COMMAND}"
fi
