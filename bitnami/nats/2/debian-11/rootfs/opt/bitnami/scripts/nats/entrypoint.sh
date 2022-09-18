#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

# Load NATS environment
. /opt/bitnami/scripts/nats-env.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/nats/run.sh"* ]]; then
    info "** Starting NATS setup **"
    /opt/bitnami/scripts/nats/setup.sh
    info "** NATS setup finished! **"
fi

echo ""
exec "$@"
