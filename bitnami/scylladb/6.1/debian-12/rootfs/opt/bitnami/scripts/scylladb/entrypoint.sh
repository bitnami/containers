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
. /opt/bitnami/scripts/libscylladb.sh

# Load ScyllaDB environment variables
. /opt/bitnami/scripts/scylladb-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/scylladb/etc)
debug "Copying files from $DB_DEFAULT_CONF_DIR to $DB_CONF_DIR"
cp -nr "$DB_DEFAULT_CONF_DIR"/. "$DB_CONF_DIR"

if is_positive_int "$DB_DELAY_START_TIME" && [[ "$DB_DELAY_START_TIME" -gt 0 ]]; then
    info "** Delaying $DB_FLAVOR start by ${DB_DELAY_START_TIME} seconds **"
    sleep "$DB_DELAY_START_TIME"
fi

if [[ "$*" = *"/opt/bitnami/scripts/cassandra/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting $DB_FLAVOR setup **"
    /opt/bitnami/scripts/scylladb/setup.sh
    info "** $DB_FLAVOR setup finished! **"
fi

echo ""
exec "$@"
