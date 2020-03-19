#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libmysql.sh
. /opt/bitnami/scripts/libos.sh

# Load MySQL environment variables
eval "$(mysql_env)"

# mysqld_safe does not allow logging to stdout/stderr, so we stick with mysqld
EXEC="${DB_SBIN_DIR}/mysqld"

flags=("--defaults-file=${DB_CONF_DIR}/my.cnf" "--basedir=$DB_BASE_DIR" "--datadir=$DB_DATA_DIR" "--socket=${DB_TMP_DIR}/mysql.sock" "--port=$DB_PORT_NUMBER")
[[ -z "${DB_EXTRA_FLAGS:-}" ]] || flags=("${flags[@]}" "${DB_EXTRA_FLAGS[@]}")

# Fix for MDEV-16183 - mysqld_safe already does this, but we are using mysqld
LD_PRELOAD="$(find_jemalloc_lib)${LD_PRELOAD:+ "$LD_PRELOAD"}"
export LD_PRELOAD

info "** Starting MySQL **"
if am_i_root; then
    exec gosu "$DB_DAEMON_USER" "$EXEC" "${flags[@]}"
else
    exec "$EXEC" "${flags[@]}"
fi
