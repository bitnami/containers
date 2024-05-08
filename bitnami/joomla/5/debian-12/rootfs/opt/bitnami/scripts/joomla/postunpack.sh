#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Joomla! environment
. /opt/bitnami/scripts/joomla-env.sh

# Load PHP environment for 'php_conf_set' (after 'joomla-env.sh' so that MODULE is not set to a wrong value)
. /opt/bitnami/scripts/php-env.sh

# Load libraries
. /opt/bitnami/scripts/libjoomla.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment and functions (after Joomla! environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Enable Joomla! configuration file
[[ ! -f "$JOOMLA_CONF_FILE" ]] && cp "${JOOMLA_BASE_DIR}/installation/configuration.php-dist" "$JOOMLA_CONF_FILE"

# Ensure the Joomla! base directory exists and has proper permissions
info "Configuring file permissions for Joomla!"
ensure_user_exists "$WEB_SERVER_DAEMON_USER" --group "$WEB_SERVER_DAEMON_GROUP"
for dir in "$JOOMLA_BASE_DIR" "$JOOMLA_VOLUME_DIR" "$JOOMLA_TMP_DIR" "$JOOMLA_LOGS_DIR"; do
    ensure_dir_exists "$dir"
    # Use daemon:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
done

# Configure Joomla! based on build-time defaults
joomla_conf_set "\$sitename" "$JOOMLA_DEFAULT_SITE_NAME"
joomla_conf_set "\$fromname" "$JOOMLA_DEFAULT_SITE_NAME"
joomla_conf_set "\$log_path" "$JOOMLA_LOGS_DIR"
joomla_conf_set "\$tmp_path" "$JOOMLA_TMP_DIR"
joomla_conf_set "\$db" "$JOOMLA_DATABASE_NAME"
joomla_conf_set "\$host" "${JOOMLA_DEFAULT_DATABASE_HOST}:${JOOMLA_DEFAULT_DATABASE_PORT_NUMBER}"
joomla_conf_set "\$user" "$JOOMLA_DATABASE_USER"
joomla_conf_set "\$db" "$JOOMLA_DATABASE_NAME"

info "Configuring default PHP options for Joomla!"
php_conf_set memory_limit "$PHP_DEFAULT_MEMORY_LIMIT"

# The sql scripts contain a template "#__" which will be substituted by the
# prefix set in the configuration ("jos_" in our case), we need to adapt it.
debug "Adapting installation sql files"
for sql_file in "${JOOMLA_BASE_DIR}/installation/sql/mysql"/*.sql; do
    replace_in_file "$sql_file" "#__" "jos_"
done

# Enable default web server configuration for Joomla!
info "Creating default web server configuration for Joomla!"
web_server_validate

ensure_web_server_app_configuration_exists "joomla" --type php --apache-additional-configuration '
# Bypass mod_dir in order to allow 80->8080 redirections when not using a reverse proxy (example: docker-compose or Kubernetes)
<LocationMatch "^/administrator$">
    DirectorySlash off
</LocationMatch>
'
replace_in_file "${APACHE_HTACCESS_DIR}/joomla-htaccess.conf" '(## End [-] Custom redirects)' '# Custom rewrite by Bitnami - bypass mod_dir in order to allow 80->8080 redirections when not using a reverse proxy (example: docker-compose or Kubernetes)\n  RewriteRule "^administrator$"  "administrator/"\n  \1'

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "/opt/bitnami/$(web_server_type)/conf"/* "/opt/bitnami/$(web_server_type)/conf.default"
