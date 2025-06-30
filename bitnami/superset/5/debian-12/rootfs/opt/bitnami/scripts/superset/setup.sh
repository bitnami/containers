#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Superset environment variables
. /opt/bitnami/scripts/superset-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libsuperset.sh

# Ensure Superset environment variables settings are valid
superset_validate
# Ensure Superset daemon user exists when running as root
am_i_root && ensure_user_exists "$SUPERSET_DAEMON_USER" --group "$SUPERSET_DAEMON_GROUP"
# Ensure Superset is initialized
superset_initialize
