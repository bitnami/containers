#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/librabbitmq.sh
. /opt/bitnami/scripts/liblog.sh

# Load RabbitMQ environment variables
. /opt/bitnami/scripts/rabbitmq-env.sh

print_welcome_page

if ! is_dir_empty "$RABBITMQ_DEFAULT_CONF_DIR"; then
    # We add the copy from default config in the entrypoint to not break users 
    # bypassing the setup.sh logic. If the file already exists do not overwrite (in
    # case someone mounts a configuration file in /opt/bitnami/rabbitmq/etc/rabbitmq)
    debug "Copying files from $RABBITMQ_DEFAULT_CONF_DIR to $RABBITMQ_CONF_DIR"
    cp -nr "$RABBITMQ_DEFAULT_CONF_DIR"/. "$RABBITMQ_CONF_DIR"
fi

if [[ "$1" = "/opt/bitnami/scripts/rabbitmq/run.sh" ]]; then
    info "** Starting RabbitMQ setup **"
    /opt/bitnami/scripts/rabbitmq/setup.sh
    info "** RabbitMQ setup finished! **"
fi

echo ""
exec "$@"
