#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libkibana.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh

# Load environment
. /opt/bitnami/scripts/kibana-env.sh

info "** Starting Kibana **"
start_command=("${SERVER_BIN_DIR}/kibana" "serve")
if am_i_root; then
    exec_as_user "$SERVER_DAEMON_USER" "${start_command[@]}"
else
    exec "${start_command[@]}"
fi
