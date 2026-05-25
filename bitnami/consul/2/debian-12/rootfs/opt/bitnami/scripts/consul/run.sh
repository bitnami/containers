#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

. /opt/bitnami/scripts/libconsul.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh

# Load Consul env. variables
. /opt/bitnami/scripts/consul-env.sh

EXEC="${CONSUL_BASE_DIR}/bin/consul"
flags=("agent" "-config-dir" "${CONSUL_CONF_DIR}" "-log-file" "${CONSUL_LOG_FILE}" "-disable-host-node-id=${CONSUL_DISABLE_HOST_NODE_ID}")

if [[ "${CONSUL_AGENT_MODE}" = "server" ]]; then
    flags+=("-server")
fi

if [[ -n "${CONSUL_BIND_ADDR}" ]]; then
    flags+=("-bind" "${CONSUL_BIND_ADDR}")
fi

info "** Starting Consul **"
if am_i_root; then
    exec_as_user "${CONSUL_DAEMON_USER}" "${EXEC}" "${flags[@]}"
else
    exec "${EXEC}" "${flags[@]}"
fi
