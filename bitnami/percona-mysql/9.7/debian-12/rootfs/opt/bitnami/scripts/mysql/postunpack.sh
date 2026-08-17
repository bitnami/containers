#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libmysql.sh

# Load Percona Server for MySQL environment variables
. /opt/bitnami/scripts/mysql-env.sh

# Configure MySQL options based on build-time defaults
info "Configuring default MySQL options"
ensure_dir_exists "$DB_CONF_DIR"
mysql_create_default_config

for dir in "$DB_TMP_DIR" "$DB_LOGS_DIR" "$DB_CONF_DIR" "${DB_CONF_DIR}/bitnami" "$DB_VOLUME_DIR" "$DB_DATA_DIR" "/.mysqlsh"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# Redirect all logging to stdout
ln -sf /dev/stdout "$DB_LOGS_DIR/mysqld.log"
