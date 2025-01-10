#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libwildfly.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh

# Load WildFly environment
. /opt/bitnami/scripts/wildfly-env.sh

# Ensure required directories exist
chmod g+rwX "$WILDFLY_BASE_DIR"
chmod g+rw "${WILDFLY_BIN_DIR}/standalone.conf"
for dir in "$WILDFLY_HOME_DIR" "${WILDFLY_BASE_DIR}/domain" "${WILDFLY_BASE_DIR}/standalone" "$WILDFLY_DEFAULT_STANDALONE_DIR" "$WILDFLY_DEFAULT_DOMAIN_DIR" "$WILDFLY_DATA_DIR"; do
    ensure_dir_exists "$dir"
    configure_permissions_ownership "$dir" -d "775" -f "664"
done

# Create a symlink to standalone deployments directory so users can mount their custom webapps at /app
ln -sf "${WILDFLY_BASE_DIR}/standalone/deployments" /app

# Copy all initially generated configuration files and standalone to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "$WILDFLY_STANDALONE_DIR"/* "$WILDFLY_DEFAULT_STANDALONE_DIR"
cp -r "$WILDFLY_DOMAIN_DIR"/* "$WILDFLY_DEFAULT_DOMAIN_DIR"

# In order to make the container work with non-root group we need to make
# a set of files writable by "other", as by default are owned by wildfly:root
chmod o+rX -R "${WILDFLY_DEFAULT_STANDALONE_DIR}"/*
chmod o+rX -R "${WILDFLY_DEFAULT_DOMAIN_DIR}"/*
