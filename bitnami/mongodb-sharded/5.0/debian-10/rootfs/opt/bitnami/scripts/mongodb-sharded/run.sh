#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

. /opt/bitnami/scripts/libmongodb.sh
. /opt/bitnami/scripts/libmongodb-sharded.sh
. /opt/bitnami/scripts/libos.sh

# Load MongoDB env. variables
. /opt/bitnami/scripts/mongodb-env.sh

if [[ "$MONGODB_SHARDING_MODE" = "mongos" ]]; then
    cmd=$(command -v mongos)
    flags=("--config=$MONGODB_MONGOS_CONF_FILE")
else
    cmd=$(command -v mongod)
    flags=("--config=$MONGODB_CONF_FILE")
fi


if [[ -n "${MONGODB_EXTRA_FLAGS:-}" ]]; then
    read -r -a extra_flags <<< "$MONGODB_EXTRA_FLAGS"
    flags+=("${extra_flags[@]}")
fi

info "** Starting MongoDB **"
if am_i_root; then
    exec gosu "$MONGODB_DAEMON_USER" "$cmd" "${flags[@]}"
else
    exec "$cmd" "${flags[@]}"
fi
