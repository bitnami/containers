#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /libzookeeper.sh
. /libos.sh
. /liblog.sh

# Load ZooKeeper environment variables
eval "$(zookeeper_env)"

START_COMMAND=("${ZOO_BASE_DIR}/bin/zkServer.sh" "start-foreground")

info "** Starting ZooKeeper **"
if am_i_root; then
    exec gosu "$ZOO_DAEMON_USER" "${START_COMMAND[@]}"
else
    exec "${START_COMMAND[@]}"
fi
