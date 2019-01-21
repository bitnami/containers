#!/bin/bash
# shellcheck disable=SC1091

. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

DAEMON="tensorflow-serving.sh"
USER=tensorflow
EXEC=$(which $DAEMON)
START_COMMAND="${EXEC} start && tail -f /opt/bitnami/tensorflow-serving/logs/tensorflow-serving.log"

# If container is started as `root` user
if [ $EUID -eq 0 ]; then
    exec gosu "${USER}" bash -c "${START_COMMAND}"
else
    exec bash -c "${START_COMMAND}"
fi
