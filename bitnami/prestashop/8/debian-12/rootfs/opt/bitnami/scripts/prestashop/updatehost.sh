#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load PrestaShop environment
. /opt/bitnami/scripts/prestashop-env.sh

# Load MySQL Client environment for 'mysql_remote_execute' (after 'prestashop-env.sh' so that MODULE is not set to a wrong value)
if [[ -f /opt/bitnami/scripts/mysql-client-env.sh ]]; then
    . /opt/bitnami/scripts/mysql-client-env.sh
elif [[ -f /opt/bitnami/scripts/mysql-env.sh ]]; then
    . /opt/bitnami/scripts/mysql-env.sh
elif [[ -f /opt/bitnami/scripts/mariadb-env.sh ]]; then
    . /opt/bitnami/scripts/mariadb-env.sh
fi

# Load libraries
. /opt/bitnami/scripts/libprestashop.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load web server environment and functions (after PrestaShop environment file so MODULE is not set to a wrong value)
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# Load database library
if [[ -f /opt/bitnami/scripts/libmysqlclient.sh ]]; then
    . /opt/bitnami/scripts/libmysqlclient.sh
elif [[ -f /opt/bitnami/scripts/libmysql.sh ]]; then
    . /opt/bitnami/scripts/libmysql.sh
elif [[ -f /opt/bitnami/scripts/libmariadb.sh ]]; then
    . /opt/bitnami/scripts/libmariadb.sh
fi

DOMAIN="${1:?missing host}"
HTTP_HOST="$DOMAIN"
[[ -n "$PRESTASHOP_EXTERNAL_HTTP_PORT_NUMBER" && "$PRESTASHOP_EXTERNAL_HTTP_PORT_NUMBER" != "80" ]] && HTTP_HOST="${DOMAIN}:${PRESTASHOP_EXTERNAL_HTTP_PORT_NUMBER}"
HTTPS_HOST="$DOMAIN"
[[ -n "$PRESTASHOP_EXTERNAL_HTTPS_PORT_NUMBER" && "$PRESTASHOP_EXTERNAL_HTTPS_PORT_NUMBER" != "443" ]] && HTTPS_HOST="${DOMAIN}:${PRESTASHOP_EXTERNAL_HTTPS_PORT_NUMBER}"
read -r -a DB_ARGS <<< "$(prestashop_db_args)"

info "Trying to connect to the database server"
prestashop_wait_for_db_connection "${DB_ARGS[@]}"

info "Updating hostname in database"
mysql_remote_execute "${DB_ARGS[@]}" <<EOF
UPDATE ps_shop_url SET domain='${HTTP_HOST}', domain_ssl='${HTTPS_HOST}' WHERE id_shop_url='1';
EOF

# Purge cache and regenerate .htaccess, for the domain to be updated properly
# Unfortunately there aren't any CLI option to perform these actions, but it is simple to do with internal PrestaShop functions
# The commands need to be executed as the web server daemon user, to ensure permissions are not messed up with
info "Purging cache"
debug_execute run_as_user "$WEB_SERVER_DAEMON_USER" php -r "require '${PRESTASHOP_BASE_DIR}/config/config.inc.php'; Tools::clearAllCache(); Tools::generateHtaccess();"
