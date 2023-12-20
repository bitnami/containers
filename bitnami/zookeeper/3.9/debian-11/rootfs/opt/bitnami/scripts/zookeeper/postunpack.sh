#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libzookeeper.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libmaven.sh

# Load ZooKeeper environment variables
. /opt/bitnami/scripts/zookeeper-env.sh

# Ensure directories used by ZooKeeper exist and have proper ownership and permissions
for dir in "$ZOO_DATA_DIR" "$ZOO_CONF_DIR" "$ZOO_LOG_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# Add maven artifacts needed for JSON logging and logback configuration
maven_get_jar co.elastic.logging:ecs-logging-core:1.5.0 "$ZOO_LIB_DIR"
maven_get_jar co.elastic.logging:logback-ecs-encoder:1.5.0 "$ZOO_LIB_DIR"
maven_get_jar org.codehaus.janino:janino:3.1.10 "$ZOO_LIB_DIR"
maven_get_jar org.codehaus.janino:commons-compiler:3.1.10 "$ZOO_LIB_DIR"

# Ensure a smooth transition to Bash logic in chart deployments
zookeeper_ensure_backwards_compatibility
