#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091,SC1090

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Superset environment variables
. /opt/bitnami/scripts/superset-env.sh

# Load libraries
. /opt/bitnami/scripts/libsuperset.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh

# Copy superset configuration file
cp "${BITNAMI_ROOT_DIR}/scripts/superset/files/superset_config.py" "${SUPERSET_BASE_DIR}/superset_config.py"

ensure_dir_exists "$SUPERSET_BASE_DIR"
# Ensure the needed directories exist with write permissions
for dir in "$SUPERSET_TMP_DIR" "$SUPERSET_LOGS_DIR" "$SUPERSET_HOME"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664" -g "root"
done

chmod -R g+rwX "$SUPERSET_BASE_DIR"
