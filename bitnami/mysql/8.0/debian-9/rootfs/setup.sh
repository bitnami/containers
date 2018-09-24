#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

. /libfs.sh
. /libmysql.sh
. /libos.sh

# ensure MySQL env var settings are valid
mysql_valid_settings

# ensure MySQL is stopped when this script ends.
trap "mysql_stop" EXIT

if am_i_root; then
    ensure_user_exists "$DB_DAEMON_USER" "$DB_DAEMON_GROUP"
fi

# ensure MySQL is initialized
mysql_initialize

# allow running custom initialization scripts
msyql_custom_init_scripts
