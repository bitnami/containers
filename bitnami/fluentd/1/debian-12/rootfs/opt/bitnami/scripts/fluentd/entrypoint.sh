#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libfluentd.sh
. /opt/bitnami/scripts/libbitnami.sh

# Load Fluentd environment
eval "$(fluentd_env)"

print_welcome_page

if [[ "$*" == *"/opt/bitnami/scripts/fluentd/run.sh"* ]]; then
    info "** Starting Fluentd setup **"
    /opt/bitnami/scripts/fluentd/setup.sh
    info "** Fluentd setup finished! **"
fi

echo ""
exec "$@"
