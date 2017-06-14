#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers


DAEMON=zookeeper
USER=zookeeper
EXEC=/opt/bitnami/zookeeper/bin/zkServer.sh
ARGS="start"

export ZOO_LOG_DIR=/opt/bitnami/zookeeper/logs
export ZOOPIDFILE=/opt/bitnami/zookeeper/tmp/zookeeper.pid

info "Starting ${DAEMON}..."
exec gosu ${USER} bash -c "${EXEC} ${ARGS} && tail -f ${ZOO_LOG_DIR}/zookeeper.out"
