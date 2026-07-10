#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libfs.sh

# Load etcd environment variables
. /opt/bitnami/scripts/etcd-env.sh

for dir in "$ETCD_BIN_DIR" "$ETCD_DATA_DIR" "$ETCD_CONF_DIR" "$ETCD_DEFAULT_CONF_DIR" "${ETCD_BASE_DIR}/certs"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$ETCD_DATA_DIR" "${ETCD_BASE_DIR}/certs"

if ! is_dir_empty "$ETCD_CONF_DIR"; then
    # Copy all initially generated configuration files to the default directory
    # (this is to avoid breaking when entrypoint is being overridden)
    cp -r "${ETCD_CONF_DIR}/"* "$ETCD_DEFAULT_CONF_DIR"
fi