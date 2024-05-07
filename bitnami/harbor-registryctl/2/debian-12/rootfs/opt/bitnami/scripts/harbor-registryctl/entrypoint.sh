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

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/harbor-registryctl/run.sh" ]]; then
    info "** Starting harbor-registryctl setup **"
    /opt/bitnami/scripts/harbor-registryctl/setup.sh
    info "** harbor-registryctl setup finished! **"
fi

echo ""
exec "$@"
