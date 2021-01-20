#!/bin/bash

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libwebserver.sh

# Load PHP-FPM environment
. /opt/bitnami/scripts/php-env.sh

# Load web server environment and functions
. "/opt/bitnami/scripts/$(web_server_type)-env.sh"

error_code=0

if is_php_fpm_enabled; then
    if is_php_fpm_not_running; then
        error "php-fpm is not running"
        error_code=1
    else
        info "** Reloading PHP-FPM configuration **"
        php_fpm_reload
    fi
else
    web_server_reload
fi

exit "$error_code"
