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
. /opt/bitnami/scripts/libcassandra.sh

# Load Cassandra environment variables
. /opt/bitnami/scripts/cassandra-env.sh

print_welcome_page

if is_positive_int "$DB_DELAY_START_TIME" && [[ "$DB_DELAY_START_TIME" -gt 0 ]]; then
    info "** Delaying Cassandra start by ${DB_DELAY_START_TIME} seconds **"
    sleep "$DB_DELAY_START_TIME"
fi

if [[ "$*" = *"/opt/bitnami/scripts/cassandra/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting Cassandra setup **"
    /opt/bitnami/scripts/cassandra/setup.sh
    info "** Cassandra setup finished! **"
fi

echo ""
exec "$@"
