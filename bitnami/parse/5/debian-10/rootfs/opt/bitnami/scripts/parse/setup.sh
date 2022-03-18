#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load Parse environment
. /opt/bitnami/scripts/parse-env.sh

# Load MongoDB&reg; Client environment for 'mongodb_remote_execute' (after 'parse-env.sh' so that MODULE is not set to a wrong value)
if [[ -f /opt/bitnami/scripts/mongodb-client-env.sh ]]; then
    . /opt/bitnami/scripts/mongodb-client-env.sh
elif [[ -f /opt/bitnami/scripts/mongodb-env.sh ]]; then
    . /opt/bitnami/scripts/mongodb-env.sh
fi

# Load libraries
. /opt/bitnami/scripts/libparse.sh

# Ensure Parse environment variables are valid
parse_validate

# Ensure Parse is initialized
parse_initialize
