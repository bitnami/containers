#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /liblog.sh
. /libnet.sh
. /libminioclient.sh

# Load MinIO Client environment variables
eval "$(minio_client_env)"

# Configure MinIO Client to use a MinIO server
minio_client_configure_server
