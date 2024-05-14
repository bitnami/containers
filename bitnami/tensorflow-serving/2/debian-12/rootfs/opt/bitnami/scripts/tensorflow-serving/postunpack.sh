#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libtensorflow-serving.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh


# Load tensorflow-serving environment variables
. /opt/bitnami/scripts/tensorflowserving-env.sh

ensure_user_exists "$TENSORFLOW_SERVING_DAEMON_USER" --group "$TENSORFLOW_SERVING_DAEMON_GROUP"
for dir in "$TENSORFLOW_SERVING_TMP_DIR" "$TENSORFLOW_SERVING_BIN_DIR" "$TENSORFLOW_SERVING_CONF_DIR" "$TENSORFLOW_SERVING_LOGS_DIR" "$TENSORFLOW_SERVING_BASE_DIR" "$TENSORFLOW_SERVING_VOLUME_DIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -u "$TENSORFLOW_SERVING_DAEMON_USER" -g "root"
done
