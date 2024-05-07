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
. /opt/bitnami/scripts/libharbor.sh
. /opt/bitnami/scripts/libharborexporter.sh

# Load environment
. /opt/bitnami/scripts/harbor-exporter-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/harbor-exporter/run.sh" ]]; then
    info "** Starting harbor-exporter setup **"
    install_custom_certs
    info "** harbor-exporter setup finished! **"
fi

echo ""
exec "$@"
