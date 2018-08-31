#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

. /libos.sh
. /libfs.sh
. /libredis.sh

eval "$(redis_env)"

# ensure redis env var settings are valid
redis_validate

# ensure redis is stopped when this script ends.
trap "redis_stop" EXIT

if am_i_root; then
    ensure_user_exists "$REDIS_DAEMON_USER" "$REDIS_DAEMON_GROUP"
fi

# ensure redis is initialized
redis_initialize

