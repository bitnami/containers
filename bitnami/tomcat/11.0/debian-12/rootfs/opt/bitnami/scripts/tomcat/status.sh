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

# Load Tomcat environment variables
. /opt/bitnami/scripts/tomcat-env.sh

if is_tomcat_running; then
    info "tomcat is already running"
else
    info "tomcat is not running"
fi
