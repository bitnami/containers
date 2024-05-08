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
. /opt/bitnami/scripts/libos.sh

# Load NATS environment
. /opt/bitnami/scripts/nats-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users 
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/nats/conf)
debug "Copying files from $NATS_DEFAULT_CONF_DIR to $NATS_CONF_DIR"
cp -nr "$NATS_DEFAULT_CONF_DIR"/. "$NATS_CONF_DIR"

if [[ "$*" = *"/opt/bitnami/scripts/nats/run.sh"* ]]; then
    info "** Starting NATS setup **"
    /opt/bitnami/scripts/nats/setup.sh
    info "** NATS setup finished! **"
fi

echo ""
exec "$@"
