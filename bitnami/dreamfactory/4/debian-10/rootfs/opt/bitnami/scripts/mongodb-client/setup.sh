#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libmongodbclient.sh

# Load MongoDB Client environment variables
. /opt/bitnami/scripts/mongodb-client-env.sh

# Ensure MongoDB Client environment variables settings are valid
mongodb_client_validate
# Ensure MongoDB Client is initialized
mongodb_client_initialize
