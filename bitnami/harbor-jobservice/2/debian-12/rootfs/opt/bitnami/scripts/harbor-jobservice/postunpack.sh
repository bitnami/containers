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
. /opt/bitnami/scripts/harbor-jobservice-env.sh

ensure_user_exists "$HARBOR_JOBSERVICE_DAEMON_USER" --group "$HARBOR_JOBSERVICE_DAEMON_GROUP"

# Ensure a set of directories exist and the non-root user has write privileges to them
# Give execution permissions to /var/log to ensure harbor can access the child folder
chmod +x /var/log
read -r -a directories <<<"$(get_system_cert_paths)"
directories+=("/var/log/jobs")
for dir in "${directories[@]}"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
    chown -R "$HARBOR_JOBSERVICE_DAEMON_USER" "$dir"
done

ensure_dir_exists "/etc/jobservice"

# Ensure permissions for Internal TLS
configure_permissions_system_certs
