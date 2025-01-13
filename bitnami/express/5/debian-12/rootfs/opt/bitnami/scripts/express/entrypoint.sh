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
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

# Load Express environment
. /opt/bitnami/scripts/express-env.sh

print_welcome_page

if [[ "$1" = "npm" ]] && [[ "$2" = "run" || "$2" = "start" ]]; then
    info "** Running Express setup **"
    /opt/bitnami/scripts/express/setup.sh
    info "** Express setup finished! **"
fi

echo ""
exec "$@"
