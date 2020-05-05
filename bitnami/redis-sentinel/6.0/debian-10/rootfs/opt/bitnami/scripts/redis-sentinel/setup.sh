#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libredissentinel.sh
. /opt/bitnami/scripts/libos.sh

# Load Apache environment
eval "$(redis_env)"

# Create daemon user if needed
am_i_root && ensure_user_exists "$REDIS_SENTINEL_DAEMON_USER" "$REDIS_SENTINEL_DAEMON_GROUP"

# Ensure redis environment variables are valid
redis_validate

# Initialize redis sentinel
redis_initialize
