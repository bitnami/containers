#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libzookeeper.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh

# Load ZooKeeper environment variables
. /opt/bitnami/scripts/zookeeper-env.sh

START_COMMAND=("${ZOO_BASE_DIR}/bin/zkServer.sh" "start-foreground" "$@")

info "** Starting ZooKeeper **"
if am_i_root; then
    exec_as_user "$ZOO_DAEMON_USER" "${START_COMMAND[@]}"
else
    exec "${START_COMMAND[@]}"
fi
