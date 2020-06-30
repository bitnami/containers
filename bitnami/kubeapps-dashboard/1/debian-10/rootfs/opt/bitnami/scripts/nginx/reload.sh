#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libnginx.sh
. /opt/bitnami/scripts/liblog.sh

# Load NGINX environment
. /opt/bitnami/scripts/nginx-env.sh

info "** Reloading NGINX configuration **"
exec "${NGINX_SBIN_DIR}/nginx" -s reload
