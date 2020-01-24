#!/bin/bash
#
# Bitnami Pgpool run

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# shellcheck disable=SC1091

# Load libraries
. /liblog.sh
. /libpgpool.sh

# Load Pgpool env. variables
eval "$(pgpool_env)"

readonly command=$(command -v pgpool)
flags=("-n" "--config-file=${PGPOOL_CONF_FILE}" "--hba-file=${PGPOOL_PGHBA_FILE}")
[[ -z "${PGPOOL_EXTRA_FLAGS:-}" ]] || flags=("${flags[@]}" "${PGPOOL_EXTRA_FLAGS[@]}")

is_boolean_yes "$PGPOOL_ENABLE_LDAP" && pgpool_start_nslcd_bg
info "** Starting Pgpool-II **"
if am_i_root; then
    exec gosu "$PGPOOL_DAEMON_USER" "${command}" "${flags[@]}"
else
    exec "${command}" "${flags[@]}"
fi
