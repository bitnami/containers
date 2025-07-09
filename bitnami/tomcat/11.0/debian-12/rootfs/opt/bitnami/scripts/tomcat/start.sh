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
start_error=0

if is_tomcat_not_running; then
    if am_i_root; then
        run_as_user "$TOMCAT_DAEMON_USER" "${TOMCAT_BIN_DIR}/startup.sh" || start_error="$?"
    else
        "${TOMCAT_BIN_DIR}/startup.sh" || start_error="$?"
    fi
    if [[ "$start_error" -ne 0 ]] || ! retry_while "is_tomcat_running"; then
        error "tomcat did not start"
        error_code=1
    else
        info "tomcat started"
    fi
else
    info "tomcat is already running"
fi

exit "$error_code"
