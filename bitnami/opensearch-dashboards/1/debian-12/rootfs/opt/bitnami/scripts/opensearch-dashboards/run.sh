#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libopensearchdashboards.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh

# Load environment
. /opt/bitnami/scripts/opensearch-dashboards-env.sh

info "** Starting Opensearch Dashboards **"
start_command=("${SERVER_BIN_DIR}/opensearch-dashboards" "serve")
if am_i_root; then
    exec_as_user "$SERVER_DAEMON_USER" "${start_command[@]}"
else
    exec "${start_command[@]}"
fi
