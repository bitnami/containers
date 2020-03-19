#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libredissentinel.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

# Load Redis environment
eval "$(redis_env)"

EXEC=$(command -v redis-sentinel)
args=("$REDIS_SENTINEL_CONF_FILE" "--daemonize" "no" "$@")

info "** Starting redis sentinel **"
if am_i_root; then
    exec gosu "$REDIS_SENTINEL_DAEMON_USER" "$EXEC" "${args[@]}"
else
    exec "$EXEC" "${args[@]}"
fi
