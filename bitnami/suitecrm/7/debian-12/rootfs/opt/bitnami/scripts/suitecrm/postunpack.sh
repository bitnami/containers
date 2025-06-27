#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load SuiteCRM environment
. /opt/bitnami/scripts/suitecrm-env.sh

# Load PHP environment for 'php_conf_set' (after 'suitecrm-env.sh' so that MODULE is not set to a wrong value)
. /opt/bitnami/scripts/php-env.sh

# Load libraries
. /opt/bitnami/scripts/libsuitecrm.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment and functions (after SuiteCRM environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Ensure the SuiteCRM base directory exists and has proper permissions
info "Configuring file permissions for SuiteCRM"
ensure_user_exists "$WEB_SERVER_DAEMON_USER" --group "$WEB_SERVER_DAEMON_GROUP"
for dir in "$SUITECRM_BASE_DIR" "$SUITECRM_VOLUME_DIR" "${SUITECRM_BASE_DIR}/tmp"; do
    ensure_dir_exists "$dir"
    # Use daemon:daemon ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
done

# Configure required PHP options for application to work properly, based on build-time defaults
info "Configuring default PHP options for SuiteCRM"
php_conf_set memory_limit "$PHP_DEFAULT_MEMORY_LIMIT"
php_conf_set upload_max_filesize "$PHP_DEFAULT_UPLOAD_MAX_FILESIZE"
php_conf_set post_max_size "$PHP_DEFAULT_POST_MAX_SIZE"
# Disabling opcache to be able to modify parameters using the system setting panel. Ref: T18279
php_conf_set "opcache.enable" "Off"

# Enable default web server configuration for SuiteCRM
info "Creating default web server configuration for SuiteCRM"
web_server_validate
# Not moving .htaccess because SuiteCRM generates some of them during installation
# Backward compatibility with SuiteCRM 7
if [[ -d "${SUITECRM_BASE_DIR}/public" ]]; then
    ensure_web_server_app_configuration_exists "suitecrm" --type php --apache-move-htaccess "no" --document-root "${BITNAMI_ROOT_DIR}/suitecrm/public"
else
    ensure_web_server_app_configuration_exists "suitecrm" --type php --apache-move-htaccess "no"
fi
