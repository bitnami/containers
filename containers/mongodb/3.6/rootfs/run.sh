#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

DAEMON=mongod
USER=mongo
EXEC=$(which $DAEMON)
ARGS="--config /opt/bitnami/mongodb/conf/mongodb.conf"

# log output to stdout
sed -i 's/path: .*\/mongodb.log/path: /' /bitnami/mongodb/conf/mongodb.conf

info "Starting ${DAEMON}..."
exec gosu ${USER} ${EXEC} ${ARGS}
