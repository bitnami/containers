#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Pgpool entrypoint

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libpgpool.sh

# Load Pgpool env. variables
eval "$(pgpool_env)"

print_welcome_page

if ! is_dir_empty "$PGPOOL_DEFAULT_CONF_DIR"; then
    # We add the copy from default config in the entrypoint to not break users
    # bypassing the setup.sh logic. If the file already exists do not overwrite (in
    # case someone mounts a configuration file in /opt/bitnami/pgpool/conf)
    debug "Copying files from $PGPOOL_DEFAULT_CONF_DIR to $PGPOOL_CONF_DIR"
    cp -nr "$PGPOOL_DEFAULT_CONF_DIR"/. "$PGPOOL_CONF_DIR"
fi

if ! is_dir_empty "$PGPOOL_DEFAULT_ETC_DIR"; then
    # We add the copy from default config in the entrypoint to not break users
    # bypassing the setup.sh logic. If the file already exists do not overwrite (in
    # case someone mounts a configuration file in /opt/bitnami/pgpool/etc)
    debug "Copying files from $PGPOOL_DEFAULT_ETC_DIR to $PGPOOL_ETC_DIR"
    cp -nr "$PGPOOL_DEFAULT_ETC_DIR"/. "$PGPOOL_ETC_DIR"
fi

if [[ "$*" = *"/opt/bitnami/scripts/pgpool/run.sh"* ]]; then
    info "** Starting Pgpool-II setup **"
    /opt/bitnami/scripts/pgpool/setup.sh
    info "** Pgpool-II setup finished! **"
fi

echo ""
exec "$@"
