#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/librabbitmq.sh

# Load RabbitMQ environment variables
. /opt/bitnami/scripts/rabbitmq-env.sh

if [[ -f "${RABBITMQ_LIB_DIR}/.start" ]]; then
    rabbitmq-diagnostics -q ping
    RESULT=$?
    if [[ $RESULT -ne 0 ]]; then
        rabbitmqctl status
        exit $?
    fi
    rm -f "${RABBITMQ_LIB_DIR}/.start"
    exit ${RESULT}
fi

/opt/bitnami/scripts/rabbitmq/apicheck.sh "$1" "$2"
