#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libkafka.sh
. /opt/bitnami/scripts/libos.sh

# Load Kafka environment variables
. /opt/bitnami/scripts/kafka-env.sh

if [[ -f "${KAFKA_CONF_DIR}/kafka_jaas.conf" ]]; then
    export KAFKA_OPTS="${KAFKA_OPTS:-} -Djava.security.auth.login.config=${KAFKA_CONF_DIR}/kafka_jaas.conf"
fi

# Extract broker/node ID for ready logging
KAFKA_ID=""
if [[ -n "${KAFKA_CFG_NODE_ID:-}" ]]; then
    # KRaft mode uses node.id
    KAFKA_ID="${KAFKA_CFG_NODE_ID}"
elif [[ -n "${KAFKA_CFG_BROKER_ID:-}" ]]; then
    # Zookeeper mode uses broker.id
    KAFKA_ID="${KAFKA_CFG_BROKER_ID}"
fi

cmd="$KAFKA_HOME/bin/kafka-server-start.sh"
args=("$KAFKA_CONF_FILE")
! is_empty_value "${KAFKA_EXTRA_FLAGS:-}" && args=("${args[@]}" "${KAFKA_EXTRA_FLAGS[@]}")

info "** Starting Kafka **"

# Monitor function to detect Kafka ready state
monitor_kafka_output() {
    local kafka_id="$1"
    local logged_ready=false
    
    while IFS= read -r line; do
        echo "$line"
        if [[ "$logged_ready" == false ]] && echo "$line" | grep -q "started (kafka.server.KafkaServer)"; then
            if [[ -n "$kafka_id" ]]; then
                info "KafkaServer id=${kafka_id} started."
            fi
            logged_ready=true
        fi
    done
}

# Start Kafka with output monitoring
if am_i_root; then
    exec_as_user "$KAFKA_DAEMON_USER" "$cmd" "${args[@]}" "$@" 2>&1 | monitor_kafka_output "$KAFKA_ID"
else
    exec "$cmd" "${args[@]}" "$@" 2>&1 | monitor_kafka_output "$KAFKA_ID"
fi

