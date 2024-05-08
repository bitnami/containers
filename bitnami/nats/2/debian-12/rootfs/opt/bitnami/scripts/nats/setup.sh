#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libnats.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh

# Load NATS environment
. /opt/bitnami/scripts/nats-env.sh

# Ensure NATS environment variables are valid
nats_validate

# Ensure NATS is initialized
if am_i_root; then
    info "Creating NATS daemon user"
    ensure_user_exists "$NATS_DAEMON_USER" --group "$NATS_DAEMON_GROUP" --system
fi
nats_initialize

# NATS init scripts
nats_custom_init_scripts
