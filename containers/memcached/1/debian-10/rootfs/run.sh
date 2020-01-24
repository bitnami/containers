#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /liblog.sh
. /libos.sh
. /libmemcached.sh

# Load Memcached environment variables
eval "$(memcached_env)"

# Constants
EXEC=$(command -v memcached)

# Configure arguments with extra flags
args=("-u ${MEMCACHED_DAEMON_USER}" "-p ${MEMCACHED_PORT_NUMBER}" "-m ${MEMCACHED_CACHE_SIZE}" "$(memcached_debug_flags)")
if [[ -f "${SASL_DB_FILE}" ]]; then
    args+=("-S")
fi
args+=("$@")

info "** Starting Memcached **"
if am_i_root; then
    exec gosu "${MEMCACHED_DAEMON_USER}" "${EXEC}" "${args[@]}"
else
    exec "${EXEC}" "${args[@]}"
fi
