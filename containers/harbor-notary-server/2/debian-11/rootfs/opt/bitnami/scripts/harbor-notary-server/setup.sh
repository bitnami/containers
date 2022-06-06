#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libvalidations.sh

# Auxiliar Functions

########################
# Validate Notary Server settings
# Arguments:
#   None
# Returns:
#   None
#########################
harbor_notary_server_validate() {
    info "Validating Harbor Notary Server settings..."

    if [[ ! -f "/etc/notary/server-config.postgres.json" ]]; then
        error "No configuration file was detected. Please mount your configuration file at \"/etc/notary/server-config.postgres.json\""
        exit 1
    fi
}

# Ensure Harbor Notary Server settings are valid
harbor_notary_server_validate
