#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libharbor.sh
. /opt/bitnami/scripts/libharborexporter.sh

# Load harbor-exporter environment
. /opt/bitnami/scripts/harbor-exporter-env.sh

CMD="$(command -v harbor_exporter)"

harbor_exporter_validate
info "** Wait for database connection **"
wait_for_connection "$HARBOR_DATABASE_HOST" "$HARBOR_DATABASE_PORT"
info "** Starting harbor-exporter **"
if am_i_root; then
    exec_as_user "$HARBOR_EXPORTER_DAEMON_USER" "$CMD" "$@"
else
    exec "$CMD" "$@"
fi
