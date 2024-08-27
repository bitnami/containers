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
. /opt/bitnami/scripts/libkeydb.sh
. /opt/bitnami/scripts/libfs.sh

for dir in "$KEYDB_DATA_DIR" "$KEYDB_CONF_DIR" "$KEYDB_DEFAULT_CONF_DIR" "$KEYDB_TMP_DIR"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX /bitnami "$KEYDB_VOLUME_DIR" "$KEYDB_BASE_DIR"

# Prepare default KeyDB configuration
keydb_default_config
