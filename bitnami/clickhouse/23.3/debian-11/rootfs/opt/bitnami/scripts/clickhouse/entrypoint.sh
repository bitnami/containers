#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load ClickHouse environment variables
. /opt/bitnami/scripts/clickhouse-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/clickhouse/run.sh" ]]; then
    info "** Starting ClickHouse setup **"
    /opt/bitnami/scripts/clickhouse/setup.sh
    info "** ClickHouse setup finished! **"
fi

echo ""
exec "$@"
