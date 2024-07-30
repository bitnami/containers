#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Odoo environment
. /opt/bitnami/scripts/odoo-env.sh

# Load libraries
. /opt/bitnami/scripts/libodoo.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh

# The 'odoo-bin' tool is really the same as 'odoo', but due to the way it was installed, it appears in the latter form
# Official Odoo docs refer to 'odoo-bin' so we add a symlink for users to be able to use any form
ln -sf "${ODOO_BIN_DIR}/odoo" "${ODOO_BIN_DIR}/odoo-bin"

# Ensure the Odoo base directory exists and has proper permissions
info "Configuring file permissions for Odoo"
ensure_user_exists "$ODOO_DAEMON_USER" --group "$ODOO_DAEMON_GROUP" --system
for dir in "$ODOO_ADDONS_DIR" "$ODOO_CONF_DIR" "$ODOO_DATA_DIR" "$ODOO_LOGS_DIR" "$ODOO_TMP_DIR" "$ODOO_VOLUME_DIR"; do
    ensure_dir_exists "$dir"
    # Use daemon:root ownership for compatibility when running as a non-root user
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$ODOO_DAEMON_USER" -g "root"
done

# Use daemon user ownership for compatibility when running as a non-root user
chown "$ODOO_DAEMON_USER" "$ODOO_BASE_DIR"

# Create folders that existed in previous versions of this image with proper permissions/ownership
# TODO: Remove this block in a future release
ensure_dir_exists "${ODOO_BASE_DIR}/odoo"
ln -s "$ODOO_BASE_DIR"/lib/odoo-*.egg/odoo/addons "${ODOO_BASE_DIR}/odoo/addons"
# Intentionally avoid symlink since it would point to the parent folder, with potential to cause problems
ensure_dir_exists "${ODOO_TMP_DIR}/pids"
configure_permissions_ownership "${ODOO_TMP_DIR}/pids" -d "775" -f "664" -u "$ODOO_DAEMON_USER" -g "root"
