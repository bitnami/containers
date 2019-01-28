#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers


export ZOO_LOG_DIR=/opt/bitnami/zookeeper/logs
export ZOOPIDFILE=/opt/bitnami/zookeeper/tmp/zookeeper.pid

USER=zookeeper
START_COMMAND="/opt/bitnami/zookeeper/bin/zkServer.sh start && tail -f ${ZOO_LOG_DIR}/zookeeper.out"

# If container is started as `root` user
if [ $EUID -eq 0 ]; then
    exec gosu ${USER} bash -c "${START_COMMAND}"
else
    exec bash -c "${START_COMMAND}"
fi
