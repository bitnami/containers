#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

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

if is_php_fpm_running; then
    BITNAMI_QUIET=1 php_fpm_stop
    if ! retry_while "is_php_fpm_not_running"; then
        error "php-fpm could not be stopped"
        error_code=1
    else
        info "php-fpm stopped"
    fi
else
    info "php-fpm is not running"
fi

exit "$error_code"
