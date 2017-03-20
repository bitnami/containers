#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

DAEMON=redis-server
USER=redis
EXEC=$(which $DAEMON)
ARGS="/opt/bitnami/redis/conf/redis.conf --daemonize no"

# log output to stdout
sed -i 's/^logfile /# logfile /g' /opt/bitnami/redis/conf/redis.conf

info "Starting ${DAEMON}..."
exec gosu ${USER} ${EXEC} ${ARGS}
