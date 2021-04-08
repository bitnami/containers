#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libtomcat.sh
. /opt/bitnami/scripts/liblog.sh

# Load Tomcat environment variables
eval "$(tomcat_env)"

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/tomcat/run.sh"* ]]; then
    info "** Starting tomcat setup **"
    /opt/bitnami/scripts/tomcat/setup.sh
    info "** tomcat setup finished! **"
fi

echo ""
exec "$@"
