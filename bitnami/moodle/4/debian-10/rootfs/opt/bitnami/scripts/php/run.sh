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

info "** Starting PHP-FPM **"
declare -a args=("--pid" "$PHP_FPM_PID_FILE" "--fpm-config" "$PHP_FPM_CONF_FILE" "-c" "$PHP_CONF_DIR" "-F")
exec "${PHP_FPM_SBIN_DIR}/php-fpm" "${args[@]}"
