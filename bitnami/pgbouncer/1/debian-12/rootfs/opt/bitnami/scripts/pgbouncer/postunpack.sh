#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load pgbouncer environment
. /opt/bitnami/scripts/pgbouncer-env.sh

# Load libraries
. /opt/bitnami/scripts/libpgbouncer.sh
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh

for dir in "$PGBOUNCER_CONF_DIR" "$PGBOUNCER_LOG_DIR" "$PGBOUNCER_TMP_DIR" "$PGBOUNCER_MOUNTED_CONF_DIR" "$PGBOUNCER_INITSCRIPTS_DIR" "$PGBOUNCER_VOLUME_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done
