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
. /opt/bitnami/scripts/libmariadbgalera.sh
. /opt/bitnami/scripts/libldapclient.sh

# Load MariaDB environment variables
. /opt/bitnami/scripts/mariadb-env.sh

# Load LDAP environment variables
eval "$(ldap_env)"

# Ensure mysql unix socket file does not exist
rm -rf "${DB_SOCKET_FILE}.lock"
# Ensure MariaDB environment variables settings are valid
mysql_validate
# Ensure MariaDB is stopped when this script ends.
trap "mysql_stop" EXIT
if am_i_root; then
    # Ensure 'daemon' user exists when running as 'root'
    ensure_user_exists "$DB_DAEMON_USER" --group "$DB_DAEMON_GROUP"
    # Ensure 'nslcd' user exists when running as 'root'
    ensure_user_exists "$LDAP_NSLCD_USER" --group "$LDAP_NSLCD_GROUP"
    # Fix logging issue when running as root
    chmod o+w "$(readlink /dev/stdout)"
fi
# Ensure MariaDB is initialized
mysql_initialize
# Ensure LDAP is initialized
is_boolean_yes "$DB_ENABLE_LDAP" && ldap_initialize
# Allow running custom initialization scripts
mysql_custom_scripts 'init'
# Allow running custom start scripts
mysql_custom_scripts 'start'
# Stop MariaDB before flagging it as fully initialized.
# Relying only on the trap defined above could produce a race condition.
mysql_stop
