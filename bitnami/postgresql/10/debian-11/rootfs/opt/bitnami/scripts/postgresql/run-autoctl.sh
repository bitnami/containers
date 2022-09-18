#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libpostgresql.sh
. /opt/bitnami/scripts/libautoctl.sh
. /opt/bitnami/scripts/libos.sh

# Load PostgreSQL environment variables
. /opt/bitnami/scripts/postgresql-env.sh

export HOME="$POSTGRESQL_AUTOCTL_VOLUME_DIR"

autoctl_initialize

flags=("run" "--pgdata" "$POSTGRESQL_DATA_DIR")
cmd=$(command -v pg_autoctl)

info "** Starting PostgreSQL autoctl_node (Mode: $POSTGRESQL_AUTOCTL_MODE) **"
if am_i_root; then
    exec gosu "$POSTGRESQL_DAEMON_USER" "$cmd" "${flags[@]}"
else
    PGPASSWORD=$POSTGRESQL_REPLICATION_PASSWORD exec "$cmd" "${flags[@]}"
fi
