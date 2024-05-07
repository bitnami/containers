#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Valkey environment variables
. /opt/bitnami/scripts/valkey-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libvalkey.sh

# Ensure Valkey environment variables settings are valid
valkey_validate
# Ensure Valkey daemon user exists when running as root
am_i_root && ensure_user_exists "$VALKEY_DAEMON_USER" --group "$VALKEY_DAEMON_GROUP"
# Ensure Valkey is initialized
valkey_initialize
