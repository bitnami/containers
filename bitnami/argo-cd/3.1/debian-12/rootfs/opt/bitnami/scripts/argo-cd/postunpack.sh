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

# Argo CD repo server requires the directory /app/config/gpg/source to exist
for dir in "/app/config/gpg/keys" "/app/config/gpg/source" "/bitnami/argocd" "/.argocd"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664" -g "root"
done

