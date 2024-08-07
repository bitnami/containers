#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Neo4j environment
. /opt/bitnami/scripts/neo4j-env.sh

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/neo4j/config)
debug "Copying files from $NEO4J_DEFAULT_CONF_DIR to $NEO4J_CONF_DIR"
cp -nr "$NEO4J_DEFAULT_CONF_DIR"/. "$NEO4J_CONF_DIR"

if [[ "$1" = "/opt/bitnami/scripts/neo4j/run.sh" ]]; then
    /opt/bitnami/scripts/neo4j/setup.sh
    info "** Neo4j setup finished! **"
fi

echo ""
exec "$@"
