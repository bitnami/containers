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

# Load harbor-jobservice environment
. /opt/bitnami/scripts/harbor-jobservice-env.sh

CMD="$(command -v harbor_jobservice)"
FLAGS=("-c" "/etc/jobservice/config.yml" "$@")

cd "$HARBOR_JOBSERVICE_BASE_DIR"

info "** Starting harbor-jobservice **"
if am_i_root; then
    exec_as_user "$HARBOR_JOBSERVICE_DAEMON_USER" "$CMD" "${FLAGS[@]}"
else
    exec "$CMD" "${FLAGS[@]}"
fi
