#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libwebserver.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libappsmith.sh

# Load Appsmith environment variables
. /opt/bitnami/scripts/appsmith-env.sh

# Load web server environment
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

# System User
ensure_user_exists "$APPSMITH_DAEMON_USER" --group "$APPSMITH_DAEMON_GROUP" --system

for dir in "${APPSMITH_CONF_DIR}" "${APPSMITH_DEFAULT_CONF_DIR}" "${APPSMITH_LOG_DIR}" "${APPSMITH_TMP_DIR}" "${APPSMITH_VOLUME_DIR}"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664" -u "$APPSMITH_DAEMON_USER" -g "root"
done

# Generate default configuration file
# https://github.com/appsmithorg/appsmith/blob/release/deploy/docker/templates/docker.env.sh#L14
bash "${APPSMITH_BASE_DIR}/templates/docker.env.sh" "" "" "" "" "" >"${APPSMITH_CONF_FILE}"
chmod -R g+rwX "${APPSMITH_CONF_FILE}"

# Add symlinks to the default paths to make a similar UX as the upstream Appsmith container
# https://github.com/appsmithorg/appsmith/blob/release/Dockerfile#L6
ln -s "${APPSMITH_BASE_DIR}" "/opt/appsmith"

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "$APPSMITH_CONF_DIR"/* "$APPSMITH_DEFAULT_CONF_DIR"
