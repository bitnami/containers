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

if [[ "$*" = *"/opt/bitnami/scripts/minio-client/run.sh"* ]]; then
    info "** Starting MinIO Client setup **"
    /opt/bitnami/scripts/minio-client/setup.sh
    info "** MinIO Client setup finished! **"
fi

echo ""
exec "$@"
