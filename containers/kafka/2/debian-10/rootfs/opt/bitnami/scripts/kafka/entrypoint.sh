#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libkafka.sh

# Load Kafka environment variables
eval "$(kafka_env)"

print_welcome_page

if [[ "$*" = "/opt/bitnami/scripts/kafka/run.sh" || "$*" = "/run.sh" ]]; then
    info "** Starting Kafka setup **"
    /opt/bitnami/scripts/kafka/setup.sh
    info "** Kafka setup finished! **"
fi

echo ""
exec "$@"
