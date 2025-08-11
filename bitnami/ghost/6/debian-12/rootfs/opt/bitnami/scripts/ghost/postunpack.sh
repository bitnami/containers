#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Ghost environment
. /opt/bitnami/scripts/ghost-env.sh

# Load libraries
. /opt/bitnami/scripts/libghost.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh

# Ensure the Ghost base directory exists and has proper permissions
info "Configuring file permissions for Ghost"
# Ghost CLI creates a configuration file in the system user home directory: /home/ghost/.ghost/config
ensure_user_exists "$GHOST_DAEMON_USER" --group "$GHOST_DAEMON_GROUP" --system --home "/home/$GHOST_DAEMON_USER"

declare -a writable_dirs=(
    # Skipping GHOST_BASE_DIR intentionally because it contains a lot of files/folders that should not be writable
    "$GHOST_VOLUME_DIR"
    # Folders to persist
    "${GHOST_BASE_DIR}/content"
    # Folders that need to be writable for the app to work
    "/.ghost"
    "${GHOST_BASE_DIR}/content/logs"
)

for dir in "${writable_dirs[@]}"; do
    ensure_dir_exists "$dir"
    # Use ghost:root ownership for compatibility when running as a non-root user
    # Due to a limitation in "ghost start" and "ghost doctor" commands which doesn't check
    # if the user has writing permissions properly, we need to set 777/666 permissions which
    # is clearly a limitation in terms of security
    configure_permissions_ownership "$dir" -d "777" -f "666" -u "$GHOST_DAEMON_USER" -g "root"
done
# Provide write permissions in installation directory (without doing it recursively)
chmod a+rwX "$GHOST_BASE_DIR" "${GHOST_BASE_DIR}/.ghost-cli" && chown "${GHOST_DAEMON_USER}:root" "$GHOST_BASE_DIR" "${GHOST_BASE_DIR}/.ghost-cli"
