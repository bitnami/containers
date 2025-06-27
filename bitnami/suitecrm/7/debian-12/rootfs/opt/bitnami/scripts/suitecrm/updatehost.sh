#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load SuiteCRM environment
. /opt/bitnami/scripts/suitecrm-env.sh

# Load libraries
. /opt/bitnami/scripts/libsuitecrm.sh
. /opt/bitnami/scripts/libfile.sh

SUITECRM_SERVER_HOST="${1:?missing host}"
if is_boolean_yes "$SUITECRM_ENABLE_HTTPS"; then
    SUITECRM_SERVER_URL="https://${SUITECRM_SERVER_HOST}"
    [[ "$SUITECRM_EXTERNAL_HTTPS_PORT_NUMBER" != "443" ]] && SUITECRM_SERVER_URL+=":${SUITECRM_EXTERNAL_HTTPS_PORT_NUMBER}"
else
    SUITECRM_SERVER_URL="http://${SUITECRM_SERVER_HOST}"
    [[ "$SUITECRM_EXTERNAL_HTTP_PORT_NUMBER" != "80" ]] && SUITECRM_SERVER_URL+=":${SUITECRM_EXTERNAL_HTTP_PORT_NUMBER}"
fi
suitecrm_conf_set "site_url" "$SUITECRM_SERVER_URL"
suitecrm_conf_set "host_name" "$SUITECRM_SERVER_HOST"
