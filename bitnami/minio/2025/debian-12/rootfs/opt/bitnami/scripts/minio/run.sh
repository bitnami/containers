#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libminio.sh

# Load MinIO environment
. /opt/bitnami/scripts/minio-env.sh

# Constants
EXEC=$(command -v minio)
ARGS=("server" "--certs-dir" "${MINIO_CERTS_DIR}" "--console-address" ":${MINIO_CONSOLE_PORT_NUMBER}" "--address" ":${MINIO_API_PORT_NUMBER}")
# Add any extra flags passed to this script
ARGS+=("$@")
if is_boolean_yes "$MINIO_DISTRIBUTED_MODE_ENABLED"; then
    read -r -a nodes <<< "$(tr ',;' ' ' <<< "${MINIO_DISTRIBUTED_NODES}")"
    for node in "${nodes[@]}"; do
        if is_distributed_ellipses_syntax; then
            ARGS+=("${MINIO_SCHEME}://${node}")
        else
            ARGS+=("${MINIO_SCHEME}://${node}:${MINIO_API_PORT_NUMBER}/${MINIO_DATA_DIR}")
        fi
    done
else
    ARGS+=("${MINIO_DATA_DIR}")
fi

info "** Starting MinIO **"
if am_i_root; then
    exec_as_user "${MINIO_DAEMON_USER}" "${EXEC}" "${ARGS[@]}"
else
    exec "${EXEC}"  "${ARGS[@]}"
fi
