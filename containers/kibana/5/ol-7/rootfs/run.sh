#!/bin/bash

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

DAEMON=kibana
EXEC=$(which $DAEMON)
START_COMMAND="${EXEC} serve"

cd /opt/bitnami/kibana || exit 1

# If container is started as `root` user
if [[ $EUID -eq 0 ]]; then
    exec gosu "${DAEMON}" bash -c "${START_COMMAND}"
else
    exec bash -c "${START_COMMAND}"
fi
