#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

. /libmysql.sh
. /libos.sh

# Load MySQL environment variables
eval "$(mysql_env)"

flags=("--defaults-file=${DB_CONF_DIR}/my.cnf" "--basedir=$DB_BASE_DIR" "--datadir=$DB_DATA_DIR" "--socket=${DB_TMP_DIR}/mysql.sock" "--port=$DB_PORT_NUMBER")
[[ -z "${DB_EXTRA_FLAGS:-}" ]] || flags=("${flags[@]}" "${DB_EXTRA_FLAGS[@]}")

info "** Starting MySQL **"
if am_i_root; then
    exec gosu "$DB_DAEMON_USER" "${DB_SBIN_DIR}/mysqld" "${flags[@]}"
else
    exec "${DB_SBIN_DIR}/mysqld" "${flags[@]}"
fi
