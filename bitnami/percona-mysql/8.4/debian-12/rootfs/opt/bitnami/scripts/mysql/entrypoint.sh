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
. /opt/bitnami/scripts/libmysql.sh

# Load Percona Server for MySQL environment variables
. /opt/bitnami/scripts/mysql-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/mysql/run.sh" ]]; then
    info "** Starting Percona Server for MySQL setup **"
    /opt/bitnami/scripts/mysql/setup.sh
    info "** Percona Server for MySQL setup finished! **"
fi

echo ""
exec "$@"
