#!/bin/bash
# Copyright VMware, Inc.
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
           "${EJBCA_CONF_DIR}" "${EJBCA_DEFAULT_CONF_DIR}" "${EJBCA_WILDFLY_BASE_DIR}/domain" "$EJBCA_WILDFLY_TMP_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
    chown -R "${EJBCA_DAEMON_USER}:root" "$dir"
done

chmod g+rw "$EJBCA_WILDFLY_STANDALONE_CONF_FILE"
