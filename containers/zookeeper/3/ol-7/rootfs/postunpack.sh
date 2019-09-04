#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /libzookeeper.sh
. /libfs.sh

# Load ZooKeeper environment variables
eval "$(zookeeper_env)"

# Ensure directories used by ZooKeeper exist and have proper ownership and permissions
for dir in "$ZOO_DATA_DIR" "$ZOO_CONF_DIR" "$ZOO_LOG_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# Ensure a smooth transition to Bash logic in chart deployments
zookeeper_ensure_backwards_compatibility
