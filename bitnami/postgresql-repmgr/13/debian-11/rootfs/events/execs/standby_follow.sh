#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

. "$REPMGR_EVENTS_DIR/execs/includes/anotate_event_processing.sh"
. "$REPMGR_EVENTS_DIR/execs/includes/unlock_primary.sh"
