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
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh

# Load environment
. /opt/bitnami/scripts/opensearch-dashboards-env.sh

print_welcome_page

# We add the copy from default config in the entrypoint to not break users 
# bypassing the setup.sh logic. If the file already exists do not overwrite (in
# case someone mounts a configuration file in /opt/bitnami/elasticsearch/conf)
debug "Copying files from $SERVER_DEFAULT_CONF_DIR to $SERVER_CONF_DIR"
cp -nr "$SERVER_DEFAULT_CONF_DIR"/. "$SERVER_CONF_DIR"

if [[ "$1" = "/opt/bitnami/scripts/opensearch-dashboards/run.sh" ]]; then
    info "** Starting Opensearch Dashboards setup **"
    /opt/bitnami/scripts/opensearch-dashboards/setup.sh
    info "** Opensearch Dashboards setup finished! **"
fi

echo ""
exec "$@"
