#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/librails.sh

# Load Rails environment
eval "$(rails_env)"

# Ensure environment variables for the Rails app are valid
rails_validate

# Ensure Rails app is initialized
rails_initialize
