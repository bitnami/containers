#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1090,SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libmastodon.sh

# Load Mastodon environment variables
. /opt/bitnami/scripts/mastodon-env.sh

# Load Mastodon configuration
eval "$(mastodon_runtime_env)"

declare cmd
declare -a args=()

cd "${MASTODON_BASE_DIR}" || exit 1

# Both the web and streaming services use the same PORT environment
# variable, so we need to set it here.
# https://github.com/mastodon/mastodon/blob/main/Procfile.dev#L1
if [[ "$MASTODON_MODE" == "web" ]]; then
    # Web service
    export PORT="${PORT:-$MASTODON_WEB_PORT_NUMBER}"
    cmd="bundle"
    args+=("exec" "puma" "-C" "config/puma.rb")
elif [[ "$MASTODON_MODE" == "streaming" ]]; then
    # Streaming service
    export PORT="${PORT:-$MASTODON_STREAMING_PORT_NUMBER}"
    cmd="node"
    args+=("./streaming")
else
    # Sidekiq
    cmd="bundle"
    args+=("exec" "sidekiq")
fi

info "** Starting Mastodon ${MASTODON_MODE} **"
if am_i_root; then
    exec_as_user "$MASTODON_DAEMON_USER" "$cmd" "${args[@]}"
else
    exec "$cmd" "${args[@]}"
fi
