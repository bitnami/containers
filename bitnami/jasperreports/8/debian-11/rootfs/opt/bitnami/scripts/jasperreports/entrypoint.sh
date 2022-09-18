#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load JasperReports environment
. /opt/bitnami/scripts/jasperreports-env.sh

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libfs.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/tomcat/run.sh" ]]; then
    /opt/bitnami/scripts/mysql-client/setup.sh
    /opt/bitnami/scripts/postgresql-client/setup.sh
    # For compatibility with previous Helm charts, disable Tomcat auth by default
    TOMCAT_ENABLE_AUTH="${TOMCAT_ENABLE_AUTH:-no}" /opt/bitnami/scripts/tomcat/setup.sh
    /opt/bitnami/scripts/jasperreports/setup.sh
    /post-init.sh
     if ! is_dir_empty "/bitnami/jasperreports-mounted-conf"; then
        info "** User provided config detected **"
        info "** Copy and overwrite Jasper config located into config folder and replace into WEB-INF Jasper **"
        cp -r -L /bitnami/jasperreports-mounted-conf/* /opt/bitnami/jasperreports/WEB-INF/
    fi
    info "** JasperReports setup finished! **"
fi

echo ""
exec "$@"
