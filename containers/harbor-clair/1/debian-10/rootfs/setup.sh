#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /liblog.sh
. /libvalidations.sh

# Default PostgreSQL host and port values
postgresql_host="postgresql"
postgresql_port="5432"

# Auxiliar Functions
########################
# Validate Clair settings
# Arguments:
#   None
# Returns:
#   None
#########################
harbor_clair_validate() {
    info "Validating Harbor Clair settings..."

    if [[ ! -f "/etc/clair/config.yaml" ]]; then
        error "No configuration file was detected. Please mount your configuration file at \"/etc/clair/config.yaml\""
        exit 1
    fi

    string="$(grep -Po "source:.*" /etc/clair/config.yaml)"
    regex="source: .*\:\/\/(.*):(.*)@(.*):(.*)\/"
    if [[ $string =~ $regex ]]
    then
        postgresql_host="${BASH_REMATCH[3]}"
        postgresql_port="${BASH_REMATCH[4]}"
    else
        info "Unable to found PostgreSQL config at \"/etc/clair/config.yaml\", using default parameters"
    fi
}

########################
# Wait for PostgreSQL
# Arguments:
#   None
# Returns:
#   None
#########################
wait_for_postgresql() {
    info "Waiting for PostgreSQL to be available at ${postgresql_host}:${postgresql_port}..."
    wait-for-port --host "$postgresql_host" "$postgresql_port"
}

# Ensure Harbor Clair settings are valid
harbor_clair_validate
wait_for_postgresql
