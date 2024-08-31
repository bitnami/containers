#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libschemaregistry.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load Schema Registry environment variables
. /opt/bitnami/scripts/schema-registry-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users 
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/schema-registry/etc)
debug "Copying files from $SCHEMA_REGISTRY_DEFAULT_CONF_DIR to $SCHEMA_REGISTRY_CONF_DIR"
cp -nr "$SCHEMA_REGISTRY_DEFAULT_CONF_DIR"/. "$SCHEMA_REGISTRY_CONF_DIR"

if [[ "$1" = "/opt/bitnami/scripts/schema-registry/run.sh" ]]; then
    info "** Starting Schema Registry setup **"
    /opt/bitnami/scripts/schema-registry/setup.sh
    info "** Schema Registry setup finished! **"
fi

echo ""
exec "$@"
