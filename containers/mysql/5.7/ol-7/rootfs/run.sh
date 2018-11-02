#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace
# shellcheck disable=SC1091

. /libmysql.sh
. /libos.sh

# Load MySQL env. variables
eval "$(mysql_env)"

flags=("--defaults-file=${DB_CONFDIR}/my.cnf" "--basedir=$DB_BASEDIR" "--datadir=$DB_DATADIR" "--socket=${DB_TMPDIR}/mysql.sock" "--port=$DB_PORT_NUMBER")
[[ -z "${DB_EXTRA_FLAGS:-}" ]] || flags=("${flags[@]}" "${DB_EXTRA_FLAGS[@]}")

info "** Starting MySQL **"
if am_i_root; then
    exec gosu "$DB_DAEMON_USER" "${DB_SBINDIR}/mysqld" "${flags[@]}"
else
    exec "${DB_SBINDIR}/mysqld" "${flags[@]}"
fi
