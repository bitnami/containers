#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# shellcheck disable=SC1091

. /libmongodb.sh
. /libos.sh

# Load MongoDB env. variables
eval "$(mongodb_env)"

flags=("--config=$MONGODB_CONFIG_FILE")
[[ -z "${MONGODB_EXTRA_FLAGS:-}" ]] || flags=("${flags[@]}" "${MONGODB_EXTRA_FLAGS[@]}")

info "** Starting MongoDB **"
if am_i_root; then
    exec gosu "$MONGODB_DAEMON_USER" "${MONGODB_BIN_DIR}/mongod" "${flags[@]}"
else
    exec "${MONGODB_BIN_DIR}/mongod" "${flags[@]}"
fi
