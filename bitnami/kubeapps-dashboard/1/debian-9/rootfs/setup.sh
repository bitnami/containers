#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace
# shellcheck disable=SC1091

# Load libraries
. /libos.sh
. /libfs.sh
. /libnginx.sh

# Load NGINX environment variables
eval "$(nginx_env)"

# Ensure NGINX environment variables settings are valid
nginx_validate
# Ensure NGINX is stopped when this script ends
trap "nginx_stop" EXIT
am_i_root && ensure_user_exists "$NGINX_DAEMON_USER" "$NGINX_DAEMON_GROUP"
# Ensure NGINX is initialized
nginx_initialize
