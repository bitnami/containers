#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load pgbouncer environment
. /opt/bitnami/scripts/pgbouncer-env.sh

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libpgbouncer.sh

print_welcome_page

# Enable the nss_wrapper settings
pgbouncer_enable_nss_wrapper

if [[ "$1" = "/opt/bitnami/scripts/pgbouncer/run.sh" ]]; then
    info "** Starting PgBouncer setup **"
    /opt/bitnami/scripts/pgbouncer/setup.sh
    info "** PgBouncer setup finished! **"
fi

echo ""
exec "$@"
