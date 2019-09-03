#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /libzookeeper.sh
. /libfs.sh

# Load ZooKeeper environment variables
eval "$(zookeeper_env)"

# Ensure directories used by ZooKeeper exist and have proper ownership and permissions
for dir in "$ZOO_DATADIR" "$ZOO_CONFDIR" "$ZOO_LOG_DIR"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$ZOO_DATADIR" "$ZOO_CONFDIR" "$ZOO_LOG_DIR"
