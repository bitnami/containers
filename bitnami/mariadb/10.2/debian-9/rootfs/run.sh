#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose
# shellcheck disable=SC1091

# Load libraries
. /libmariadb.sh
. /libos.sh

# Load MariaDB env. variables
eval "$(mysql_env)"

info "** Starting MariaDB **"
if am_i_root; then
    exec gosu "$DB_DAEMON_USER" "${DB_SBINDIR}/mysqld" --defaults-file="${DB_CONFDIR}/my.cnf" --basedir="$DB_BASEDIR" --datadir="$DB_DATADIR" --socket="${DB_TMPDIR}/mysql.sock" --port="$DB_PORT_NUMBER" "${DB_EXTRA_FLAGS[@]}"
else
    exec "${DB_SBINDIR}/mysqld" --defaults-file="${DB_CONFDIR}/my.cnf" --basedir="$DB_BASEDIR" --datadir="$DB_DATADIR" --socket="${DB_TMPDIR}/mysql.sock" --port="$DB_PORT_NUMBER" "${DB_EXTRA_FLAGS[@]}"
fi
