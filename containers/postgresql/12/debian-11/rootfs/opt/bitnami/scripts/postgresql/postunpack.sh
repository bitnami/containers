#!/bin/bash

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libpostgresql.sh

# Load PostgreSQL environment variables
. /opt/bitnami/scripts/postgresql-env.sh

for dir in "$POSTGRESQL_INITSCRIPTS_DIR" "$POSTGRESQL_TMP_DIR" "$POSTGRESQL_LOG_DIR" "$POSTGRESQL_CONF_DIR" "${POSTGRESQL_CONF_DIR}/conf.d" "$POSTGRESQL_MOUNTED_CONF_DIR" "${POSTGRESQL_MOUNTED_CONF_DIR}/conf.d" "$POSTGRESQL_VOLUME_DIR"; do
    ensure_dir_exists "$dir"
done

# Create basic pg_hba.conf for local connections
postgresql_allow_local_connection
# Create basic postgresql.conf
postgresql_create_config

chmod -R g+rwX "$POSTGRESQL_INITSCRIPTS_DIR" "$POSTGRESQL_TMP_DIR" "$POSTGRESQL_LOG_DIR" "$POSTGRESQL_CONF_DIR" "${POSTGRESQL_CONF_DIR}/conf.d" "$POSTGRESQL_MOUNTED_CONF_DIR" "${POSTGRESQL_MOUNTED_CONF_DIR}/conf.d" "$POSTGRESQL_VOLUME_DIR"

# Redirect all logging to stdout
ln -sf /dev/stdout "$POSTGRESQL_LOG_DIR/postgresql.log"
