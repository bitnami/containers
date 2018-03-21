#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

USER=consul
DAEMON=consul
EXEC=$(which $DAEMON)
ARGS="agent -config-dir /opt/bitnami/consul/conf | tee /opt/bitnami/consul/logs/consul.log"

info "Starting ${DAEMON}..."
exec gosu ${USER} bash -c "${EXEC} ${ARGS}"
