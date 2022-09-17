#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Redis environment variables
. /opt/bitnami/scripts/redis-cluster-env.sh

# Load libraries
. /opt/bitnami/scripts/librediscluster.sh
. /opt/bitnami/scripts/libfs.sh

for dir in "$REDIS_VOLUME_DIR" "$REDIS_DATA_DIR" "$REDIS_BASE_DIR" "$REDIS_CONF_DIR"; do
    ensure_dir_exists "$dir"
done

cp "${REDIS_BASE_DIR}/etc/redis-default.conf" "$REDIS_CONF_FILE"

info "Setting Redis config file..."
redis_conf_set port "$REDIS_DEFAULT_PORT_NUMBER"
redis_conf_set dir "$REDIS_DATA_DIR"
redis_conf_set pidfile "$REDIS_PID_FILE"
redis_conf_set daemonize no
redis_conf_set cluster-enabled yes
redis_conf_set cluster-config-file "${REDIS_DATA_DIR}/nodes.conf"

chmod -R g+rwX  "$REDIS_BASE_DIR" /bitnami/redis
