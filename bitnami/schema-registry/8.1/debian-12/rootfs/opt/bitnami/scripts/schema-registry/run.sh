#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

# Load Schema Registry environment variables
. /opt/bitnami/scripts/schema-registry-env.sh

info "** Starting Schema Registry **"

__run_cmd="${SCHEMA_REGISTRY_BIN_DIR}/schema-registry-start"
__run_flags=("$SCHEMA_REGISTRY_CONF_FILE" "$@")

if am_i_root; then
    exec_as_user "$SCHEMA_REGISTRY_DAEMON_USER" "$__run_cmd" "${__run_flags[@]}"
else
    exec "$__run_cmd" "${__run_flags[@]}"
fi
