#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Pgpool postunpack

# shellcheck disable=SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libldapclient.sh
. /opt/bitnami/scripts/libpgpool.sh

# Load Pgpool env. variables
eval "$(pgpool_env)"
# Load LDAP environment variables
eval "$(ldap_env)"

for dir in "$PGPOOL_INITSCRIPTS_DIR" "$PGPOOL_TMP_DIR" "$PGPOOL_LOG_DIR" "$PGPOOL_CONF_DIR" "$PGPOOL_DEFAULT_CONF_DIR" "$PGPOOL_ETC_DIR" "$PGPOOL_DEFAULT_ETC_DIR" "$PGPOOL_DATA_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# LDAP permissions
ldap_configure_permissions
ldap_create_pam_config "pgpool"

# Redirect all logging to stdout
ln -sf /dev/stdout "$PGPOOL_LOG_FILE"

if ! is_dir_empty "$PGPOOL_CONF_DIR"; then
    cp -r "$PGPOOL_CONF_DIR"/* "$PGPOOL_DEFAULT_CONF_DIR"
fi

if ! is_dir_empty "$PGPOOL_ETC_DIR"; then
    cp -r "$PGPOOL_ETC_DIR"/* "$PGPOOL_DEFAULT_ETC_DIR"
fi