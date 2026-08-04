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
. /opt/bitnami/scripts/libkong.sh

# Load Kong environment variables
. /opt/bitnami/scripts/kong-env.sh

# Check whether we are deployed by the Kong Operator. This can be done by checking whether
# the operator's cluster certificate volume is mounted and KONG_PREFIX points at its writable
# volume (only set by the operator in hardened mode)
# https://github.com/kong/kong-operator/blob/main/pkg/utils/kubernetes/resources/deployments.go
if [[ -d "/var/cluster-certificate" && "${KONG_PREFIX:-}" == "/var/kong" ]]; then
    info "Container deployed by the Kong Operator. Skipping setup"
else
    # Ensure Kong environment variables are valid
    kong_validate
    # Ensure file ownership is correct
    am_i_root && chown -R "$KONG_DAEMON_USER":"$KONG_DAEMON_GROUP" "$KONG_SERVER_DIR" "$KONG_CONF_DIR"
    # Ensure Kong is initialized
    kong_initialize
    # Allow running custom initialization scripts
    kong_custom_init_scripts
fi
