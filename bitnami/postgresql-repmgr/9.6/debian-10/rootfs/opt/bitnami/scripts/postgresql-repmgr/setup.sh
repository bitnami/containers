#!/bin/bash
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
# Prepare PostgreSQL default configuration
repmgr_postgresql_configuration
# Prepare repmgr configuration
repmgr_generate_repmgr_config
# Initialize PostgreSQL & repmgr
repmgr_initialize
