#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace


. /liblog.sh
. /libnginx.sh

info "Starting nginx... "

exec "$NGINX_BASEDIR/sbin/nginx" -c "$NGINX_CONFDIR/nginx.conf" -g "daemon off;"
