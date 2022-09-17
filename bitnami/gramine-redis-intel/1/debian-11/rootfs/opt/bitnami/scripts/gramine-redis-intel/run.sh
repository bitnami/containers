#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Redis environment variables
. /opt/bitnami/scripts/gramine-redis-intel-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh
#. /opt/bitnami/scripts/libgramineredis.sh 

# Parse CLI flags to pass to the 'redis-server' call
args=("--daemonize" "no")
# Add flags specified via the 'REDIS_EXTRA_FLAGS' environment variable
read -r -a extra_flags <<< "$REDIS_EXTRA_FLAGS"
[[ "${#extra_flags[@]}" -gt 0 ]] && args+=("${extra_flags[@]}")
# Add flags passed to this script
args+=("$@")

info "** Starting Gramine Redis **"

info "Creating signing key"
if is_dir_empty  "$GRAMINE_KEY_DIR"; then
    info "Creating signing key"
    gramine-sgx-gen-private-key
fi

cd "$REDIS_BIN_DIR"

info "Creating Gramine manifest"
gramine-manifest -Dlog_level=error -Darch_libdir=/lib/x86_64-linux-gnu "${GRAMINE_MANIFESTS_DIR}/redis-server.manifest.template" > redis-server.manifest

info "Siging manifest"
gramine-sgx-sign --manifest redis-server.manifest --output redis-server.manifest.sgx

info "Generating token".
gramine-sgx-get-token --output redis-server.token --sig redis-server.sig

#FIXME
info "** Starting Gramine Redis **"
echo exec gramine-sgx redis-server "${args[@]}" --save '' --protected-mode no
exec gramine-sgx redis-server "${args[@]}" --save '' --protected-mode no
