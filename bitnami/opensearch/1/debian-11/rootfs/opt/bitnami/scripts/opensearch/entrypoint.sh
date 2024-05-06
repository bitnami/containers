#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libopensearch.sh

# Load environment
. /opt/bitnami/scripts/opensearch-env.sh

print_welcome_page

if [[ "$1" = "/opt/bitnami/scripts/opensearch/run.sh" ]]; then
    info "** Starting Opensearch setup **"
    /opt/bitnami/scripts/opensearch/setup.sh
    info "** Opensearch setup finished! **"
fi

echo ""
exec "$@"
