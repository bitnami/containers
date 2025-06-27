#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libzookeeper.sh

# Load ZooKeeper environment variables
. /opt/bitnami/scripts/zookeeper-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users 
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/zookeeper/conf)
debug "Copying files from $ZOO_DEFAULT_CONF_DIR to $ZOO_CONF_DIR"
cp -nr "$ZOO_DEFAULT_CONF_DIR"/. "$ZOO_CONF_DIR"

if [[ "$*" = *"/opt/bitnami/scripts/zookeeper/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting ZooKeeper setup **"
    /opt/bitnami/scripts/zookeeper/setup.sh
    info "** ZooKeeper setup finished! **"
fi

echo ""
exec "$@"
