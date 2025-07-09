#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libtomcat.sh
. /opt/bitnami/scripts/liblog.sh

# Load Tomcat environment variables
. /opt/bitnami/scripts/tomcat-env.sh

info "** Starting Tomcat **"

if am_i_root; then
    exec_as_user "$TOMCAT_DAEMON_USER" "${TOMCAT_BIN_DIR}/catalina.sh" run "$@"
else
    exec "${TOMCAT_BIN_DIR}/catalina.sh" run "$@"
fi
