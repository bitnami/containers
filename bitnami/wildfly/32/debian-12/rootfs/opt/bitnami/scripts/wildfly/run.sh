#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libwildfly.sh
. /opt/bitnami/scripts/liblog.sh

# Load WildFly environment
. /opt/bitnami/scripts/wildfly-env.sh

EXEC="${WILDFLY_BIN_DIR}/standalone.sh"
declare -a args=("-Djboss.server.data.dir=${WILDFLY_DATA_DIR}" "$@")

info "** Starting WildFly **"
if am_i_root; then
    exec_as_user "$WILDFLY_DAEMON_USER" "${EXEC[@]}" "${args[@]}"
else
    exec "${EXEC[@]}" "${args[@]}"
fi
