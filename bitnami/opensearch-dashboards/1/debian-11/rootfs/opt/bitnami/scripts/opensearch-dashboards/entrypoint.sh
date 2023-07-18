#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libopensearchdashboards.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load environment
. /opt/bitnami/scripts/opensearch-dashboards-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/opensearch-dashboards/run.sh" ]]; then
    info "** Starting Opensearch Dashboards setup **"
    /opt/bitnami/scripts/opensearch-dashboards/setup.sh
    info "** Opensearch Dashboards setup finished! **"
fi

echo ""
exec "$@"
