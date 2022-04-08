#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load TestLink environment
. /opt/bitnami/scripts/testlink-env.sh

# Load PHP environment for 'php_conf_set' (after 'testlink-env.sh' so that MODULE is not set to a wrong value)
. /opt/bitnami/scripts/php-env.sh

# Load libraries
. /opt/bitnami/scripts/libtestlink.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment and functions (after TestLink environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Generate customized TestLink settings file based on:
# - https://github.com/TestLinkOpenSourceTRMS/testlink-code/blob/testlink_1_9/config.inc.php
# - https://github.com/TestLinkOpenSourceTRMS/testlink-code/blob/testlink_1_9/custom_config.inc.php.example
[[ ! -f "$TESTLINK_CUSTOM_CONF_FILE" ]] && cat >"$TESTLINK_CUSTOM_CONF_FILE" <<EOF
<?php
\$tlCfg->log_path = '${TESTLINK_BASE_DIR}/logs/';
\$g_repositoryPath = '${TESTLINK_BASE_DIR}/upload_area/';
\$tlCfg->config_check_warning_mode = 'SCREEN';
\$tlCfg->default_language = '${TESTLINK_LANGUAGE}';

\$g_tl_admin_email = '${TESTLINK_EMAIL}';
\$g_from_email = '${TESTLINK_EMAIL}';
\$g_return_path_email = '${TESTLINK_EMAIL}';
\$g_smtp_host = '';
// \$g_smtp_port = '${TESTLINK_SMTP_PORT_NUMBER}';
// \$g_smtp_connection_mode = '${TESTLINK_SMTP_PROTOCOL}';
// \$g_smtp_username = '${TESTLINK_SMTP_USER}';
// \$g_smtp_password = '${TESTLINK_SMTP_PASSWORD}';

EOF

# Generate database TestLink settings file based on write_config_db function
# - https://github.com/TestLinkOpenSourceTRMS/testlink-code/blob/testlink_1_9/install/installNewDB.php
[[ ! -f "$TESTLINK_DATABASE_CONF_FILE" ]] && cat >"$TESTLINK_DATABASE_CONF_FILE" <<EOF
<?php
define('DB_TYPE', 'mysql');
define('DB_HOST', '${TESTLINK_DEFAULT_DATABASE_HOST}:${TESTLINK_DATABASE_PORT_NUMBER}');
define('DB_NAME', '${TESTLINK_DATABASE_NAME}');
define('DB_USER', '${TESTLINK_DATABASE_USER}');
define('DB_PASS', '${TESTLINK_DATABASE_PASSWORD}');
?>
EOF

# Ensure the TestLink base directory exists and has proper permissions
info "Configuring file permissions for TestLink"
ensure_user_exists "$WEB_SERVER_DAEMON_USER" --group "$WEB_SERVER_DAEMON_GROUP"
for dir in "$TESTLINK_BASE_DIR" "$TESTLINK_VOLUME_DIR"; do
    ensure_dir_exists "$dir"
    # Use daemon:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$WEB_SERVER_DAEMON_USER" -g "root"
done

# Configure required PHP options for application to work properly, based on build-time defaults
info "Configuring default PHP options for TestLink"
php_conf_set memory_limit "$PHP_DEFAULT_MEMORY_LIMIT"

# Enable default web server configuration for TestLink
info "Creating default web server configuration for TestLink"
web_server_validate
ensure_web_server_app_configuration_exists "testlink" --type php
