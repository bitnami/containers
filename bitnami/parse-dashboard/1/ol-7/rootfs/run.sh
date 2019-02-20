#!/bin/bash

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

USER=parsedashboard
DAEMON=parse-dashboard
EXEC=$(which $DAEMON)
START_COMMAND="${EXEC} --config /opt/bitnami/parse-dashboard/config.json --allowInsecureHTTP 1"

cd /opt/bitnami/parse-dashboard || exit 1

# If container is started as `root` user
if [ $EUID -eq 0 ]; then
    exec gosu "${USER}" bash -c "${START_COMMAND}"
else
    exec bash -c "${START_COMMAND}"
fi
