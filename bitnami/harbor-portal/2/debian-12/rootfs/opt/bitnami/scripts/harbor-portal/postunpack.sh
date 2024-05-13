#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libnginx.sh
. /opt/bitnami/scripts/libharbor.sh

# Load Nginx environment variables
. /opt/bitnami/scripts/nginx-env.sh

# Load environment
. /opt/bitnami/scripts/harbor-portal-env.sh

ensure_user_exists "$HARBOR_PORTAL_DAEMON_USER" --group "$HARBOR_PORTAL_DAEMON_GROUP"

# Ensure NGINX temp folders exists
for dir in "${NGINX_BASE_DIR}/client_body_temp" "${NGINX_BASE_DIR}/proxy_temp" "${NGINX_BASE_DIR}/fastcgi_temp" "${NGINX_BASE_DIR}/scgi_temp" "${NGINX_BASE_DIR}/uwsgi_temp"; do
    ensure_dir_exists "$dir"
done

# Ensure permissions for Internal TLS
configure_permissions_system_certs "$HARBOR_PORTAL_DAEMON_USER"

# Loading bitnami paths
replace_in_file "$HARBOR_PORTAL_NGINX_CONF_FILE" "/usr/share/nginx/html" "${HARBOR_PORTAL_BASE_DIR}" false
replace_in_file "$HARBOR_PORTAL_NGINX_CONF_FILE" "/etc/nginx/mime.types" "${NGINX_CONF_DIR}/mime.types" false

cp -a "${HARBOR_PORTAL_NGINX_CONF_DIR}/." "$NGINX_CONF_DIR"
# Remove the folder, otherwise it will get exposed when accessing via browser
rm -rf "${HARBOR_PORTAL_NGINX_CONF_DIR}"

# Ensure a set of directories exist and the non-root user has write privileges to them
read -r -a directories <<<"$(get_system_cert_paths)"
directories+=("$NGINX_CONF_DIR")
for dir in "${directories[@]}"; do
    chmod -R g+rwX "$dir"
    chown -R "$HARBOR_PORTAL_DAEMON_USER" "$dir"
done
