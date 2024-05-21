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

# Load Cilium environment variables
. /opt/bitnami/scripts/cilium-env.sh

# Ensure 'daemon' user exists when running as 'root'
if am_i_root; then
    ensure_user_exists "$CILIUM_DAEMON_USER" --group "$CILIUM_DAEMON_GROUP"
fi
