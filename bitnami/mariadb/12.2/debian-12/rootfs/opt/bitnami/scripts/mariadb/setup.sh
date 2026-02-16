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
. /opt/bitnami/scripts/libmariadb.sh

# Load MariaDB environment variables
. /opt/bitnami/scripts/mariadb-env.sh

# Ensure MariaDB environment variables settings are valid
mariadb_validate
# Ensure MariaDB unix socket and PID files does not exist if leftovers are present
# This fixes an issue where the trap would kill the entrypoint.sh
rm -f "${DB_SOCKET_FILE}.lock" "$DB_PID_FILE"
# Ensure MariaDB is stopped when this script ends.
trap "mysql_stop" EXIT
if am_i_root; then
    # Ensure 'daemon' user exists when running as 'root'
    ensure_user_exists "$DB_DAEMON_USER" --group "$DB_DAEMON_GROUP"
    # Fix logging issue when running as root
    chmod o+w "$(readlink /dev/stdout)"
fi
# Ensure MariaDB is initialized
mariadb_initialize
# Allow running custom initialization scripts
mariadb_custom_scripts 'init'
# Allow running custom start scripts
mariadb_custom_scripts 'start'
# Stop MariaDB before flagging it as fully initialized.
# Relying only on the trap defined above could produce a race condition.
mysql_stop
