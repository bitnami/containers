#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libredis.sh

# Load Redis environment variables
eval "$(redis_env)"

# Constants
REDIS_EXTRA_FLAGS=${REDIS_EXTRA_FLAGS:-}
EXEC=$(command -v redis-server)

args=("$REDIS_BASEDIR/etc/redis.conf" "--daemonize" "no" "$@")
# configure extra command line flags
if [[ -n "$REDIS_EXTRA_FLAGS" ]]; then
    warn "REDIS_EXTRA_FLAGS is deprecated. Please specify any extra-flag using '/run.sh $REDIS_EXTRA_FLAGS' as command instead"
    read -r -a envExtraFlags <<< "$REDIS_EXTRA_FLAGS"
    args+=("${envExtraFlags[@]}")
fi

info "** Starting Redis **"
if am_i_root; then
    exec gosu "$REDIS_DAEMON_USER" "$EXEC" "${args[@]}"
else
    exec "$EXEC" "${args[@]}"
fi
