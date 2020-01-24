#!/bin/bash
# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

. /libmongodb.sh
. /libmongodb-sharded.sh
. /libos.sh

# Load MongoDB env. variables
eval "$(mongodb_env)"
eval "$(mongodb_sharded_env)"

if [[ "$MONGODB_SHARDING_MODE" = "mongos" ]]; then
    cmd=$(command -v mongos)
else
    cmd=$(command -v mongod)
fi

flags=("--config=$MONGODB_CONF_FILE")

if [[ -n "${MONGODB_EXTRA_FLAGS:-}" ]]; then
    read -r -a extra_flags <<< "$MONGODB_EXTRA_FLAGS"
    flags+=("${extra_flags[@]}")
fi

info "** Starting MongoDB **"
if am_i_root; then
    exec gosu "$MONGODB_DAEMON_USER" "${cmd}" "${flags[@]}"
else
    exec "${cmd}" "${flags[@]}"
fi
