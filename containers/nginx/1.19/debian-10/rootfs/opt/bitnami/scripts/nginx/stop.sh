#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libnginx.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh

# Load NGINX environment variables
. /opt/bitnami/scripts/nginx-env.sh

error_code=0

if is_nginx_running; then
    nginx_stop
    if ! retry_while "is_nginx_not_running"; then
        error "${MODULE} could not be stopped"
        error_code=1
    else
        info "${MODULE} stopped"
    fi
else
    info "${MODULE} is not running"
fi

exit "${error_code}"
