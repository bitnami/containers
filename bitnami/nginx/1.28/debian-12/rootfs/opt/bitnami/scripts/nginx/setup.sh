#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libnginx.sh

# Load NGINX environment variables
. /opt/bitnami/scripts/nginx-env.sh

# Ensure NGINX environment variables settings are valid
nginx_validate

# Ensure NGINX is stopped when this script ends
trap "nginx_stop" EXIT

# Ensure NGINX daemon user exists when running as 'root'
am_i_root && ensure_user_exists "$NGINX_DAEMON_USER" --group "$NGINX_DAEMON_GROUP"

# Configure HTTPS sample block using generated SSL certs
nginx_generate_sample_certs

# Run init scripts
nginx_custom_init_scripts

# Fix logging issue when running as root
! am_i_root || chmod o+w "$(readlink /dev/stdout)" "$(readlink /dev/stderr)"

# Configure HTTPS port number
if [[ -f "${NGINX_CONF_DIR}/bitnami/certs/server.crt" ]] && [[ -n "${NGINX_HTTPS_PORT_NUMBER:-}" ]] && [[ ! -f "${NGINX_SERVER_BLOCKS_DIR}/default-https-server-block.conf" ]] && is_file_writable "${NGINX_SERVER_BLOCKS_DIR}/default-https-server-block.conf"; then
    cp "${BITNAMI_ROOT_DIR}/scripts/nginx/bitnami-templates/default-https-server-block.conf" "${NGINX_SERVER_BLOCKS_DIR}/default-https-server-block.conf"
fi

# Initialize NGINX
nginx_initialize

