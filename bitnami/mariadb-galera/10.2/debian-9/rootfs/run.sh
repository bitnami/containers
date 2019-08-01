#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /libmariadbgalera.sh
. /libos.sh

# Load MariaDB environment variables
eval "$(mysql_env)"

flags=("--defaults-file=${DB_CONFDIR}/my.cnf" "--basedir=$DB_BASEDIR" "--datadir=$DB_DATADIR" "--socket=${DB_TMPDIR}/mysql.sock" "--port=$DB_PORT_NUMBER")
[[ -z "${DB_EXTRA_FLAGS:-}" ]] || flags=("${flags[@]}" "${DB_EXTRA_FLAGS[@]}")

info "** Starting MariaDB **"
if am_i_root; then
    exec gosu "$DB_DAEMON_USER" "${DB_SBINDIR}/mysqld" "${flags[@]}"
else
    exec "${DB_SBINDIR}/mysqld" "${flags[@]}"
fi
