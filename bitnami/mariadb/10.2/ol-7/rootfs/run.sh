#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

. /libmariadb.sh
. /libos.sh

eval "$(mysql_env)"

info "** Starting MariaDB **"
# If container is started as `root` use
extraFlags=($DB_EXTRA_FLAGS)
[ -z "$DB_EXTRA_FLAGS" ] && extraFlags[0]=" " # Ensure 'extraFlags' array is not empty
if am_i_root; then
    exec gosu "$DB_DAEMON_USER" "$DB_BINDIR/mysqld_safe" --defaults-file="$DB_CONFDIR/my.cnf" --basedir="$DB_BASEDIR" --datadir="$DB_DATADIR" ${extraFlags[*]}
else
    exec "$DB_BINDIR/mysqld_safe" --defaults-file="$DB_CONFDIR/my.cnf" --basedir="$DB_BASEDIR" --datadir="$DB_DATADIR" ${extraFlags[*]}
fi
