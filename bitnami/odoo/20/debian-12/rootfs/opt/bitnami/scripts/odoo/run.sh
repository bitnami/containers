#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Odoo environment
. /opt/bitnami/scripts/odoo-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libodoo.sh

declare cmd="${ODOO_BASE_DIR}/bin/odoo"
declare -a args=("--config" "$ODOO_CONF_FILE" "$@")

info "** Starting Odoo **"
if am_i_root; then
    exec_as_user "$ODOO_DAEMON_USER" "$cmd" "${args[@]}"
else
    exec "$cmd" "${args[@]}"
fi
