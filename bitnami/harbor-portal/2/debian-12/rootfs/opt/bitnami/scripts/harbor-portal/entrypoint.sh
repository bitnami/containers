#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libnginx.sh

# Load NGINX environment variables
. /opt/bitnami/scripts/nginx-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/nginx/run.sh" ]]; then
    info "** Starting harbor-portal setup **"
    /opt/bitnami/scripts/nginx/setup.sh
    /opt/bitnami/scripts/harbor-portal/setup.sh
    info "** harbor-portal setup finished! **"
fi

echo ""
exec "$@"
