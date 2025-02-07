#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libejbca.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh

# Load ejbca environment variables
. /opt/bitnami/scripts/ejbca-env.sh

ensure_user_exists "$EJBCA_DAEMON_USER" --group "$EJBCA_DAEMON_GROUP" --system

for dir in "$EJBCA_BASE_DIR" "$EJBCA_WILDFLY_BASE_DIR"  "$EJBCA_TMP_DIR" "$EJBCA_VOLUME_DIR" \
           "$EJBCA_WILDFLY_VOLUME_DIR" "${EJBCA_WILDFLY_STANDALONE_DIR}" "${EJBCA_WILDFLY_DEFAULT_STANDALONE_DIR}" \
           "${EJBCA_CONF_DIR}" "${EJBCA_DEFAULT_CONF_DIR}" "${EJBCA_WILDFLY_DOMAIN_DIR}" "${EJBCA_WILDFLY_DEFAULT_DOMAIN_DIR}" "${EJBCA_WILDFLY_BASE_DIR}/domain" "$EJBCA_WILDFLY_TMP_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
    chown -R "${EJBCA_DAEMON_USER}:root" "$dir"
done

chmod g+rw "$EJBCA_WILDFLY_STANDALONE_CONF_FILE"

# Copy all initially generated configuration files and standalone to the default directory
# (this is to avoid breaking when entrypoint is being overridden)
cp -r "$EJBCA_CONF_DIR"/* "$EJBCA_DEFAULT_CONF_DIR"
cp -r "$EJBCA_WILDFLY_STANDALONE_DIR"/* "$EJBCA_WILDFLY_DEFAULT_STANDALONE_DIR"
cp -r "$EJBCA_WILDFLY_DOMAIN_DIR"/* "$EJBCA_WILDFLY_DEFAULT_DOMAIN_DIR"

# In order to make the container work with non-root group we need to make
# a set of files writable by "other", as by default are owned by wildfly:root
chmod o+rX -R "${EJBCA_DEFAULT_CONF_DIR}"/*
chmod o+rX -R "${EJBCA_WILDFLY_DEFAULT_STANDALONE_DIR}"/*
chmod o+rX -R "${EJBCA_WILDFLY_DEFAULT_DOMAIN_DIR}"/*
chmod o+r "$EJBCA_BIN_DIR"/*
chmod o+r "$EJBCA_DATABASE_SCRIPTS_DIR"/*
chmod o+x "$EJBCA_BIN_DIR"/*.sh