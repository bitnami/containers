#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Spring Cloud Data Flow entrypoint

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh

# Load Spring Cloud Data Flow environment variables
. /opt/bitnami/scripts/spring-cloud-dataflow-env.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/spring-cloud-dataflow/run.sh"* || "$*" = *"/run.sh"* ]]; then
    info "** Starting Spring Cloud Data Flow setup **"
    /opt/bitnami/scripts/spring-cloud-dataflow/setup.sh
    info "** Spring Cloud Data Flow setup finished! **"
fi

echo ""
exec "$@"
