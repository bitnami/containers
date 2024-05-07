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
. /opt/bitnami/scripts/harbor-adapter-trivy-env.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/harbor-adapter-trivy/run.sh"* ]]; then
    info "** Starting harbor-adapter-trivy setup **"
    /opt/bitnami/scripts/harbor-adapter-trivy/setup.sh
    info "** harbor-adapter-trivy setup finished! **"
fi

echo ""
exec "$@"


