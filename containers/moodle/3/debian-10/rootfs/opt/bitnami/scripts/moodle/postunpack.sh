#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Moodle environment
. /opt/bitnami/scripts/moodle-env.sh

# Load PHP environment for 'php_conf_set' (after 'moodle-env.sh' so that MODULE is not set to a wrong value)
. /opt/bitnami/scripts/php-env.sh

# Load libraries
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libmoodle.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment and functions (after Moodle environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Ensure the Moodle base directory exists and has proper permissions
info "Configuring file permissions for Moodle"
ensure_user_exists "$WEB_SERVER_DAEMON_USER" "$WEB_SERVER_DAEMON_GROUP"
for dir in "$MOODLE_BASE_DIR" "$MOODLE_VOLUME_DIR" "$MOODLE_DATA_DIR"; do
    ensure_dir_exists "$dir"
    # Use daemon:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
done

# Configure required PHP options for application to work properly, based on build-time defaults
info "Configuring default PHP options for Moodle"
php_conf_set memory_limit "$PHP_DEFAULT_MEMORY_LIMIT"

# Enable default web server configuration for Moodle
info "Creating default web server configuration for Moodle"
web_server_validate
ensure_web_server_app_configuration_exists "moodle" --type php
