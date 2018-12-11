#!/bin/bash

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

USER=parse
DAEMON=parse-server
EXEC=$(which $DAEMON)
START_COMMAND="${EXEC} /opt/bitnami/parse/config.json"

# If container is started as `root` user
if [ $EUID -eq 0 ]; then
    exec gosu "${USER}" bash -c "${START_COMMAND}"
else
    exec bash -c "${START_COMMAND}"
fi
