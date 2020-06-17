#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/librabbitmq.sh

# Load RabbitMQ environment variables
eval "$(rabbitmq_env)"

if [[ -f "${RABBITMQ_LIB_DIR}/.start" ]]; then
    rabbitmqctl node_health_check
    RESULT=$?
    if [[ $RESULT -ne 0 ]]; then
        rabbitmqctl status
        exit $?
    fi
    rm -f "${RABBITMQ_LIB_DIR}/.start"
    exit ${RESULT}
fi

/opt/bitnami/scripts/rabbitmq/apicheck.sh "$1" "$2"
