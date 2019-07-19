#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /libfs.sh
. /libpostgresql.sh

# Load PostgreSQL environment variables
eval "$(postgresql_env)"

for dir in "$POSTGRESQL_INITSCRIPTS_DIR" "$POSTGRESQL_TMP_DIR" "$POSTGRESQL_LOG_DIR" "$POSTGRESQL_CONF_DIR" "${POSTGRESQL_CONF_DIR}/conf.d" "$POSTGRESQL_VOLUME_DIR"; do
    ensure_dir_exists "$dir"
done
chmod -R g+rwX "$POSTGRESQL_INITSCRIPTS_DIR" "$POSTGRESQL_TMP_DIR" "$POSTGRESQL_LOG_DIR" "$POSTGRESQL_CONF_DIR" "${POSTGRESQL_CONF_DIR}/conf.d" "$POSTGRESQL_VOLUME_DIR"

# Redirect all logging to stdout
ln -sf /dev/stdout "$POSTGRESQL_LOG_DIR/postgresql.log"
