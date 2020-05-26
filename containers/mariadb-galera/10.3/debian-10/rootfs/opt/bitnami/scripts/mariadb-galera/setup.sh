#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libmariadbgalera.sh
. /opt/bitnami/scripts/libldapclient.sh

# Load MariaDB environment variables
eval "$(mysql_env)"
# Load LDAP environment variables
eval "$(ldap_env)"

# Ensure MariaDB environment variables settings are valid
mysql_validate
# Ensure MariaDB is stopped when this script ends.
trap "mysql_stop" EXIT
# Ensure both 'daemon' & 'nslcd' users exists when running as 'root'
am_i_root && ensure_user_exists "$DB_DAEMON_USER" "$DB_DAEMON_GROUP"
am_i_root && ensure_user_exists "$LDAP_NSLCD_USER" "$LDAP_NSLCD_GROUP"
# Ensure MariaDB is initialized
mysql_initialize
# Ensure LDAP is initialized
is_boolean_yes "$DB_ENABLE_LDAP" && ldap_initialize

mysql_custom_init_scripts
