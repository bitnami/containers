#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Valkey environment variables
. /opt/bitnami/scripts/valkey-cluster-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libvalkeycluster.sh

# Ensure Valkey environment variables settings are valid
valkey_cluster_validate
# Ensure Valkey is stopped when this script ends
trap "valkey_stop" EXIT
am_i_root && ensure_user_exists "$VALKEY_DAEMON_USER" --group "$VALKEY_DAEMON_GROUP"

# Ensure Valkey is initialized
valkey_cluster_initialize

if is_boolean_yes "$VALKEY_CLUSTER_DYNAMIC_IPS"; then
    valkey_cluster_update_ips
fi
