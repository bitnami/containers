#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

DAEMON=mongod
USER=mongo
EXEC=$(which $DAEMON)
ARGS="--config /opt/bitnami/mongodb/conf/mongodb.conf"

# configure extra command line flags
if [[ -n $MONGODB_EXTRA_FLAGS ]]; then
    ARGS+=" $MONGODB_EXTRA_FLAGS"
fi

# log output to stdout
sed -i 's/path: .*\/mongodb.log/path: /' /opt/bitnami/mongodb/conf/mongodb.conf

info "Starting ${DAEMON}..."
exec ${EXEC} ${ARGS}
