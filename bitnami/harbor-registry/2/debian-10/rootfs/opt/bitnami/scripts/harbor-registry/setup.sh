#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libharbor.sh

# Auxiliar Functions

########################
# Validate Registry settings
# Arguments:
#   None
# Returns:
#   None
#########################
harbor_registry_validate() {
    info "Validating Harbor Registry settings..."

    if [[ ! -f "/etc/registry/config.yml" ]]; then
        error "No configuration file was detected. Please mount your configuration file at \"/etc/registry/config.yml\""
        exit 1
    fi
}

# Ensure Harbor Registry settings are valid
harbor_registry_validate
install_custom_certs
