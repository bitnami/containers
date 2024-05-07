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
. /opt/bitnami/scripts/libkong.sh

. /opt/bitnami/scripts/kong-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users 
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/kong/conf)
debug "Copying files from $KONG_DEFAULT_CONF_DIR to $KONG_CONF_DIR"
cp -nr "$KONG_DEFAULT_CONF_DIR"/. "$KONG_CONF_DIR"

if ! is_dir_empty "$KONG_DEFAULT_SERVER_DIR"; then
    cp -nr "$KONG_DEFAULT_SERVER_DIR"/. "$KONG_SERVER_DIR"
fi
if [[ "$*" = *"/opt/bitnami/scripts/kong/run.sh"* ]]; then
    info "** Starting Kong setup **"
    /opt/bitnami/scripts/kong/setup.sh
    info "** Kong setup finished! **"
fi

echo ""
exec "$@"
