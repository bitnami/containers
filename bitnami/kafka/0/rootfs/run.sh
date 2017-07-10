#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers


KAFKA_HOME="/opt/bitnami/kafka"
DAEMON=kafka
USER=kafka

if [[ -z "$KAFKA_BROKER_ID" ]]; then
    if [[ -n "$BROKER_ID_COMMAND" ]]; then
        export KAFKA_BROKER_ID=$(eval $BROKER_ID_COMMAND)
    else
        # By default auto allocate broker ID
        export KAFKA_BROKER_ID=-1
    fi
fi

if [[ "$KAFKA_LISTENERS" =~ SASL_SSL ]]; then
    export KAFKA_OPTS="-Djava.security.auth.login.config=${KAFKA_HOME}/conf/kafka_jaas.conf"
fi

su -  ${USER} bash -c "touch ${KAFKA_HOME}/logs/server.log"

info "Starting ${DAEMON}..."
exec gosu ${USER} bash -c "${KAFKA_HOME}/bin/kafka-server-start.sh -daemon ${KAFKA_HOME}/config/server.properties &&  ps -C java -o pid | tail -1  > ${KAFKA_HOME}/tmp/kafka.pid  && tail -f ${KAFKA_HOME}/logs/server.log"
