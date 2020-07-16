#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

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
for script in "${DRUPAL_BASE_DIR}/vendor/drush/drush/drush" "${DRUPAL_BASE_DIR}/vendor/drush/drush/drush.launcher"; do
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
ensure_web_server_app_configuration_exists "drupal" \
    --type php \
    --nginx-additional-configuration $'
location = /favicon.ico {
  log_not_found off;
  access_log off;
}

location = /robots.txt {
  allow all;
  log_not_found off;
  access_log off;
}

location ~ ^/sites/.*/private/ {
  return 403;
}

# Block access to scripts in site files directory
location ~ ^/sites/[^/]+/files/.*\.php$ {
  deny all;
}

# Allow "Well-Known URIs" as per RFC 5785
location ~* ^/.well-known/ {
  allow all;
}

location / {
  try_files $uri /index.php?$query_string;
}

location @rewrite {
  rewrite ^/(.*)$ /index.php?q=$1;
}

# Don\'t allow direct access to PHP files in the vendor directory.
location ~ /vendor/.*\.php$ {
  deny all;
  return 404;
}

# Fighting with Styles? This little gem is amazing.
location ~ ^/sites/.*/files/styles/ {
  try_files $uri @rewrite;
}

# Handle private files through Drupal. Private file\'s path can come
# with a language prefix.
location ~ ^(/[a-z\-]+)?/system/files/ {
  try_files $uri /index.php?$query_string;
}

location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
  try_files $uri @rewrite;
  expires max;
  log_not_found off;
}'

# Re-create .htaccess file after being moved into 'apache/conf/vhosts/htaccess' directory, to avoid Drupal warning
drupal_fix_htaccess_warning_protection
