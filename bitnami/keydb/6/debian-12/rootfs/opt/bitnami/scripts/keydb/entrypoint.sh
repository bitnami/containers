#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load KeyDB environment variables
. /opt/bitnami/scripts/keydb-env.sh

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libkeydb.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users 
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/keydb/etc)
debug "Copying files from $KEYDB_DEFAULT_CONF_DIR to $KEYDB_CONF_DIR"
cp -nr "$KEYDB_DEFAULT_CONF_DIR"/. "$KEYDB_CONF_DIR"

if [[ "$*" = *"/opt/bitnami/scripts/keydb/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting KeyDB setup **"
    /opt/bitnami/scripts/keydb/setup.sh
    info "** KeyDB setup finished! **"
fi

echo ""
exec "$@"
