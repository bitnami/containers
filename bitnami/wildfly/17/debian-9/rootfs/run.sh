#!/bin/bash

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

USER="wildfly"
DAEMON="standalone.sh"
EXEC=$(which $DAEMON)
START_COMMAND="${EXEC} ${WILDFLY_WILDFLY_OPTS:-} > /opt/bitnami/wildfly/logs/wildfly.out"

ln -sf /dev/stdout /opt/bitnami/wildfly/logs/wildfly.out

# If container is started as `root` user
if [ $EUID -eq 0 ]; then
    exec gosu "${USER}" bash -c "${START_COMMAND}"
else
    exec bash -c "${START_COMMAND}"
fi
