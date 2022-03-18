#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libmariadb.sh

# Load MariaDB environment variables
. /opt/bitnami/scripts/mariadb-env.sh

# Configure MariaDB options based on build-time defaults
info "Configuring default MariaDB options"
ensure_dir_exists "$DB_CONF_DIR"
mysql_create_default_config

for dir in "$DB_TMP_DIR" "$DB_LOGS_DIR" "$DB_CONF_DIR" "${DB_CONF_DIR}/bitnami" "$DB_VOLUME_DIR" "$DB_DATA_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# Fix to avoid issues detecting plugins in mysql_install_db
ln -sf "$DB_BASE_DIR/plugin" "$DB_BASE_DIR/lib/plugin"

# Redirect all logging to stdout
ln -sf /dev/stdout "$DB_LOGS_DIR/mysqld.log"
