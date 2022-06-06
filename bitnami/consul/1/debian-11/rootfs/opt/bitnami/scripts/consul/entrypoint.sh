#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libconsul.sh
. /opt/bitnami/scripts/liblog.sh

# Load Consul env. variables
. /opt/bitnami/scripts/consul-env.sh

print_welcome_page

if [[ "$*" = "/opt/bitnami/scripts/consul/run.sh" ]]; then
    info "** Starting Consul setup **"
    /opt/bitnami/scripts/consul/setup.sh
    info "** Consul setup finished! **"
fi

echo ""
exec "$@"
