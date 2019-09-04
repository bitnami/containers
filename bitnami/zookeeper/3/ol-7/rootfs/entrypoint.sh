#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /liblog.sh
. /libbitnami.sh
. /libzookeeper.sh

# Load ZooKeeper environment variables
eval "$(zookeeper_env)"

print_welcome_page

if [[ "$*" = "/run.sh" ]]; then
    info "** Starting ZooKeeper setup **"
    /setup.sh
    info "** ZooKeeper setup finished! **"
fi

echo ""
exec "$@"
