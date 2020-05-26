#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libldapclient.sh
. /opt/bitnami/scripts/libmariadbgalera.sh

# Load MariaDB environment variables
eval "$(mysql_env)"
# Load LDAP environment variables
eval "$(ldap_env)"

flags=("--defaults-file=${DB_CONF_DIR}/my.cnf" "--basedir=$DB_BASE_DIR" "--datadir=$DB_DATA_DIR" "--socket=${DB_TMP_DIR}/mysql.sock" "--port=$DB_PORT_NUMBER")
[[ -z "${DB_EXTRA_FLAGS:-}" ]] || flags=("${flags[@]}" "${DB_EXTRA_FLAGS[@]}")

is_boolean_yes "$DB_ENABLE_LDAP" && ldap_start_nslcd_bg
info "** Starting MariaDB **"

set_previous_boot

if am_i_root; then
    exec gosu "$DB_DAEMON_USER" "${DB_SBIN_DIR}/mysqld" "${flags[@]}"
else
    exec "${DB_SBIN_DIR}/mysqld" "${flags[@]}"
fi
