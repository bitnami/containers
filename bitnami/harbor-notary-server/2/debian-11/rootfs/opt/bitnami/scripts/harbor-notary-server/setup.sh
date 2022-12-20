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
. /opt/bitnami/scripts/harbor-notary-server-env.sh

# Auxiliar Functions

########################
# Validate Notary Server settings
# Arguments:
#   None
# Returns:
#   None
#########################
harbor_notary_server_validate() {
    info "Validating harbor-notary-server settings..."

    if [[ ! -f "/etc/notary/server-config.postgres.json" ]]; then
        error "No configuration file was detected. Please mount your configuration file at \"/etc/notary/server-config.postgres.json\""
        exit 1
    fi
}

# Ensure harbor-notary-server settings are valid
harbor_notary_server_validate
