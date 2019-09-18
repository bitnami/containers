#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Load libraries
. /libfs.sh
. /libos.sh
. /libconsul.sh

# Load Consul env. variables
eval "$(consul_env)"

if am_i_root; then
    ensure_user_exists "${CONSUL_SYSTEM_USER}"
    ensure_group_exists "${CONSUL_SYSTEM_GROUP}"
    chown -R "$CONSUL_SYSTEM_USER":"$CONSUL_SYSTEM_GROUP" \
        "${CONSUL_CONF_DIR}" "${CONSUL_DATA_DIR}" "${CONSUL_LOG_DIR}" \
        "${CONSUL_TMP_DIR}" "${CONSUL_SSL_DIR}" "${CONSUL_EXTRA_DIR}"
fi

consul_validate
consul_initialize
