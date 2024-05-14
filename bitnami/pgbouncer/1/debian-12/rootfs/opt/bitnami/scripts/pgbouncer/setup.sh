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

# Ensure pgbouncer environment variables are valid
pgbouncer_validate

# Ensure 'pgbouncer' user exists when running as 'root'
am_i_root && ensure_user_exists "$PGBOUNCER_DAEMON_USER" --group "$PGBOUNCER_DAEMON_GROUP"

# Ensure pgbouncer is initialized
pgbouncer_initialize

# Execute init scripts
pgbouncer_custom_init_scripts
