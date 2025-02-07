#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/minio/run.sh"* ]]; then
    info "** Starting MinIO setup **"
    /opt/bitnami/scripts/minio/setup.sh
    info "** MinIO setup finished! **"
fi

echo ""
exec "$@"
