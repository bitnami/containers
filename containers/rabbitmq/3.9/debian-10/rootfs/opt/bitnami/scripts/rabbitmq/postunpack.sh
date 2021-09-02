#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/librabbitmq.sh

# Load RabbitMQ environment variables
. /opt/bitnami/scripts/rabbitmq-env.sh

for dir in "$RABBITMQ_BIN_DIR" "$RABBITMQ_CONF_DIR" "$RABBITMQ_DATA_DIR" "$RABBITMQ_HOME_DIR" "$RABBITMQ_LIB_DIR" "$RABBITMQ_LOG_DIR" "$RABBITMQ_PLUGINS_DIR"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$RABBITMQ_BIN_DIR" "$RABBITMQ_CONF_DIR" "$RABBITMQ_DATA_DIR" "$RABBITMQ_HOME_DIR" "$RABBITMQ_LIB_DIR" "$RABBITMQ_LOG_DIR" "$RABBITMQ_PLUGINS_DIR"

# Adding symlinks to upstream RabbitMQ paths to make the container compatible with the RabbitMQ Cluster Operator

symlinks=(
    "/etc/rabbitmq=${RABBITMQ_CONF_DIR}"
    "/var/lib/rabbitmq=${RABBITMQ_HOME_DIR}"
    "/var/lib/rabbitmq/mnesia=${RABBITMQ_DATA_DIR}"
    "/var/log/rabbitmq=${RABBITMQ_LOG_DIR}"
)

for entry in "${symlinks[@]}"; do
    link="${entry%=*}"
    file="${entry#*=}"
    ln -s "$file" "$link"
done
