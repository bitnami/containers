#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load phpBB environment
. /opt/bitnami/scripts/phpbb-env.sh

# Load PHP environment for 'php_conf_set' (after 'phpbb-env.sh' so that MODULE is not set to a wrong value)
. /opt/bitnami/scripts/php-env.sh

# Load libraries
. /opt/bitnami/scripts/libphpbb.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment and functions (after phpBB environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Default installer JSON file
cp "${BITNAMI_ROOT_DIR}/scripts/phpbb/files/install_config.json" "$PHPBB_INSTALL_JSON_FILE"

# Ensure the phpBB base directory exists and has proper permissions
info "Configuring file permissions for phpBB"
ensure_user_exists "$WEB_SERVER_DAEMON_USER" --group "$WEB_SERVER_DAEMON_GROUP"
for dir in "$PHPBB_BASE_DIR" "$PHPBB_VOLUME_DIR"; do
    ensure_dir_exists "$dir"
    # Use daemon:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
done

# Configure memory limit for PHP
info "Configuring default PHP options for DokuWiki"
php_conf_set memory_limit "$PHP_DEFAULT_MEMORY_LIMIT"

# Enable default web server configuration for phpBB
info "Creating default web server configuration for phpBB"
web_server_validate
ensure_web_server_app_configuration_exists "phpbb" --type php --apache-additional-configuration "
# phpBB does not properly include PHP files because of symbolic links
# https://github.com/bitnami/bitnami-docker-phpbb/issues/61
Alias /bitnami/phpbb $PHPBB_VOLUME_DIR
<Directory \"$PHPBB_VOLUME_DIR\">
    Options -Indexes +FollowSymLinks -MultiViews
    AllowOverride None
    Require all granted
    DirectoryIndex index.html index.php
</Directory>
"

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "/opt/bitnami/$(web_server_type)/conf"/* "/opt/bitnami/$(web_server_type)/conf.default"
