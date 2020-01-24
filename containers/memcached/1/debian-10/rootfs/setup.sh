#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /libfs.sh
. /libos.sh
. /libmemcached.sh

# Load Memcached environment variables
eval "$(memcached_env)"

# Ensure Memcached environment variables are valid
memcached_validate

# Ensure Memcached is initialized
memcached_initialize
