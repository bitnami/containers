#!/bin/bash

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

USER=consul
DAEMON=consul
EXEC=$(which $DAEMON)
START_COMMAND="${EXEC} agent -config-dir /opt/bitnami/consul/conf | tee /opt/bitnami/consul/logs/consul.log"

info "Starting ${DAEMON}..."
# If container is started as `root` user
if [ $EUID -eq 0 ]; then
    exec gosu ${USER} bash -c "${START_COMMAND}"
else
    exec bash -c "${START_COMMAND}"
fi
