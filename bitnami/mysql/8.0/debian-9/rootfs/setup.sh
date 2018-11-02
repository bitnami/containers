#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libfs.sh
. /libos.sh
. /libmysql.sh

# Load MySQL env. variables
eval "$(mysql_env)"

# Ensure MySQL env var settings are valid
mysql_validate
# Ensure MySQL is stopped when this script ends.
trap "mysql_stop" EXIT
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$DB_DAEMON_USER" "$DB_DAEMON_GROUP"
# Ensure MySQL is initialized
mysql_initialize
# Allow running custom initialization scripts
msyql_custom_init_scripts
