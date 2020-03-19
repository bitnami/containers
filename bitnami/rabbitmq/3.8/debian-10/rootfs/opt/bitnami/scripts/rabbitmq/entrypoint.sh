#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/librabbitmq.sh
. /opt/bitnami/scripts/liblog.sh

# Load RabbitMQ environment variables
eval "$(rabbitmq_env)"

print_welcome_page

if [[ "$*" = "/opt/bitnami/scripts/rabbitmq/run.sh" ]]; then
    info "** Starting RabbitMQ setup **"
    /opt/bitnami/scripts/rabbitmq/setup.sh
    info "** RabbitMQ setup finished! **"
fi

echo ""
exec "$@"
