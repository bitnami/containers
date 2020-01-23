#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /libfs.sh
. /librabbitmq.sh

# Load RabbitMQ environment variables
eval "$(rabbitmq_env)"

for dir in "$RABBITMQ_BIN_DIR" "$RABBITMQ_CONF_DIR" "$RABBITMQ_DATA_DIR" "$RABBITMQ_HOME_DIR" "$RABBITMQ_LIB_DIR" "$RABBITMQ_LOG_DIR" "$RABBITMQ_PLUGINS_DIR"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$RABBITMQ_BIN_DIR" "$RABBITMQ_CONF_DIR" "$RABBITMQ_DATA_DIR" "$RABBITMQ_HOME_DIR" "$RABBITMQ_LIB_DIR" "$RABBITMQ_LOG_DIR" "$RABBITMQ_PLUGINS_DIR"

