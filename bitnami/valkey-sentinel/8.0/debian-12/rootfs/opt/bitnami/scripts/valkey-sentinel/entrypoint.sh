#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Valkey Sentinel environment variables
. /opt/bitnami/scripts/valkey-sentinel-env.sh

# Load libraries
. /opt/bitnami/scripts/libvalkeysentinel.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

print_welcome_page

if [[ "$*" == *"/opt/bitnami/scripts/valkey-sentinel/run.sh"* ]]; then
    info "** Starting Valkey sentinel setup **"
    /opt/bitnami/scripts/valkey-sentinel/setup.sh
    info "** Valkey sentinel setup finished! **"
fi

echo ""
exec "$@"
