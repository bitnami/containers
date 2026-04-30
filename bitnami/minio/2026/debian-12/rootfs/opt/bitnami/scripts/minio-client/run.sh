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
. /opt/bitnami/scripts/libminioclient.sh

# Load MinIO Client environment
. /opt/bitnami/scripts/minio-client-env.sh

# Constants
EXEC=$(command -v mc)
ARGS=("--config-dir" "${MINIO_CLIENT_CONF_DIR}" "$@")

if am_i_root; then
    exec_as_user "${MINIO_CLIENT_DAEMON_USER}" "${EXEC}"  "${ARGS[@]}"
else
    exec "${EXEC}" "${ARGS[@]}"
fi
