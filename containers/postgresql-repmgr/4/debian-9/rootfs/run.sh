#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose
# shellcheck disable=SC1091

# Load libraries
. /liblog.sh
. /libpostgresql.sh
. /librepmgr.sh

# Load PostgreSQL & repmgr environment variables
eval "$(repmgr_env)"
eval "$(postgresql_env)"

readonly repmgr_flags=("--pid-file=$REPMGR_PID_FILE" "-f" "$REPMGR_CONF_FILE")
readonly repmgr_cmd=$(command -v repmgrd)

postgresql_start_bg
info "** Starting repmgrd **"
# TODO: properly test running the container as root
if am_i_root; then
    exec gosu "$POSTGRESQL_DAEMON_USER" "${repmgr_cmd}" "${repmgr_flags[@]}"
else
    exec "${repmgr_cmd}" "${repmgr_flags[@]}"
fi
