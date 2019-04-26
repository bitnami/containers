#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /liblog.sh
. /libos.sh
. /libminioclient.sh

# Load MinIO Client environment variables
eval "$(minio_client_env)"

# Constants
EXEC=$(command -v mc)
ARGS=("--config-dir" "${MINIO_CLIENT_CONFIGDIR}" "$@")

if am_i_root; then
    exec gosu "${MINIO_CLIENT_DAEMON_USER}" "${EXEC}"  "${ARGS[@]}"
else
    exec "${EXEC}" "${ARGS[@]}"
fi
