#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libopenresty.sh
. /opt/bitnami/scripts/libfs.sh

# Auxiliar Functions

########################
# Unset HTTP_PROXY header to protect vs HTTPPOXY vulnerability
# Ref: https://www.digitalocean.com/community/tutorials/how-to-protect-your-server-against-the-httpoxy-vulnerability
# Globals:
#   OPENRESTY_*
# Arguments:
#   None
# Returns:
#   None
#########################
openresty_patch_httpoxy_vulnerability() {
    debug "Unsetting HTTP_PROXY header..."
    echo '# Unset the HTTP_PROXY header' >> "${OPENRESTY_CONF_DIR}/fastcgi_params"
    echo 'fastcgi_param  HTTP_PROXY         "";' >> "${OPENRESTY_CONF_DIR}/fastcgi_params"
}

# Load OpenResty environment variables
. /opt/bitnami/scripts/openresty-env.sh

# Ensure non-root user has write permissions on a set of directories
declare -a writable_dirs=(
    "$OPENRESTY_VOLUME_DIR"
    "$OPENRESTY_CONF_DIR"
    "${OPENRESTY_BASE_DIR}/nginx"
    "$OPENRESTY_SERVER_BLOCKS_DIR"
    "${OPENRESTY_CONF_DIR}/bitnami"
    "${OPENRESTY_CONF_DIR}/bitnami/certs"
    "$OPENRESTY_LOGS_DIR"
    "$OPENRESTY_TMP_DIR"
    "$OPENRESTY_SITE_DIR"
    "$OPENRESTY_INITSCRIPTS_DIR"
    "$OPM_BASE_DIR"
)
for dir in "${writable_dirs[@]}"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# Unset HTTP_PROXY header to protect vs HTTPPOXY vulnerability
openresty_patch_httpoxy_vulnerability

# Configure default HTTP port
openresty_configure_port "$OPENRESTY_DEFAULT_HTTP_PORT_NUMBER"

# Users can mount their html sites at /app
mv "$OPENRESTY_HTDOCS_DIR" /app
ln -sf /app "$OPENRESTY_HTDOCS_DIR"

# Users can mount their certificates at /certs
mv "${OPENRESTY_CONF_DIR}/bitnami/certs" /certs
ln -sf /certs "${OPENRESTY_CONF_DIR}/bitnami/certs"

ln -sf "/dev/stdout" "${OPENRESTY_LOGS_DIR}/access.log"
ln -sf "/dev/stderr" "${OPENRESTY_LOGS_DIR}/error.log"
