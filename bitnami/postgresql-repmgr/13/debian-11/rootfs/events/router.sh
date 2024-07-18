#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/librepmgr.sh
. /opt/bitnami/scripts/libpostgresql.sh

. /opt/bitnami/scripts/postgresql-env.sh

echo "[REPMGR EVENT] Node id: $1; Event type: $2; Success [1|0]: $3; Time: $4;  Details: $5"
event_script="$REPMGR_EVENTS_DIR/execs/$2.sh"
echo "Looking for the script: $event_script"
if [[ -f "$event_script" ]]; then
    echo "[REPMGR EVENT] will execute script '$event_script' for the event"
    . "$event_script"
else
    echo "[REPMGR EVENT] no script '$event_script' found. Skipping..."
fi
