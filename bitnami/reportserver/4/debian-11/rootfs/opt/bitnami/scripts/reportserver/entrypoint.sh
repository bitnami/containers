#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load ReportServer environment
. /opt/bitnami/scripts/tomcat-env.sh
. /opt/bitnami/scripts/reportserver-env.sh

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/tomcat/run.sh" ]]; then
    /opt/bitnami/scripts/mysql-client/setup.sh
    /opt/bitnami/scripts/tomcat/setup.sh
    /opt/bitnami/scripts/reportserver/setup.sh
    /post-init.sh
    info "** ReportServer setup finished! **"
fi

echo ""
exec "$@"
