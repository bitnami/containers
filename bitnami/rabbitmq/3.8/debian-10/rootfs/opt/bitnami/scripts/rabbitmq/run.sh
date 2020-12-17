#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/librabbitmq.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

# Load RabbitMQ environment variables
. /opt/bitnami/scripts/rabbitmq-env.sh

info "** Starting RabbitMQ **"
if am_i_root; then
    exec gosu "$RABBITMQ_DAEMON_USER" "${RABBITMQ_BIN_DIR}/rabbitmq-server"
else
    exec "${RABBITMQ_BIN_DIR}/rabbitmq-server"
fi
