#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libnats.sh
. /opt/bitnami/scripts/liblog.sh

# Load NATS environment
. /opt/bitnami/scripts/nats-env.sh

declare nats_cmd="nats-server"
which "$nats_cmd" >/dev/null 2>&1 || nats_cmd="gnatsd"
declare -a args=("-c" "$NATS_CONF_FILE")
args+=("$@")

info "** Starting NATS **"
if am_i_root; then
    gosu "$NATS_DAEMON_USER" "$nats_cmd" "${args[@]}"
else
    "$nats_cmd" "${args[@]}"
fi
