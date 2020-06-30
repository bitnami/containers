#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libejbca.sh

# Load ejbca environment variables
. /opt/bitnami/scripts/ejbca-env.sh

# Ensure ejbca environment variables are valid
ejbca_validate

# Ensure ejbca is initialized
ejbca_initialize
