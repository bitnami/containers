#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /libfs.sh
. /libos.sh
. /libmariadbgalera.sh

# Load MariaDB environment variables
eval "$(mysql_env)"

# Ensure MariaDB environment variables settings are valid
mysql_validate
# Ensure MariaDB is stopped when this script ends.
trap "mysql_stop" EXIT
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$DB_DAEMON_USER" "$DB_DAEMON_GROUP"
# Ensure MariaDB is initialized
mysql_initialize
# configure LDAP parameters
ldap_config

mysql_custom_init_scripts
