#!/bin/bash

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

USER=airflow
DAEMON=airflow
EXEC=$(which $DAEMON)
START_COMMAND="${EXEC} webserver | tee /opt/bitnami/airflow/logs/airflow-webserver.log"
if [ $AIRFLOW_POOL ]; then
    CREATE_POOL="${EXEC} pool -s $AIRFLOW_POOL_NAME $AIRFLOW_POOL_SIZE $AIRFLOW_POOL_DESCRIPTION | tee /opt/bitnami/airflow/logs/airflow-webserver.log"
fi
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
    if [ $AIRFLOW_POOL ]; then
	exec gosu ${USER} bash -c "${CREATE_POOL}"
    fi
else
    exec bash -c "${START_COMMAND}"
    if [ $AIRFLOW_POOL ]; then
	exec bash -c "${CREATE_POOL}"
    fi
fi
