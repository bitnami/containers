#!/bin/bash

# shellcheck disable=SC1091

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

USER=airflow
DAEMON=airflow
EXEC=$(which $DAEMON)
AIRFLOW_COMMAND="worker"
# Adapt airflow commant to version 2.X CLI syntax
[[ $BITNAMI_IMAGE_VERSION =~ ^2.* ]] && AIRFLOW_COMMAND="celery ${AIRFLOW_COMMAND}"
START_COMMAND="${EXEC} ${AIRFLOW_COMMAND} ${AIRFLOW_QUEUE:+-q $AIRFLOW_QUEUE} | tee /opt/bitnami/airflow/logs/airflow-worker.log"

echo "Waiting for db..."
counter=0;
res=1000;
while [[ $res != 0 && $counter -lt 30 ]];
do
    if PGPASSWORD=$AIRFLOW_DATABASE_PASSWORD psql -h "$AIRFLOW_DATABASE_HOST" -U "$AIRFLOW_DATABASE_USERNAME" -d "$AIRFLOW_DATABASE_NAME" -c "" > /dev/null ; then
        echo "Database is ready";
        res=0
    else
        echo "Can't connect to database...retrying in 1 second";
    fi
    counter=$((counter + 1))
    sleep 1
done

info "Starting ${DAEMON}..."
# If container is started as `root` user
if [ $EUID -eq 0 ]; then
    exec gosu ${USER} bash -c "${START_COMMAND}"
else
    exec bash -c "${START_COMMAND}"
fi
