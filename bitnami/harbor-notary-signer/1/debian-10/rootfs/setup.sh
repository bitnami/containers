#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /liblog.sh
. /libvalidations.sh

# Auxiliar Functions

########################
# Validate Notary Signer settings
# Arguments:
#   None
# Returns:
#   None
#########################
harbor_notary_signer_validate() {
    info "Validating Harbor Notary Signer settings..."

    if [[ ! -f "/etc/notary/signer-config.postgres.json" ]]; then
        error "No configuration file was detected. Please mount your configuration file at \"/etc/notary/signer-config.postgres.json\""
        exit 1
    fi
}

# Ensure Harbor Notary Signer settings are valid
harbor_notary_signer_validate
