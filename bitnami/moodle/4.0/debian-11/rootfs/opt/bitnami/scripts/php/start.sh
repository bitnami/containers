#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh

# Load PHP-FPM environment variables
. /opt/bitnami/scripts/php-env.sh

error_code=0

if is_php_fpm_not_running; then
    nohup /opt/bitnami/scripts/php/run.sh >/dev/null 2>&1 &
    if ! retry_while "is_php_fpm_running"; then
        error "php-fpm did not start"
        error_code=1
    else
        info "php-fpm started"
    fi
else
    info "php-fpm is already running"
fi

exit "$error_code"
