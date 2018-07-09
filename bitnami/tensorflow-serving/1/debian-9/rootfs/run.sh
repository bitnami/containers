#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers

TENSORFLOW_SERVING_HOME="/opt/bitnami/tensorflow-serving"
USER=tensorflow

info "Starting ${DAEMON}..."
exec gosu ${USER} bash -c "${TENSORFLOW_SERVING_HOME}/bin/tensorflow-serving.sh start && tail -f ${TENSORFLOW_SERVING_HOME}/logs/tensorflow-serving.log"
