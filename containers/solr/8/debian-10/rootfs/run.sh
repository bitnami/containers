#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

USER=solr
SOLR_LOGS_DIR=/opt/bitnami/solr/logs
START_COMMAND="/opt/bitnami/solr/bin/solr -p ${SOLR_PORT_NUMBER} -d /opt/bitnami/solr/server -f"

cd /opt/bitnami/solr || exit 1

# If container is started as `root` user
if [ $EUID -eq 0 ]; then
    gosu ${USER} bash -c "${START_COMMAND}" &
else
    bash -c "${START_COMMAND}" &
fi

# The official solr script uses the same PID file to check if solr is running.
# Wait until solr is running before write the PID file to avoid race condition.
while [[ -z $pid ]]; do
  pid="$(ps ax | grep start.jar | grep /opt/bitnami/solr | grep -v grep | awk '{print $1}')"
done

echo "$pid" > "/opt/bitnami/solr/tmp/solr-${SOLR_PORT_NUMBER}.pid"
wait "$pid"
