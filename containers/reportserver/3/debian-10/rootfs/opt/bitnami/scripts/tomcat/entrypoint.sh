#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libtomcat.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load Tomcat environment variables
. /opt/bitnami/scripts/tomcat-env.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/tomcat/run.sh"* ]]; then
    info "** Starting tomcat setup **"
    /opt/bitnami/scripts/tomcat/setup.sh
    info "** tomcat setup finished! **"
fi

echo ""
exec "$@"
