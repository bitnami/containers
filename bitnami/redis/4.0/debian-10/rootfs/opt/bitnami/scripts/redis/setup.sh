#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libredis.sh

# Load Redis environment variables
eval "$(redis_env)"

# Ensure Redis environment variables settings are valid
redis_validate
# Ensure Redis is stopped when this script ends
trap "redis_stop" EXIT
am_i_root && ensure_user_exists "$REDIS_DAEMON_USER" "$REDIS_DAEMON_GROUP"
# Ensure Redis is initialized
redis_initialize
