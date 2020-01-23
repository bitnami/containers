#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libbitnami.sh
. /librabbitmq.sh
. /liblog.sh

# Load RabbitMQ environment variables
eval "$(rabbitmq_env)"

print_welcome_page

if [[ "$*" = "/run.sh" ]]; then
    info "** Starting RabbitMQ setup **"
    /setup.sh
    info "** RabbitMQ setup finished! **"
fi

echo ""
exec "$@"
