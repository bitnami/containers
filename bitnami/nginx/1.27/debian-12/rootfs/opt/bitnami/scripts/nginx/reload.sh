#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libnginx.sh
. /opt/bitnami/scripts/liblog.sh

# Load NGINX environment
. /opt/bitnami/scripts/nginx-env.sh

info "** Reloading NGINX configuration **"
exec "${NGINX_SBIN_DIR}/nginx" -s reload
