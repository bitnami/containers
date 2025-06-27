#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Odoo environment
. /opt/bitnami/scripts/odoo-env.sh

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/odoo/run.sh" ]]; then
    /opt/bitnami/scripts/postgresql-client/setup.sh
    /opt/bitnami/scripts/odoo/setup.sh
    /post-init.sh
    info "** Odoo setup finished! **"
fi

echo ""
exec "$@"
