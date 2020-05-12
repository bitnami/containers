#!/bin/bash
#
# Bitnami PostgreSQL setup

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libpostgresql.sh

# Load PostgreSQL environment variables
eval "$(postgresql_env)"

# Ensure PostgreSQL environment variables settings are valid
postgresql_validate
# Ensure PostgreSQL is stopped when this script ends.
trap "postgresql_stop" EXIT
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$POSTGRESQL_DAEMON_USER" "$POSTGRESQL_DAEMON_GROUP"
# Fix logging issue when running as root
am_i_root && chmod o+w "$(readlink /dev/stdout)"
# Allow running custom pre-initialization scripts
postgresql_custom_pre_init_scripts
# Ensure PostgreSQL is initialized
postgresql_initialize
# Allow running custom initialization scripts
postgresql_custom_init_scripts

# Allow remote connections once the initialization is finished
if ! postgresql_is_file_external "postgresql.conf"; then
    info "Enabling remote connections"
    postgresql_enable_remote_connections
    postgresql_set_property "port" "$POSTGRESQL_PORT_NUMBER"
fi
