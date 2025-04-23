#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/librabbitmq.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

# Load RabbitMQ environment variables
. /opt/bitnami/scripts/rabbitmq-env.sh

# Set up queue rebalance to run in the background after the cluster is up
if is_boolean_yes "$RABBITMQ_CLUSTER_REBALANCE"; then
    (
        current_attempt=1
        rebalanced=false
        while [[ "$current_attempt" -le "$RABBITMQ_CLUSTER_REBALANCE_ATTEMPTS" ]]; do
            if rabbitmqctl cluster_status >/dev/null; then
                rabbitmq-queues rebalance "all"
                rebalanced=true
                break
            else
                ((current_attempt++))
            fi
        done
        if is_boolean_yes "$rebalanced"; then
            info "Cluster rebalanced successfully"
        else
            error "Unable to rebalance cluster"
        fi
    ) &
fi

# Resources limits: maximum number of open file descriptors
if [ -n "${RABBITMQ_ULIMIT_NOFILES:-}" ]; then
    current_limit=$(ulimit -n)
    if [ "$current_limit" != "unlimited" ]; then
        # shellcheck disable=SC2086
        if [ $RABBITMQ_ULIMIT_NOFILES -gt $current_limit ]; then
            info "Setting file description limit to $RABBITMQ_ULIMIT_NOFILES"
            ulimit -n $RABBITMQ_ULIMIT_NOFILES
        fi
    fi
fi

info "** Starting RabbitMQ **"
cd "$RABBITMQ_BASE_DIR"
if am_i_root; then
    exec_as_user "$RABBITMQ_DAEMON_USER" "${RABBITMQ_BIN_DIR}/rabbitmq-server"
else
    exec "${RABBITMQ_BIN_DIR}/rabbitmq-server"
fi
