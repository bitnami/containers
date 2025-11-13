#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/librabbitmq.sh

# Load RabbitMQ environment variables
. /opt/bitnami/scripts/rabbitmq-env.sh

# Check whether we are deployed by the RabbitMQ Cluster Operator. This can be done by
# checking if the /operator folder exists
# https://github.com/rabbitmq/cluster-operator/blob/main/internal/resource/statefulset.go#L478
if [[ -d "/operator" ]]; then
    info "Container deployed by the RabbitMQ Cluster Operator. Skipping setup"
else
    # Ensure RabbitMQ environment variables settings are valid
    rabbitmq_validate
    # Ensure RabbitMQ is stopped when this script ends.
    trap "rabbitmq_stop" EXIT
    # Ensure 'daemon' user exists when running as 'root'
    am_i_root && ensure_user_exists "$RABBITMQ_DAEMON_USER" --group "$RABBITMQ_DAEMON_GROUP"
    # Ensure RabbitMQ is initialized
    rabbitmq_initialize
    # Load custom init scripts
    rabbitmq_custom_init_scripts
fi

