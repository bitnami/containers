#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Osclass environment
. /opt/bitnami/scripts/osclass-env.sh

# Load PHP environment for 'php_conf_set' (after 'osclass-env.sh' so that MODULE is not set to a wrong value)
. /opt/bitnami/scripts/php-env.sh

# Load libraries
. /opt/bitnami/scripts/libosclass.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment (after Osclass environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Ensure the Osclass base directory exists and has proper permissions
info "Configuring file permissions for Osclass"
ensure_user_exists "$WEB_SERVER_DAEMON_USER" --group "$WEB_SERVER_DAEMON_GROUP"
for dir in "$OSCLASS_BASE_DIR" "$OSCLASS_VOLUME_DIR"; do
    ensure_dir_exists "$dir"
    # Use daemon:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "g+rwx" -f "g+rw" -u "$WEB_SERVER_DAEMON_USER" -g "root"
done

# Enable default web server configuration for Osclass
info "Creating default web server configuration for Osclass"
web_server_validate
ensure_web_server_app_configuration_exists "osclass" --type php --apache-additional-configuration '
# Bypass mod_dir in order to allow 80->8080 redirections when not using a reverse proxy (example: docker-compose or Kubernetes)
<LocationMatch "^/oc-admin$">
    DirectorySlash off
</LocationMatch>

# Custom rewrite by Bitnami - bypass mod_dir in order to allow 80->8080 redirections when not using a reverse proxy (example: docker-compose or Kubernetes)
RewriteEngine on
RewriteRule "^/oc-admin$"  "/oc-admin/index.php"
'
