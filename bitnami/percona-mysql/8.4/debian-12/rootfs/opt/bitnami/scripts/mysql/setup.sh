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
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libmysql.sh

# Load Percona Server for MySQL environment variables
. /opt/bitnami/scripts/mysql-env.sh

# Ensure mysql unix socket file does not exist
rm -rf "${DB_SOCKET_FILE}.lock"
# Ensure Percona Server for MySQL environment variables settings are valid
mysql_validate
# Ensure Percona Server for MySQL is stopped when this script ends.
trap "mysql_stop" EXIT
if am_i_root; then
    # Ensure 'daemon' user exists when running as 'root'
    ensure_user_exists "$DB_DAEMON_USER" --group "$DB_DAEMON_GROUP"
    # Fix logging issue when running as root
    chmod o+w "$(readlink /dev/stdout)"
fi
# Ensure Percona Server for MySQL is initialized
mysql_initialize
# Allow running custom initialization scripts
mysql_custom_scripts 'init'
# Allow running custom start scripts
mysql_custom_scripts 'start'
# Stop Percona Server for MySQL before flagging it as fully initialized.
# Relying only on the trap defined above could produce a race condition.
mysql_stop
