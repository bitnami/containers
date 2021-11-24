#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Grafana environment
. /opt/bitnami/scripts/grafana-env.sh

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/grafana/run.sh" ]]; then
    /opt/bitnami/scripts/grafana/setup.sh
    /post-init.sh
    info "** Grafana setup finished! **"
fi

echo ""
exec "$@"
