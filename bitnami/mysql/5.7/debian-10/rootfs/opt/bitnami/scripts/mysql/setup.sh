#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libmysql.sh

# Load MySQL environment variables
eval "$(mysql_env)"

# Ensure mysql unix socket file does not exist
rm -rf "$DB_TMP_DIR/mysql.sock.lock"
# Ensure MySQL environment variables settings are valid
mysql_validate
# Ensure MySQL is stopped when this script ends.
trap "mysql_stop" EXIT
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$DB_DAEMON_USER" "$DB_DAEMON_GROUP"
# Fix logging issue when running as root
am_i_root && chmod o+w "$(readlink /dev/stdout)"
# Ensure MySQL is initialized
mysql_initialize
# Allow running custom initialization scripts
mysql_custom_init_scripts
# Stop MySQL before flagging it as fully initialized.
# Relying only on the trap defined above could produce a race condition.
mysql_stop
# Flag MySQL as initialized for the benefit of later processes.
mysql_flag_initialized
