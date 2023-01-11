#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libpostgresql.sh
. /opt/bitnami/scripts/librepmgr.sh

# Load PostgreSQL & repmgr environment variables
. /opt/bitnami/scripts/postgresql-env.sh

readonly repmgr_flags=("-f" "$REPMGR_CONF_FILE" "--daemonize=false")
# shellcheck disable=SC2155
readonly repmgr_cmd=$(command -v repmgrd)

postgresql_start_bg true
info "** Starting repmgrd **"
# TODO: properly test running the container as root
if am_i_root; then
    exec gosu "$POSTGRESQL_DAEMON_USER" "$repmgr_cmd" "${repmgr_flags[@]}"
else
    exec "$repmgr_cmd" "${repmgr_flags[@]}"
fi
