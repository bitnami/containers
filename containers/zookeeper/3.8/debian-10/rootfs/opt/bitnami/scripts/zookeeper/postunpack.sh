#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libzookeeper.sh
. /opt/bitnami/scripts/libfs.sh

# Load ZooKeeper environment variables
. /opt/bitnami/scripts/zookeeper-env.sh

# Ensure directories used by ZooKeeper exist and have proper ownership and permissions
for dir in "$ZOO_DATA_DIR" "$ZOO_CONF_DIR" "$ZOO_LOG_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# Ensure a smooth transition to Bash logic in chart deployments
zookeeper_ensure_backwards_compatibility
