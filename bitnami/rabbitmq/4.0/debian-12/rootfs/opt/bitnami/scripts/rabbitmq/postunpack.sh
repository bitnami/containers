#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/librabbitmq.sh

# Load RabbitMQ environment variables
. /opt/bitnami/scripts/rabbitmq-env.sh

for dir in "$RABBITMQ_BIN_DIR" "$RABBITMQ_INITSCRIPTS_DIR" "$RABBITMQ_CONF_DIR" "$RABBITMQ_DEFAULT_CONF_DIR" "$RABBITMQ_DATA_DIR" "$RABBITMQ_HOME_DIR" "$RABBITMQ_LIB_DIR" "$RABBITMQ_LOGS_DIR" "$RABBITMQ_PLUGINS_DIR"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$RABBITMQ_INITSCRIPTS_DIR" "$RABBITMQ_BIN_DIR" "$RABBITMQ_CONF_DIR" "$RABBITMQ_DATA_DIR" "$RABBITMQ_HOME_DIR" "$RABBITMQ_LIB_DIR" "$RABBITMQ_LOGS_DIR" "$RABBITMQ_PLUGINS_DIR"

# Adding symlinks to upstream RabbitMQ paths to make the container compatible with the RabbitMQ Cluster Operator

symlinks=(
    "/etc/rabbitmq=${RABBITMQ_CONF_DIR}"
    "/var/lib/rabbitmq=${RABBITMQ_HOME_DIR}"
    "/var/log/rabbitmq=${RABBITMQ_LOGS_DIR}"
)

for entry in "${symlinks[@]}"; do
    link="${entry%=*}"
    file="${entry#*=}"
    ln -s "$file" "$link"
done

# Additionally, ensure that the /var/log is accessible, which may have been hardened
chmod g+x /var/log

# Special case for RabbitMQ mnesia dir, which will have a different symbolic linking to ensure compatibility with
# the RabbitMQ Cluster Operator

mkdir -p "/var/lib/rabbitmq/mnesia"
chmod -R g+rwX "/var/lib/rabbitmq/mnesia"
rm -rf "$RABBITMQ_DATA_DIR"
ln -s "/var/lib/rabbitmq/mnesia" "$RABBITMQ_DATA_DIR"

if ! is_dir_empty "$RABBITMQ_CONF_DIR"; then
    # Copy all initially generated configuration files to the default directory
    # (this is to avoid breaking when entrypoint is being overridden)
    cp -r "${RABBITMQ_CONF_DIR}/"* "$RABBITMQ_DEFAULT_CONF_DIR"
fi