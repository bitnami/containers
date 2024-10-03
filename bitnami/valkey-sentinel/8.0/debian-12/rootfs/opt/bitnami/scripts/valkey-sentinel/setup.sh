#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Valkey Sentinel environment variables
. /opt/bitnami/scripts/valkey-sentinel-env.sh

# Load libraries
. /opt/bitnami/scripts/libvalkeysentinel.sh
. /opt/bitnami/scripts/libos.sh

# Create daemon user if needed
am_i_root && ensure_user_exists "$VALKEY_SENTINEL_DAEMON_USER" --group "$VALKEY_SENTINEL_DAEMON_GROUP"

# Ensure valkey environment variables are valid
valkey_validate

# Initialize valkey sentinel
valkey_initialize
