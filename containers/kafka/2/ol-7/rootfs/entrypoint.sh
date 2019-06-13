#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose
# shellcheck disable=SC1091

# Load libraries
. /liblog.sh
. /libbitnami.sh
. /libkafka.sh

# Load Kafka environment variables
eval "$(kafka_env)"

print_welcome_page

if [[ "$*" = "/run.sh" ]]; then
    info "** Starting Kafka setup **"
    /setup.sh
    info "** Kafka setup finished! **"
fi

echo ""
exec "$@"
