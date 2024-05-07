#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libharbor.sh

# Load environment
. /opt/bitnami/scripts/harbor-core-env.sh

ensure_user_exists "$HARBOR_CORE_DAEMON_USER" --group "$HARBOR_CORE_DAEMON_GROUP"

# Ensure a set of directories exist and the non-root user has write privileges to them
read -r -a directories <<<"$(get_system_cert_paths)"
directories+=("/etc/core" "${HARBOR_CORE_VOLUME_DIR}/certificates" "${HARBOR_CORE_VOLUME_DIR}/ca_download" "${HARBOR_CORE_VOLUME_DIR}/psc")
for dir in "/etc/core" "/data"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
    chown -R "$HARBOR_CORE_DAEMON_USER" "$dir"
done

# Ensure permissions for Internal TLS
configure_permissions_system_certs

# Add persisted configuration
ln -sf "${HARBOR_CORE_VOLUME_DIR}/certificates" /etc/core/certificates
ln -sf "${HARBOR_CORE_VOLUME_DIR}/ca_download" /etc/core/ca_download
ln -sf "${HARBOR_CORE_VOLUME_DIR}/psc" /etc/core/token
