#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose
# shellcheck disable=SC1091

# Load libraries
. /libkafka.sh
. /libos.sh

# Load Kafka environment variables
eval "$(kafka_env)"

if [[ "${KAFKA_CFG_LISTENERS:-}" =~ SASL ]]; then
    export KAFKA_OPTS="-Djava.security.auth.login.config=$KAFKA_HOME/conf/kafka_jaas.conf"
fi

flags=("$KAFKA_CONFDIR/server.properties")
[[ -z "${KAFKA_EXTRA_FLAGS:-}" ]] || flags=("${flags[@]}" "${KAFKA_EXTRA_FLAGS[@]}")
START_COMMAND=("$KAFKA_HOME/bin/kafka-server-start.sh" "${flags[@]}")

info "** Starting Kafka **"
if am_i_root; then
    exec gosu "$KAFKA_DAEMON_USER" exec "${START_COMMAND[@]}"
else
    exec "${START_COMMAND[@]}"
fi
