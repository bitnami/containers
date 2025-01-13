#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnginx.sh

# Load NGINX environment variables
. /opt/bitnami/scripts/nginx-env.sh

info "** Starting NGINX **"
exec "${NGINX_SBIN_DIR}/nginx" -c "$NGINX_CONF_FILE" -g "daemon off;"
