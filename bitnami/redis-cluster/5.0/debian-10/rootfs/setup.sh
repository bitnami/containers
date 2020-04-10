#!/bin/bash

# shellcheck disable=SC1091
# shellcheck disable=SC1090

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/librediscluster.sh

# Load Redis environment variables
eval "$(redis_cluster_env)"

# Ensure Redis environment variables settings are valid
redis_cluster_validate
# Ensure Redis is stopped when this script ends
trap "redis_stop" EXIT
am_i_root && ensure_user_exists "$REDIS_DAEMON_USER" "$REDIS_DAEMON_GROUP"

# Ensure Redis is initialized
redis_cluster_initialize

if ! is_boolean_yes "$REDIS_CLUSTER_CREATOR" && is_boolean_yes "$REDIS_CLUSTER_DYNAMIC_IPS"; then
  redis_cluster_update_ips
fi
