#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

# Load Apache Geode environment
. /opt/bitnami/scripts/geode-env.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/geode/run.sh"* ]]; then
    info "** Starting Apache Geode setup **"
    /opt/bitnami/scripts/geode/setup.sh
    info "** Apache Geode setup finished! **"
fi

echo ""
exec "$@"
