#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Matomo environment
. /opt/bitnami/scripts/matomo-env.sh

# Load PHP environment for 'php_conf_set' (after 'matomo-env.sh' so that MODULE is not set to a wrong value)
. /opt/bitnami/scripts/php-env.sh

# Load libraries
. /opt/bitnami/scripts/libmatomo.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment and functions (after Matomo environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# The Matomo configuration is created by the Wizard so no defaults will be set at postunpack time

# Ensure the Matomo base directory exists and has proper permissions
info "Configuring file permissions for Matomo"
ensure_user_exists "$WEB_SERVER_DAEMON_USER" --group "$WEB_SERVER_DAEMON_GROUP"
for dir in "$MATOMO_BASE_DIR" "$MATOMO_VOLUME_DIR" "${MATOMO_BASE_DIR}/tmp" "${MATOMO_BASE_DIR}/misc/" "${MATOMO_BASE_DIR}/misc/user" "${MATOMO_BASE_DIR}/plugins"; do
    ensure_dir_exists "$dir"
    # Use daemon:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
done

info "Configuring default PHP options for Matomo"
php_conf_set memory_limit "$PHP_DEFAULT_MEMORY_LIMIT"
# Fix the MySQL local infile system check
# https://matomo.org/faq/troubleshooting/faq_194/
php_conf_set mysqli.allow_local_infile "1"
# Fix the geolocalization system check
# https://matomo.org/faq/how-to/faq_164/
php_conf_set extension "maxminddb.so"

# Enable default web server configuration for Matomo
info "Creating default web server configuration for Matomo"
web_server_validate
# We cannot move the .htaccess because one of the system checks will fail
ensure_web_server_app_configuration_exists "matomo" --type php --apache-move-htaccess "no"

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "/opt/bitnami/$(web_server_type)/conf"/* "/opt/bitnami/$(web_server_type)/conf.default"

# This is necessary for the libpersistence.sh scripts to work when running as non-root
chmod g+w "$BITNAMI_ROOT_DIR"
