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

if [[ "$1" = "/opt/bitnami/scripts/neo4j/run.sh" ]]; then
    /opt/bitnami/scripts/neo4j/setup.sh
    info "** Neo4j setup finished! **"
fi

echo ""
exec "$@"
