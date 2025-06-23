#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libksql.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh

# Load KSQL environment variables
. /opt/bitnami/scripts/ksql-env.sh

# Ensure KSQL environment variables are valid
ksql_validate

# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$KSQL_DAEMON_USER" --group "$KSQL_DAEMON_GROUP"
for dir in "$KSQL_CONF_DIR" "$KSQL_DATA_DIR" "$KSQL_LOGS_DIR"; do
    ensure_dir_exists "$dir"
    am_i_root && chown -R "${KSQL_DAEMON_USER}:${KSQL_DAEMON_GROUP}" "$dir"
done

# Ensure KSQL is initialized
ksql_initialize
