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
. /opt/bitnami/scripts/libnginx.sh

# Load NGINX environment variables
. /opt/bitnami/scripts/nginx-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/nginx/conf)
debug "Copying files from $NGINX_DEFAULT_CONF_DIR to $NGINX_CONF_DIR"
cp -nr "$NGINX_DEFAULT_CONF_DIR"/. "$NGINX_CONF_DIR" || true


if [[ "$1" = "/opt/bitnami/scripts/nginx/run.sh" ]]; then
    info "** Starting NGINX setup **"
    /opt/bitnami/scripts/nginx/setup.sh
    info "** NGINX setup finished! **"
fi

echo ""
exec "$@"
