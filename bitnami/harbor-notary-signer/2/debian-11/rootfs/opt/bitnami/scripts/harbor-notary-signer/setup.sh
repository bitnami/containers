#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libharbor.sh

# Load environment
. /opt/bitnami/scripts/harbor-notary-signer-env.sh

# Auxiliar Functions

########################
# Validate Notary Signer settings
# Arguments:
#   None
# Returns:
#   None
#########################
harbor_notary_signer_validate() {
    info "Validating harbor-notary-signer settings..."

    if [[ ! -f "/etc/notary/signer-config.postgres.json" ]]; then
        error "No configuration file was detected. Please mount your configuration file at \"/etc/notary/signer-config.postgres.json\""
        exit 1
    fi
}

# Ensure harbor-notary-signer settings are valid
harbor_notary_signer_validate
