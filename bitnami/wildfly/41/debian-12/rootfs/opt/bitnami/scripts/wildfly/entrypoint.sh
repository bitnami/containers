#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load WildFly environment
. /opt/bitnami/scripts/wildfly-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in opt/bitnami/wildfly/standalone)
debug "Copying files from $WILDFLY_DEFAULT_STANDALONE_DIR to $WILDFLY_STANDALONE_DIR"
cp -nr "$WILDFLY_DEFAULT_STANDALONE_DIR"/. "$WILDFLY_STANDALONE_DIR" || true
debug "Copying files from $WILDFLY_DEFAULT_DOMAIN_DIR to $WILDFLY_DOMAIN_DIR"
cp -nr "$WILDFLY_DEFAULT_DOMAIN_DIR"/. "$WILDFLY_DOMAIN_DIR" || true

if [[ "$1" = "/opt/bitnami/scripts/wildfly/run.sh" ]]; then
    info "** Starting WildFly setup **"
    /opt/bitnami/scripts/wildfly/setup.sh
    info "** WildFly setup finished! **"
fi

echo ""
exec "$@"
