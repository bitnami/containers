#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Valkey environment variables
. /opt/bitnami/scripts/valkey-env.sh

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libvalkey.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users 
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/valkey/etc)
debug "Copying files from $VALKEY_DEFAULT_CONF_DIR to $VALKEY_CONF_DIR"
cp -nr "$VALKEY_DEFAULT_CONF_DIR"/. "$VALKEY_CONF_DIR"

if [[ "$*" = *"/opt/bitnami/scripts/valkey/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting Valkey setup **"
    /opt/bitnami/scripts/valkey/setup.sh
    info "** Valkey setup finished! **"
fi

echo ""
exec "$@"
