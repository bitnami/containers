#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Parse environment
. /opt/bitnami/scripts/parse-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libparse.sh

info "** Starting Parse **"
if am_i_root; then
    exec_as_user "$PARSE_DAEMON_USER" "${PARSE_BASE_DIR}/bin/parse-server" "$PARSE_CONF_FILE" "$@"
else
    exec "${PARSE_BASE_DIR}/bin/parse-server" "$PARSE_CONF_FILE" "$@"
fi
