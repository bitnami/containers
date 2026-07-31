#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load ActiveMQ environment
. /opt/bitnami/scripts/activemq-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libactivemq.sh

info "** Starting ActiveMQ **"
if am_i_root; then
    exec_as_user "$ACTIVEMQ_DAEMON_USER" "${ACTIVEMQ_BASE_DIR}/bin/activemq" "console"
else
    exec "${ACTIVEMQ_BASE_DIR}/bin/activemq" "console"
fi