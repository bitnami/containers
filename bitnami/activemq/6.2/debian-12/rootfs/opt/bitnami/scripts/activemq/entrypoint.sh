#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh

# Load environment
. /opt/bitnami/scripts/activemq-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/activemq/run.sh" ]]; then
    info "** Starting ActiveMQ setup **"
    /opt/bitnami/scripts/activemq/setup.sh
    info "** ActiveMQ setup finished! **"
fi

echo ""
exec "$@"