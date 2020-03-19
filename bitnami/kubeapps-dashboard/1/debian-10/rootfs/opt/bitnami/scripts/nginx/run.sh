#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnginx.sh

# Load NGINX environment variables
eval "$(nginx_env)"

info "** Starting NGINX **"
exec "${NGINX_BASEDIR}/sbin/nginx" -c "${NGINX_CONFDIR}/nginx.conf" -g "daemon off;"
