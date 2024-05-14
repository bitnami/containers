#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libtomcat.sh

# Load Tomcat environment variables
. /opt/bitnami/scripts/tomcat-env.sh

error_code=0
stop_error=0

if is_tomcat_running; then
    BITNAMI_QUIET=1 tomcat_stop || stop_error="$?"
    if [[ "$stop_error" -ne 0 ]] || ! retry_while "is_tomcat_not_running"; then
        error "tomcat could not be stopped"
        error_code=1
    else
        info "tomcat stopped"
    fi
else
    info "tomcat is not running"
fi

exit "$error_code"
