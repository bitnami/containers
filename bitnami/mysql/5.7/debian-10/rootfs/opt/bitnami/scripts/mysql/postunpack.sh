#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libmysql.sh

# Load MySQL environment variables
eval "$(mysql_env)"

for dir in "$DB_TMP_DIR" "$DB_LOG_DIR" "$DB_CONF_DIR" "${DB_CONF_DIR}/bitnami" "$DB_VOLUME_DIR" "$DB_DATA_DIR"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$DB_TMP_DIR" "$DB_LOG_DIR" "$DB_CONF_DIR" "${DB_CONF_DIR}/bitnami" "$DB_VOLUME_DIR" "$DB_DATA_DIR"

# Redirect all logging to stdout
ln -sf /dev/stdout "$DB_LOG_DIR/mysqld.log"
