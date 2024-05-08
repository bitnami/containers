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
. /opt/bitnami/scripts/libmemcached.sh

# Load Memcached environment variables
. /opt/bitnami/scripts/memcached-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users 
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/memcached/conf)
debug "Copying files from $MEMCACHED_DEFAULT_CONF_DIR to $MEMCACHED_CONF_DIR"
cp -nfr "$MEMCACHED_DEFAULT_CONF_DIR"/. "$MEMCACHED_CONF_DIR"

if [[ "$*" = *"/opt/bitnami/scripts/memcached/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting Memcached setup **"
    /opt/bitnami/scripts/memcached/setup.sh
    info "** Memcached setup finished! **"
fi

echo ""
exec "$@"
