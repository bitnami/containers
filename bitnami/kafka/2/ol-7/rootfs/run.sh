#!/bin/bash
. /opt/bitnami/base/functions
. /opt/bitnami/base/helpers


USER=kafka
KAFKA_HOME="/opt/bitnami/kafka"
START_COMMAND="${KAFKA_HOME}/bin/kafka-server-start.sh ${KAFKA_HOME}/config/server.properties"

if [[ -z "$KAFKA_BROKER_ID" ]]; then
    if [[ -n "$BROKER_ID_COMMAND" ]]; then
        KAFKA_BROKER_ID="$(eval "$BROKER_ID_COMMAND")"
        export KAFKA_BROKER_ID
    else
        # By default auto allocate broker ID
        export KAFKA_BROKER_ID=-1
    fi
fi

if [[ "$KAFKA_LISTENERS" =~ SASL ]]; then
    export KAFKA_OPTS="-Djava.security.auth.login.config=${KAFKA_HOME}/conf/kafka_jaas.conf"
fi

# If container is started as `root` user
if [[ $EUID -eq 0 ]]; then
    exec gosu ${USER} bash -c "${START_COMMAND[@]}"
else
    exec bash -c "${START_COMMAND[@]}"
fi
