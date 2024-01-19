#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load ReportServer environment
. /opt/bitnami/scripts/tomcat-env.sh
. /opt/bitnami/scripts/reportserver-env.sh

# Load libraries
. /opt/bitnami/scripts/libtomcat.sh
. /opt/bitnami/scripts/libreportserver.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh

# Ensure the required config files exist
mkdir -p "${REPORTSERVER_CONF_DIR}"
touch "${REPORTSERVER_CONF_DIR}"/{persistence,reportserver,rsinit}.properties

# Ensure the ReportServer base directory exists and has proper permissions
info "Configuring file permissions for ReportServer"
ensure_user_exists "$REPORTSERVER_DAEMON_USER" --group "$REPORTSERVER_DAEMON_GROUP" --system
ensure_dir_exists "$REPORTSERVER_BASE_DIR"
# Use tomcat:root ownership for compatibility when running as a non-root user
configure_permissions_ownership "$REPORTSERVER_BASE_DIR" -d "775" -f "664" -u "$REPORTSERVER_DAEMON_USER" -g "root"

# Clean webapps and add the reportserver one
rm "${BITNAMI_ROOT_DIR}/tomcat/webapps/"{manager,docs,examples,host-manager} -r
ln -s "$REPORTSERVER_BASE_DIR" "${BITNAMI_ROOT_DIR}/tomcat/webapps/reportserver"
