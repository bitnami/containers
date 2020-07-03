#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load phpMyAdmin environment
. /opt/bitnami/scripts/phpmyadmin-env.sh

# Load web server environment and functions (after phpMyAdmin environment file so MODULE is not set to a wrong value)
. /opt/bitnami/scripts/libwebserver.sh

# Load libraries
. /opt/bitnami/scripts/libphpmyadmin.sh
. /opt/bitnami/scripts/libos.sh

# Ensure phpMyAdmin environment variables are valid
phpmyadmin_validate

# Ensure proper ownership for the phpMyAdmin 'tmp' directory
if am_i_root; then
    ensure_user_exists "$WEB_SERVER_DAEMON_USER" "$WEB_SERVER_DAEMON_GROUP"
    info "Ensuring phpMyAdmin directories have proper permissions"
    configure_permissions_ownership "$PHPMYADMIN_TMP_DIR" -u "$WEB_SERVER_DAEMON_USER" -g "$WEB_SERVER_DAEMON_GROUP"
fi

# Ensure phpMyAdmin is initialized
phpmyadmin_initialize

# Configure web server for phpMyAdmin based on the runtime environment
info "Enabling web server application configuration for phpMyAdmin"
phpmyadmin_ensure_web_server_app_configuration_exists
