#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libphppgadmin.sh

# Load phpPgAdmin environment
. /opt/bitnami/scripts/phppgadmin-env.sh

# Load PHP environment, for 'php_conf_set'
# Must be loaded after phpPgAdmin environment file, to avoid MODULE being set to 'php'
. /opt/bitnami/scripts/php-env.sh

# Enable phpPgAdmin configuration file
[[ ! -f "$PHPPGADMIN_CONF_FILE" ]] && cp "${PHPPGADMIN_BASE_DIR}/conf/config.inc.php-dist" "$PHPPGADMIN_CONF_FILE"

# Ensure the phpPgAdmin base directory exists and has proper permissions
for dir in "$PHPPGADMIN_BASE_DIR" "$PHPPGADMIN_VOLUME_DIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664"
done

# Disable extra login security by default, as it denies logins to the 'postgres' user
phppgadmin_conf_set "\$conf['extra_login_security']" "$(php_convert_to_boolean "$PHPPGADMIN_DEFAULT_ENABLE_EXTRA_LOGIN_SECURITY")" yes

# Setup default database host and port in phpPgAdmin configuration
phppgadmin_conf_set "\$conf['servers'][0]['host']" "$DATABASE_DEFAULT_HOST"
phppgadmin_conf_set "\$conf['servers'][0]['port']" "$DATABASE_DEFAULT_PORT_NUMBER" yes
# Configure path to PostgreSQL dump binaries
phppgadmin_conf_set "\$conf['servers'][0]['pg_dump_path']" "${BITNAMI_ROOT_DIR}/postgresql/bin/pg_dump"
phppgadmin_conf_set "\$conf['servers'][0]['pg_dumpall_path']" "${BITNAMI_ROOT_DIR}/postgresql/bin/pg_dumpall"

# Configure PHP options based on build-time defaults
info "Configuring default PHP options for phpPgAdmin"
php_conf_set upload_max_filesize "$PHP_DEFAULT_UPLOAD_MAX_FILESIZE"
php_conf_set post_max_size "$PHP_DEFAULT_POST_MAX_SIZE"
php_conf_set memory_limit "$PHP_DEFAULT_MEMORY_LIMIT"

# Load additional required libraries
# shellcheck disable=SC1091
. /opt/bitnami/scripts/libwebserver.sh

# Enable build-time web server configuration defaults for phpPgAdmin
info "Creating default web server configuration for phpPgAdmin"
web_server_validate
phppgadmin_ensure_web_server_app_configuration_exists
