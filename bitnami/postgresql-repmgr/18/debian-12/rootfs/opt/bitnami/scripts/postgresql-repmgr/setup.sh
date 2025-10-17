#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami PostgreSQL setup

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load Libraries
. /opt/bitnami/scripts/libpostgresql.sh
. /opt/bitnami/scripts/librepmgr.sh

# Load PostgreSQL & repmgr environment variables
. /opt/bitnami/scripts/postgresql-env.sh

# Ensure PostgreSQL & repmgr environment variables settings are valid
repmgr_validate
postgresql_validate

# Set the environment variables for the node's role
eval "$(repmgr_set_role)"

# Ensure PostgreSQL is stopped when this script ends.
trap "postgresql_stop" EXIT
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$POSTGRESQL_DAEMON_USER" --group "$POSTGRESQL_DAEMON_GROUP"

if is_boolean_yes "$REPMGR_SKIP_SETUP"; then
    info "Skipping preparing configuration files..."
    if [[ "$REPMGR_ROLE" = "standby" ]]; then
        repmgr_wait_primary_node || exit 1
        repmgr_rewind
        POSTGRESQL_MASTER_PORT_NUMBER="$REPMGR_CURRENT_PRIMARY_PORT"
        export POSTGRESQL_MASTER_PORT_NUMBER
        POSTGRESQL_MASTER_HOST="$REPMGR_CURRENT_PRIMARY_HOST"
        export POSTGRESQL_MASTER_HOST
        postgresql_configure_recovery
        postgresql_start_bg
        repmgr_unregister_standby
        repmgr_register_standby
    fi
    # This fixes an issue if a PID was left over during the setup
    rm -f "$REPMGR_PID_FILE"
else
    # Prepare PostgreSQL default configuration
    repmgr_postgresql_configuration
    # Prepare repmgr configuration
    repmgr_generate_repmgr_config
    # Initialize PostgreSQL & repmgr
    export POSTGRESQL_USE_CUSTOM_PGHBA_INITIALIZATION="yes"
    repmgr_initialize
fi
