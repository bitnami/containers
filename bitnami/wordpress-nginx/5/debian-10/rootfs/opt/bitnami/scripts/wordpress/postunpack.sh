#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load WordPress environment
. /opt/bitnami/scripts/wordpress-env.sh

# Load PHP environment for 'php_conf_set' (after 'wordpress-env.sh' so that MODULE is not set to a wrong value)
. /opt/bitnami/scripts/php-env.sh

# Load libraries
. /opt/bitnami/scripts/libwordpress.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment (after WordPress environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Enable WordPress configuration file
[[ ! -f "$WORDPRESS_CONF_FILE" ]] && cp "${WORDPRESS_BASE_DIR}/wp-config-sample.php" "$WORDPRESS_CONF_FILE"

# Ensure the WordPress base directory exists and has proper permissions
info "Configuring file permissions for WordPress"
ensure_user_exists "$WEB_SERVER_DAEMON_USER" --group "$WEB_SERVER_DAEMON_GROUP"
declare -a writable_dirs=(
    "$WORDPRESS_BASE_DIR" "$WORDPRESS_VOLUME_DIR" "${WORDPRESS_BASE_DIR}/tmp"
    # These directories are needed for wp-cli to be able to install languages/plugins/packages/etc as a non-root user
    # However they are not included in the WordPress source tarball, so we create them at this point with proper ownership
    # All of them are used by different wp-cli commands, such as 'wp language', 'wp plugin', or 'wp media', amongst others
    "${WORDPRESS_BASE_DIR}/wp-content/languages" "${WORDPRESS_BASE_DIR}/wp-content/upgrade" "${WORDPRESS_BASE_DIR}/wp-content/uploads"
    "${WORDPRESS_CLI_BASE_DIR}/.cache" "${WORDPRESS_CLI_BASE_DIR}/.packages"
)
for dir in "${writable_dirs[@]}"; do
    ensure_dir_exists "$dir"
    # Use daemon:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "g+rwx" -f "g+rw" -u "$WEB_SERVER_DAEMON_USER" -g "root"
done

# Configure wp-cli
ensure_dir_exists "$WORDPRESS_CLI_CONF_DIR"
cat >"$WORDPRESS_CLI_CONF_FILE" <<EOF
# Global parameter defaults
path: "${WORDPRESS_BASE_DIR}"
EOF
render-template "${BITNAMI_ROOT_DIR}/scripts/wordpress/bitnami-templates/wp.tpl" >"${WORDPRESS_CLI_BIN_DIR}/wp"
configure_permissions_ownership "${WORDPRESS_CLI_BIN_DIR}/wp" -f "755"

info "Configuring default PHP options for WordPress"
php_conf_set memory_limit "$PHP_DEFAULT_MEMORY_LIMIT"
php_conf_set upload_max_filesize "$PHP_DEFAULT_UPLOAD_MAX_FILESIZE"
php_conf_set post_max_size "$PHP_DEFAULT_POST_MAX_SIZE"
# https://make.wordpress.org/hosting/handbook/handbook/server-environment/#php-extensions
php_conf_set extension "imagick"
# Memcached extension is required for W3 Total Cache plugin
php_conf_set extension "memcached"

# Enable default web server configuration for WordPress
info "Creating default web server configuration for WordPress"
web_server_validate
# Do not move htaccess files via WORDPRESS_HTACCESS_OVERRIDE_NONE
# so that users can choose whether to do it or not during initialization
WORDPRESS_HTACCESS_OVERRIDE_NONE=no wordpress_generate_web_server_configuration
