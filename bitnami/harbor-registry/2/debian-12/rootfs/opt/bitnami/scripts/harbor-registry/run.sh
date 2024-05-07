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

# Load harbor-registry environment
. /opt/bitnami/scripts/harbor-registry-env.sh

CMD="$(command -v registry)"
FLAGS=("serve" "/etc/registry/config.yml" "$@")

info "** Starting harbor-registry **"
if am_i_root; then
    exec_as_user "$HARBOR_REGISTRY_DAEMON_USER" "$CMD" "${FLAGS[@]}"
else
    exec "$CMD" "${FLAGS[@]}"
fi
