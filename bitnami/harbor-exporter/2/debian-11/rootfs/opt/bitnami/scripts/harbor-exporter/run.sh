#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libharborexporter.sh

# Load Harbor Exporter environment
. /opt/bitnami/scripts/harbor-exporter-env.sh

harbor_exporter_validate
info "** Wait for database connection **"
wait_for_connection "$HARBOR_DATABASE_HOST" "$HARBOR_DATABASE_PORT"
info "** Starting Harbor Exporter **"
exec "/opt/bitnami/harbor-exporter/bin/harbor_exporter"
