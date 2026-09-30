#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh

# Load Gitea environment variables
. /opt/bitnami/scripts/gitea-env.sh

# System User
ensure_user_exists "$GITEA_DAEMON_USER" --group "$GITEA_DAEMON_GROUP" --system

# Create directories
dirs=(
    "${GITEA_WORK_DIR}"
    "${GITEA_CUSTOM_DIR}"
    "${GITEA_DATA_DIR}"
    "${GITEA_TMP_DIR}"
    "${GITEA_VOLUME_DIR}"
    "${GITEA_LOG_ROOT_PATH}"
)

for dir in "${dirs[@]}"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$GITEA_DAEMON_USER" -g "root"
done
chmod a+x "${GITEA_WORK_DIR}/bin/gitea"

render-template "$GITEA_CONF_DIR/app.ini.template" >"$GITEA_CONF_FILE"
configure_permissions_ownership "$GITEA_CONF_FILE" -f "664" -u "$GITEA_DAEMON_USER" -g "root"
