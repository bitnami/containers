#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

. /libos.sh
. /libfs.sh
. /libnginx.sh

# ensure nginx env var settings are valid
nginx_validate

# ensure nginx is stopped when this script ends.
trap "nginx_stop" EXIT

if am_i_root; then
    ensure_user_exists "$NGINX_DAEMON_USER" "$NGINX_DAEMON_GROUP"
fi

# ensure nginx is initialized
nginx_initialize

