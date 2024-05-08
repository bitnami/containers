#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load OpenCart environment
. /opt/bitnami/scripts/opencart-env.sh

# Load PHP environment for 'php_conf_set' (after 'opencart-env.sh' so that MODULE is not set to a wrong value)
. /opt/bitnami/scripts/php-env.sh

# Load libraries
. /opt/bitnami/scripts/libopencart.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment and functions (after OpenCart environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Enable OpenCart configuration files
[[ ! -f "$OPENCART_CONF_FILE" ]] && cp "${OPENCART_BASE_DIR}/config-dist.php" "$OPENCART_CONF_FILE"
[[ ! -f "${OPENCART_BASE_DIR}/admin/config.php" ]] && cp "${OPENCART_BASE_DIR}/admin/config-dist.php" "${OPENCART_BASE_DIR}/admin/config.php"

# Ensure the OpenCart base directory exists and has proper permissions
info "Configuring file permissions for OpenCart"
ensure_user_exists "$WEB_SERVER_DAEMON_USER" --group "$WEB_SERVER_DAEMON_GROUP"
for dir in "$OPENCART_BASE_DIR" "$OPENCART_VOLUME_DIR" "$OPENCART_STORAGE_DIR"; do
    ensure_dir_exists "$dir"
    # Use daemon:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
done

# Enable friendly URLs by renaming .htaccess.txt to .htaccess (refer to top comment in the file)
mv "${OPENCART_BASE_DIR}/.htaccess.txt" "${OPENCART_BASE_DIR}/.htaccess"

# Configure required PHP options for application to work properly, based on build-time defaults
info "Configuring default PHP options for OpenCart"
php_conf_set memory_limit "$PHP_DEFAULT_MEMORY_LIMIT"

# Enable default web server configuration for OpenCart
info "Creating default web server configuration for OpenCart"
web_server_validate
ensure_web_server_app_configuration_exists "opencart" --type php

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "/opt/bitnami/$(web_server_type)/conf"/* "/opt/bitnami/$(web_server_type)/conf.default"
