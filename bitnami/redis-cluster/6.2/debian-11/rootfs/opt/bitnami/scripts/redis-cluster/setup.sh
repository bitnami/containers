#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Redis environment variables
. /opt/bitnami/scripts/redis-cluster-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/librediscluster.sh

# Ensure Redis environment variables settings are valid
redis_cluster_validate
# Ensure Redis is stopped when this script ends
trap "redis_stop" EXIT
am_i_root && ensure_user_exists "$REDIS_DAEMON_USER" --group "$REDIS_DAEMON_GROUP"

# Ensure Redis is initialized
redis_cluster_initialize

if is_boolean_yes "$REDIS_CLUSTER_DYNAMIC_IPS"; then
    redis_cluster_update_ips
fi
