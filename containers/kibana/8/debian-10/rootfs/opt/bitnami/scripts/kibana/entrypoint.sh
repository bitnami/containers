#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libkibana.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load environment
. /opt/bitnami/scripts/kibana-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/kibana/run.sh" ]]; then
    info "** Starting Kibana setup **"
    /opt/bitnami/scripts/kibana/setup.sh
    info "** Kibana setup finished! **"
fi

echo ""
exec "$@"
