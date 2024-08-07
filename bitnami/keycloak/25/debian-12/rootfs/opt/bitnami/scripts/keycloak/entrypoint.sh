#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libkeycloak.sh

# Load keycloak environment variables
. /opt/bitnami/scripts/keycloak-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/postgresql/conf)
debug "Copying files from $KEYCLOAK_DEFAULT_CONF_DIR to $KEYCLOAK_CONF_DIR"
cp -nr "$KEYCLOAK_DEFAULT_CONF_DIR"/. "$KEYCLOAK_CONF_DIR"

if [[ "$*" = *"/opt/bitnami/scripts/keycloak/run.sh"* ]]; then
    info "** Starting keycloak setup **"
    /opt/bitnami/scripts/keycloak/setup.sh
    info "** keycloak setup finished! **"
fi

echo ""
exec "$@"
