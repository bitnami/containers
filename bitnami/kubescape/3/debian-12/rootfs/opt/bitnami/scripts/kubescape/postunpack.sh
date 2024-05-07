#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

. /opt/bitnami/scripts/libos.sh

# Load Kubescape environment variables
. /opt/bitnami/scripts/kubescape-env.sh

# Download Tanzu Application Catalog list, required for 'oss-assessment' custom action
curl --fail -sLo "${TANZU_APPLICATION_CATALOG_FILE}" "https://api.app-catalog.vmware.com/v1/applications?scope=COMMON&scope=ONLY_CUSTOMERS"

# Configuring permissions for tmp and logs folders
for dir in "$KUBESCAPE_CACHE_DIR" "$KUBESCAPE_ARTIFACTS_DIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -g "root" -d "775" -f "664"
done

# Download kubescape artifacts
# Also ensure permissions are properly configured
kubescape download artifacts
configure_permissions_ownership "$KUBESCAPE_ARTIFACTS_DIR" -g "root" -d "775" -f "664"
