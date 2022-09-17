#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libphp.sh
. /opt/bitnami/scripts/liblog.sh

# Load PHP-FPM environment variables
. /opt/bitnami/scripts/php-env.sh

if is_php_fpm_running; then
    info "php-fpm is already running"
else
    info "php-fpm is not running"
fi
