#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libtomcat.sh
. /opt/bitnami/scripts/libfs.sh

# Load Tomcat environment variables
. /opt/bitnami/scripts/tomcat-env.sh

# Ensure 'tomcat' user exists when running as 'root'
ensure_user_exists "$TOMCAT_DAEMON_USER" --group "$TOMCAT_DAEMON_GROUP" --system
# By default, the upstream Tomcat tarball includes very specific permissions on its files
# For simplicity purposes, since Bitnami Tomcat is considered a development environment, we reset to OS defaults
configure_permissions_ownership "$TOMCAT_BASE_DIR" -d "755" -f "644"
chmod a+x "$TOMCAT_BIN_DIR"/*.sh
# Make TOMCAT_HOME writable (non-recursively, for security reasons) both for root and non-root approaches
chown "$TOMCAT_DAEMON_USER" "$TOMCAT_HOME"
chmod g+rwX "$TOMCAT_HOME"
# Make TOMCAT_LIB_DIR writable (non-recursively, for security reasons) for non-root approach, some apps may copy files there
chmod g+rwX "$TOMCAT_LIB_DIR"
# Make required folders writable by the Tomcat web server user
for dir in "$TOMCAT_TMP_DIR" "$TOMCAT_LOGS_DIR" "$TOMCAT_CONF_DIR" "$TOMCAT_WORK_DIR" "$TOMCAT_WEBAPPS_DIR" "${TOMCAT_BASE_DIR}/webapps" "$TOMCAT_DEFAULT_CONF_DIR"; do
    ensure_dir_exists "$dir"
    # Use tomcat:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$TOMCAT_DAEMON_USER" -g "root"
done

# Allow enabling custom Tomcat webapps
mv "${TOMCAT_BASE_DIR}/webapps" "${TOMCAT_BASE_DIR}/webapps_default"
ln -sf "$TOMCAT_WEBAPPS_DIR" "${TOMCAT_BASE_DIR}/webapps"

# Create a setenv.sh script
# For more info, refer to section '(3.4) Using the "setenv" script' from https://tomcat.apache.org/tomcat-9.0-doc/RUNNING.txt
declare template_dir="${BITNAMI_ROOT_DIR}/scripts/tomcat/bitnami-templates"
render-template "${template_dir}/setenv.sh.tpl" > "${TOMCAT_BIN_DIR}/setenv.sh"
chmod g+rwX "${TOMCAT_BIN_DIR}/setenv.sh"

# Create 'apache-tomcat' symlink pointing to the 'tomcat' directory, for compatibility with Bitnami Docs guides
ln -sf tomcat "${BITNAMI_ROOT_DIR}/apache-tomcat"

# Users can mount their webapps at /app
ln -sf "$TOMCAT_WEBAPPS_DIR" /app

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "$TOMCAT_CONF_DIR"/* "$TOMCAT_DEFAULT_CONF_DIR"
