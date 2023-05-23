#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libschemaregistry.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load Schema Registry environment variables
. /opt/bitnami/scripts/schema-registry-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/schema-registry/run.sh" ]]; then
    info "** Starting Schema Registry setup **"
    /opt/bitnami/scripts/schema-registry/setup.sh
    info "** Schema Registry setup finished! **"
fi

echo ""
exec "$@"
