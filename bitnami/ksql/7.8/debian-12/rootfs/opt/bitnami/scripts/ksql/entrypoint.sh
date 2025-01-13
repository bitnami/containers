#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libksql.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load KSQL environment variables
. /opt/bitnami/scripts/ksql-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/ksql/run.sh" ]]; then
    info "** Starting KSQL setup **"
    /opt/bitnami/scripts/ksql/setup.sh
    info "** KSQL setup finished! **"
fi

echo ""
exec "$@"
