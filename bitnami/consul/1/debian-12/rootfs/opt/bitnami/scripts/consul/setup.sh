#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libconsul.sh

# Load Consul env. variables
. /opt/bitnami/scripts/consul-env.sh

if am_i_root; then
    ensure_user_exists "${CONSUL_DAEMON_USER}" --group "${CONSUL_DAEMON_GROUP}"
    chown -R "$CONSUL_DAEMON_USER":"$CONSUL_DAEMON_GROUP" \
        "${CONSUL_CONF_DIR}" "${CONSUL_DATA_DIR}" "${CONSUL_LOG_DIR}" \
        "${CONSUL_TMP_DIR}" "${CONSUL_SSL_DIR}"
fi

consul_validate
consul_initialize
consul_custom_init_scripts
