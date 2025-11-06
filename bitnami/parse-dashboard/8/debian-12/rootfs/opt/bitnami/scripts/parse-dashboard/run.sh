#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Parse environment
. /opt/bitnami/scripts/parse-dashboard-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libparsedashboard.sh

info "** Starting Parse **"

parse_dashboard_args=("--config" "${PARSE_DASHBOARD_CONF_FILE}")

if ! is_boolean_yes "$PARSE_DASHBOARD_ENABLE_HTTPS"; then
    parse_dashboard_args+=("--allowInsecureHTTP" "1")
fi

if am_i_root; then
    exec_as_user "$PARSE_DASHBOARD_DAEMON_USER" "node" "${PARSE_DASHBOARD_BASE_DIR}/bin/parse-dashboard" "${parse_dashboard_args[@]}" "$@"
else
    exec node "${PARSE_DASHBOARD_BASE_DIR}/bin/parse-dashboard" "${parse_dashboard_args[@]}" "$@"
fi
