#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libapache.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load Apache environment
. /opt/bitnami/scripts/apache-env.sh

print_welcome_page

if [[ "$*" == *"/opt/bitnami/scripts/apache/run.sh"* ]]; then
    info "** Starting Apache setup **"
    /opt/bitnami/scripts/apache/setup.sh
    info "** Apache setup finished! **"
fi

echo ""
exec "$@"
