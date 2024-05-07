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

# Load harbor-core environment
. /opt/bitnami/scripts/harbor-core-env.sh

CMD="$(command -v harbor_core)"

cd "$HARBOR_CORE_BASE_DIR"

info "** Starting harbor-core **"
if am_i_root; then
    exec_as_user "$HARBOR_CORE_DAEMON_USER" "$CMD" "$@"
else
    exec "$CMD" "$@"
fi
