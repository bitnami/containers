#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load ownCloud environment
. /opt/bitnami/scripts/owncloud-env.sh

# Load PHP environment for 'php_conf_set' (after 'owncloud-env.sh' so that MODULE is not set to a wrong value)
. /opt/bitnami/scripts/php-env.sh

# Load libraries
. /opt/bitnami/scripts/libowncloud.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment and functions (after ownCloud environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Ensure the ownCloud base directory exists and has proper permissions
info "Configuring file permissions for ownCloud"
ensure_user_exists "$WEB_SERVER_DAEMON_USER" --group "$WEB_SERVER_DAEMON_GROUP"
# The assets dir and tp are needed but not created by ownCloud
for dir in "$OWNCLOUD_BASE_DIR" "$OWNCLOUD_VOLUME_DIR"; do
    ensure_dir_exists "$dir"
    # Use daemon:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
done

# ownCloud provides a .user.ini file which can be used to set PHP configuration as if we were configuring in 'php.ini'
# This only applies for PHP-FPM (not mod_php) so we set it in both locations as we don't know beforehand which mode will be enabled
info "Configuring default PHP options for ownCloud"
for php_ini_file in "${OWNCLOUD_BASE_DIR}/.user.ini" "$PHP_CONF_FILE"; do
    php_conf_set memory_limit "$PHP_DEFAULT_MEMORY_LIMIT" "$php_ini_file"
    php_conf_set upload_max_filesize "$PHP_DEFAULT_UPLOAD_MAX_FILESIZE" "$php_ini_file"
    php_conf_set post_max_size "$PHP_DEFAULT_POST_MAX_SIZE" "$php_ini_file"
done
# Enable imagick extension by default
php_conf_set extension "imagick"

# Enable default web server configuration for ownCloud
info "Creating default web server configuration for ownCloud"
web_server_validate
# Not moving .htaccess because ownCloud generates some of them during installation
ensure_web_server_app_configuration_exists "owncloud" --type php --apache-move-htaccess "no"
