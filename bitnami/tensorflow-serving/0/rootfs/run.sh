#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

DAEMON=tensorflow-serving.sh
USER=tensorflow
EXEC=$(which $DAEMON)
ARGS="start-foreground"

info "Starting ${DAEMON}..."
exec gosu ${USER} ${EXEC} ${ARGS}
