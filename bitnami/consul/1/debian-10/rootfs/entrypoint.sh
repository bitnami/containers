#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Load libraries
. /libbitnami.sh
. /libconsul.sh
. /liblog.sh

# Load Consul env. variables
eval "$(consul_env)"

print_welcome_page

if [[ "$*" = "/run.sh" ]]; then
    info "** Starting Consul setup **"
    /setup.sh
    info "** Consul setup finished! **"
fi

echo ""
exec "$@"
