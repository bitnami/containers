#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libharbor.sh

# Load environment
. /opt/bitnami/scripts/harbor-registry-env.sh

# Auxiliar Functions

########################
# Validate Registry settings
# Arguments:
#   None
# Returns:
#   None
#########################
harbor_registry_validate() {
    info "Validating harbor-registry settings..."

    if [[ ! -f "/etc/registry/config.yml" ]]; then
        error "No configuration file was detected. Please mount your configuration file at \"/etc/registry/config.yml\""
        exit 1
    fi
}

# Ensure harbor-registry settings are valid
harbor_registry_validate
install_custom_certs
