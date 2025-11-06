#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Parse environment
. /opt/bitnami/scripts/parse-dashboard-env.sh

# Load libraries
. /opt/bitnami/scripts/libparsedashboard.sh

PARSE_SERVER_HOST="${1:?missing host}"
if is_boolean_yes "$PARSE_DASHBOARD_ENABLE_HTTPS"; then
    PARSE_SERVER_URL="https://${PARSE_SERVER_HOST}"
    [[ "$PARSE_DASHBOARD_EXTERNAL_HTTPS_PORT_NUMBER" != "443" ]] && PARSE_SERVER_URL+=":${PARSE_EXTERNAL_HTTPS_PORT_NUMBER}"
else
    PARSE_SERVER_URL="http://${PARSE_SERVER_HOST}"
    [[ "$PARSE_DASHBOARD_EXTERNAL_HTTP_PORT_NUMBER" != "80" ]] && PARSE_SERVER_URL+=":${PARSE_EXTERNAL_HTTP_PORT_NUMBER}"
fi

PARSE_SERVER_URL+="${PARSE_DASHBOARD_PARSE_MOUNT_PATH}"
info "Updating configuration file"
parse_dashboard_conf_set "apps[0].serverURL" "$PARSE_SERVER_URL"
