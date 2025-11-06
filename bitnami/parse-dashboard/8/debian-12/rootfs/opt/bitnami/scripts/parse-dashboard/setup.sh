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
. /opt/bitnami/scripts/libparsedashboard.sh

# Ensure Parse environment variables are valid
parse_dashboard_validate

# Ensure Parse is initialized
parse_dashboard_initialize

parse_url="${PARSE_DASHBOARD_PARSE_PROTOCOL}://${PARSE_DASHBOARD_PARSE_HOST}:${PARSE_DASHBOARD_PARSE_PORT_NUMBER}${PARSE_DASHBOARD_PARSE_MOUNT_PATH}"
info "Trying to connect to Parse server ${parse_url}"
parse_dashboard_wait_for_parse_connection "$parse_url"
