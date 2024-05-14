#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libcilium.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load Cilium environment variables
. /opt/bitnami/scripts/cilium-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/cilium/run.sh" ]]; then
    info "** Starting Cilium setup **"
    /opt/bitnami/scripts/cilium/setup.sh
    info "** Cilium setup finished! **"
fi

echo ""
exec "$@"
