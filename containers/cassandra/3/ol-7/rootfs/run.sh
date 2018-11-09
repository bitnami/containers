#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

USER=cassandra
DAEMON=cassandra
EXEC=$(which $DAEMON)
ARGS="-p /opt/bitnami/cassandra/tmp/cassandra.pid -R -f"

info "Starting ${DAEMON}..."

# If container is started as `root` user
if [ $EUID -eq 0 ]; then
    gosu ${USER} ${EXEC} ${ARGS} &
else
    ${EXEC} ${ARGS} &
fi

echo $! > /opt/bitnami/cassandra/tmp/cassandra.pid

wait
