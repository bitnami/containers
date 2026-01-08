#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Discourse environment
. /opt/bitnami/scripts/discourse-env.sh

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libdiscourse.sh

cd "$DISCOURSE_BASE_DIR"

declare -a cmd=(
    "bundle" "exec" "passenger" "start"
    "--user" "$DISCOURSE_DAEMON_USER"
    "-e" "$DISCOURSE_ENV"
    "-p" "$DISCOURSE_PORT_NUMBER"
    "--spawn-method" "$DISCOURSE_PASSENGER_SPAWN_METHOD"
)

# Append extra flags specified via environment variables
if [[ -n "$DISCOURSE_PASSENGER_EXTRA_FLAGS" ]]; then
    declare -a passenger_extra_flags
    read -r -a passenger_extra_flags <<< "$DISCOURSE_PASSENGER_EXTRA_FLAGS"
    [[ "${#passenger_extra_flags[@]}" -gt 0 ]] && cmd+=("${passenger_extra_flags[@]}")
fi

info "** Starting Discourse **"
exec "${cmd[@]}" "$@"
