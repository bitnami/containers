#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libpostgresql.sh

. /opt/bitnami/scripts/librepmgr.sh

# Load PostgreSQL & repmgr environment variables
. /opt/bitnami/scripts/postgresql-env.sh

for dir in "$POSTGRESQL_INITSCRIPTS_DIR" "$POSTGRESQL_TMP_DIR" "$POSTGRESQL_LOG_DIR" "$POSTGRESQL_CONF_DIR" "${POSTGRESQL_CONF_DIR}/conf.d" "$POSTGRESQL_DEFAULT_CONF_DIR" "$POSTGRESQL_MOUNTED_CONF_DIR" "${POSTGRESQL_MOUNTED_CONF_DIR}/conf.d" "$POSTGRESQL_VOLUME_DIR" "$REPMGR_CONF_DIR" "$REPMGR_TMP_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done


# Copying events handlers
mv /events "$REPMGR_EVENTS_DIR"
chmod +x "$REPMGR_EVENTS_DIR"/router.sh "$REPMGR_EVENTS_DIR"/execs/*sh "$REPMGR_EVENTS_DIR"/execs/includes/*sh

# Redirect all logging to stdout
ln -sf /dev/stdout "$POSTGRESQL_LOG_FILE"

# Copy all initially generated configuration files to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "${POSTGRESQL_CONF_DIR}/"* "$POSTGRESQL_DEFAULT_CONF_DIR"

