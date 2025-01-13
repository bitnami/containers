#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Drupal environment
. /opt/bitnami/scripts/drupal-env.sh

# Load PHP environment for 'php_conf_set' (after 'drupal-env.sh' so that MODULE is not set to a wrong value)
. /opt/bitnami/scripts/php-env.sh

# Load libraries
. /opt/bitnami/scripts/libdrupal.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment and functions (after Drupal environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Enable Drupal configuration file
[[ ! -f "$DRUPAL_CONF_FILE" ]] && cp "${DRUPAL_BASE_DIR}/sites/default/default.settings.php" "$DRUPAL_CONF_FILE"

# Create .htaccess file to avoid warning in Drupal administration panel
drupal_fix_htaccess_warning_protection

# Ensure the Drupal base directory exists and has proper permissions
info "Configuring file permissions for Drupal"
for dir in "$DRUPAL_BASE_DIR" "${DRUPAL_BASE_DIR}/sites/default/files" "$DRUPAL_VOLUME_DIR" "${HOME}/.drush"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664"
done
for dir in "${DRUPAL_BASE_DIR}/themes" "${DRUPAL_BASE_DIR}/modules" "${DRUPAL_BASE_DIR}/sites/default/files"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -u "$WEB_SERVER_DAEMON_USER" -g "root"
done
chown "$WEB_SERVER_DAEMON_USER" "${DRUPAL_BASE_DIR}/sites/default"
chown "$WEB_SERVER_DAEMON_USER" "$DRUPAL_CONF_FILE"
for script in "${DRUPAL_BASE_DIR}/vendor/bin/drush" "${DRUPAL_BASE_DIR}/vendor/drush/drush/drush" "${DRUPAL_BASE_DIR}/vendor/bin/drush.php" "${DRUPAL_BASE_DIR}/vendor/drush/drush/drush.launcher" "${DRUPAL_BASE_DIR}/vendor/bin/drush.launcher"; do
    [[ -f "$script" ]] && chmod +x "$script"
done

# Configure Drupal based on build-time defaults
drupal_conf_set "\$settings['trusted_host_patterns']" "array('^.*$')" yes

# Configure required PHP options for application to work properly, based on build-time defaults
info "Configuring default PHP options for Drupal"
php_conf_set memory_limit "$PHP_DEFAULT_MEMORY_LIMIT"

# Enable default web server configuration for Drupal
info "Creating default web server configuration for Drupal"
web_server_validate
ensure_web_server_app_configuration_exists "drupal" --type php

# Re-create .htaccess file after being moved into 'apache/conf/vhosts/htaccess' directory, to avoid Drupal warning
drupal_fix_htaccess_warning_protection

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "/opt/bitnami/$(web_server_type)/conf"/* "/opt/bitnami/$(web_server_type)/conf.default"
