#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libpostgresql.sh

# Load PostgreSQL environment variables
. /opt/bitnami/scripts/postgresql-env.sh

for dir in "$POSTGRESQL_INITSCRIPTS_DIR" "$POSTGRESQL_TMP_DIR" "$POSTGRESQL_LOG_DIR" "$POSTGRESQL_CONF_DIR" "${POSTGRESQL_CONF_DIR}/conf.d" "$POSTGRESQL_MOUNTED_CONF_DIR" "$POSTGRESQL_DEFAULT_CONF_DIR" "${POSTGRESQL_MOUNTED_CONF_DIR}/conf.d" "$POSTGRESQL_VOLUME_DIR"; do
    ensure_dir_exists "$dir"
done

# Create basic pg_hba.conf for local connections
postgresql_allow_local_connection
# Create basic postgresql.conf
postgresql_create_config

chmod -R g+rwX "$POSTGRESQL_INITSCRIPTS_DIR" "$POSTGRESQL_TMP_DIR" "$POSTGRESQL_LOG_DIR" "$POSTGRESQL_CONF_DIR" "${POSTGRESQL_CONF_DIR}/conf.d" "$POSTGRESQL_MOUNTED_CONF_DIR" "${POSTGRESQL_MOUNTED_CONF_DIR}/conf.d" "$POSTGRESQL_VOLUME_DIR"

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "${POSTGRESQL_CONF_DIR}/"* "$POSTGRESQL_DEFAULT_CONF_DIR"

# Redirect all logging to stdout
ln -sf /dev/stdout "$POSTGRESQL_LOG_DIR/postgresql.log"
ln -sf /dev/stdout "$POSTGRESQL_LOG_DIR/postgresql.csv"
ln -sf /dev/stdout "$POSTGRESQL_LOG_DIR/postgresql.json"

# Add extra non-root user for compatibility with cloudnative-pg
# https://github.com/cloudnative-pg/cloudnative-pg/blob/v1.25.0/api/v1/cluster_types.go#L91
ensure_user_exists postgres --group root --uid 26 --system