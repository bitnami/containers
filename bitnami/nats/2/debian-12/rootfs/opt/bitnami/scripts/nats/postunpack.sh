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
. /opt/bitnami/scripts/libvalidations.sh

# Load NATS environment
. /opt/bitnami/scripts/nats-env.sh

# Ensure required directories exist
chmod g+rwX "$NATS_BASE_DIR"
for dir in "$NATS_VOLUME_DIR" "$NATS_DATA_DIR" "$NATS_MOUNTED_CONF_DIR" "$NATS_CONF_DIR" "$NATS_DEFAULT_CONF_DIR" "$NATS_LOGS_DIR" "$NATS_TMP_DIR" "$NATS_INITSCRIPTS_DIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664"
done

# Set up the default Bitnami configuration
# ref: https://docs.nats.io/nats-streaming-server/configuring/cfgfile
render-template "${BITNAMI_ROOT_DIR}/scripts/nats/bitnami-templates/server.conf.tpl" > "$NATS_CONF_FILE"
chmod g+rw "$NATS_CONF_FILE"

# Redirect all logging to stdout
ln -sf /dev/stdout "$NATS_LOG_FILE"

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "${NATS_CONF_DIR}/"* "$NATS_DEFAULT_CONF_DIR"