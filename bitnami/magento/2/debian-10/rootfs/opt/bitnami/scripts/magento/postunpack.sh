#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Magento environment
. /opt/bitnami/scripts/magento-env.sh

# Load PHP environment for 'php_conf_set' (after 'magento-env.sh' so that MODULE is not set to a wrong value)
. /opt/bitnami/scripts/php-env.sh

# Load libraries
. /opt/bitnami/scripts/libmagento.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment and functions (after Magento environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Ensure the Magento base directory exists and has proper permissions
info "Configuring file permissions for Magento"
ensure_user_exists "$WEB_SERVER_DAEMON_USER" --group "$WEB_SERVER_DAEMON_GROUP"
for dir in "$MAGENTO_BASE_DIR" "$MAGENTO_VOLUME_DIR" "${MAGENTO_BASE_DIR}/tmp" "${MAGENTO_BASE_DIR}/uploads"; do
    ensure_dir_exists "$dir"
    # Use daemon:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
done

# Configure required PHP options for application to work properly, based on build-time defaults
info "Configuring default PHP options for Magento"
php_conf_set max_execution_time "$PHP_DEFAULT_MAX_EXECUTION_TIME"
php_conf_set memory_limit "$PHP_DEFAULT_MEMORY_LIMIT"
# These recommended values obtained from Magento's official documentation
# https://devdocs.magento.com/guides/v2.4/performance-best-practices/software.html#php-settings
php_conf_set realpath_cache_size "10M"
php_conf_set realpath_cache_ttl "7200"
php_conf_set opcache.memory_consumption "512MB"
php_conf_set opcache.max_accelerated_files "60000"
php_conf_set opcache.consistency_checks "0"
php_conf_set opcache.validate_timestamps "0"
php_conf_set opcache.enable_cli "1"

# Enable default web server configuration for Magento
info "Creating default web server configuration for Magento"
web_server_validate
ensure_web_server_app_configuration_exists "magento" --type php \
    --apache-move-htaccess no # Magento generates .htaccess dynamically during setup

# Grant execution permissions for the Magento CLI
chmod 775 "${MAGENTO_BIN_DIR}/magento"
