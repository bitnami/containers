#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libnginx.sh

export HARBOR_PORTAL_BASE_DIR="/opt/bitnami/harbor"
export HARBOR_PORTAL_NGINX_CONF_DIR="${HARBOR_PORTAL_BASE_DIR}/nginx-conf"
export HARBOR_PORTAL_NGINX_CONF_FILE="${HARBOR_PORTAL_NGINX_CONF_DIR}/nginx.conf"

# Load Nginx environment variables
. /opt/bitnami/scripts/nginx-env.sh

# Ensure NGINX temp folders exists
for dir in  "${NGINX_BASE_DIR}/client_body_temp" "${NGINX_BASE_DIR}/proxy_temp" "${NGINX_BASE_DIR}/fastcgi_temp" "${NGINX_BASE_DIR}/scgi_temp" "${NGINX_BASE_DIR}/uwsgi_temp"; do
    ensure_dir_exists "$dir"
done

# Loading bitnami paths
replace_in_file "$HARBOR_PORTAL_NGINX_CONF_FILE" "/usr/share/nginx/html" "${HARBOR_PORTAL_BASE_DIR}" false
replace_in_file "$HARBOR_PORTAL_NGINX_CONF_FILE" "/etc/nginx/mime.types" "${NGINX_CONF_DIR}/mime.types" false

cp -a "${HARBOR_PORTAL_NGINX_CONF_DIR}/." "$NGINX_CONF_DIR"
# Remove the folder, otherwise it will get exposed when accessing via browser
rm -rf "${HARBOR_PORTAL_NGINX_CONF_DIR}"

chmod -R g+rwX "$NGINX_CONF_DIR"
