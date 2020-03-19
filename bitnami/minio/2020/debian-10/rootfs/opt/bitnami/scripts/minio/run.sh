#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libminio.sh

# Load MinIO environment variables
eval "$(minio_env)"

# Constants
EXEC=$(command -v minio)
ARGS=("server" "--certs-dir" "${MINIO_CERTSDIR}")
if is_boolean_yes "$MINIO_DISTRIBUTED_MODE_ENABLED"; then
    read -r -a nodes <<< "$(tr ',;' ' ' <<< "${MINIO_DISTRIBUTED_NODES}")"
    for node in "${nodes[@]}"; do
        ARGS+=("http://${node}:${MINIO_PORT_NUMBER}${MINIO_DATADIR}")
    done
else
    ARGS+=("--address" ":${MINIO_PORT_NUMBER}" "${MINIO_DATADIR}")
fi

info "** Starting MinIO **"
if am_i_root; then
    exec gosu "${MINIO_DAEMON_USER}" "${EXEC}" "${ARGS[@]}"
else
    exec "${EXEC}"  "${ARGS[@]}"
fi
