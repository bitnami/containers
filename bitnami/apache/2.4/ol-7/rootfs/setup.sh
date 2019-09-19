#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /libapache.sh

# Load Apache environment
eval "$(apache_env)"

# Ensure apache environment variables are valid
apache_validate

# Ensure apache is initialized
apache_initialize
