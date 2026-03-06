#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libsolr.sh

# Load solr environment variables
. /opt/bitnami/scripts/solr-env.sh

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/solr/run.sh"* ]]; then
    info "** Starting solr setup **"
    /opt/bitnami/scripts/solr/setup.sh
    info "** solr setup finished! **"
fi

echo ""
exec "$@"
