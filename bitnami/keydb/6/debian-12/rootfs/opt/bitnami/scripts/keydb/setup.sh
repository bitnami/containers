#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load KeyDB environment variables
. /opt/bitnami/scripts/keydb-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libkeydb.sh

# Ensure KeyDB environment variables settings are valid
keydb_validate
# Ensure KeyDB daemon user exists when running as root
am_i_root && ensure_user_exists "$KEYDB_DAEMON_USER" --group "$KEYDB_DAEMON_GROUP"
# Ensure KeyDB is stopped when this script ends
trap "keydb_stop" EXIT
# Ensure KeyDB is initialized
keydb_initialize
