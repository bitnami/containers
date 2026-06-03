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
. /opt/bitnami/scripts/libappsmith.sh

# Load Appsmith environment variables
. /opt/bitnami/scripts/appsmith-env.sh

# We need to load in the environment the Appsmith configuration file in order
# for the application to work. Using a similar approach as the upstream container
# https://github.com/appsmithorg/appsmith/blob/v1.9.12/deploy/docker/entrypoint.sh#L58-L63
set -a
. "$APPSMITH_CONF_FILE"
set +a

appsmith_unset_unused_variables

declare -a cmd=()
declare -a args=()

if [[ "$APPSMITH_MODE" == "backend" ]]; then
    # We need to be in the same folder or the application will fail for not finding
    # the datasource plugins
    # https://github.com/appsmithorg/appsmith/blob/release/app/server/entrypoint.sh#L15
    cd "${APPSMITH_BASE_DIR}/backend" || exit 1
    cmd+=("java")
    args+=("-Dserver.port=${APPSMITH_API_PORT}" "-Dappsmith.admin.envfile=${APPSMITH_CONF_FILE}" "-Djava.security.egd=file:/dev/./urandom" "-jar" "${APPSMITH_BASE_DIR}/backend/server.jar")
elif [[ "$APPSMITH_MODE" == "rts" ]]; then
    # We need to be in the same folder as the server.js script or it will fail
    # https://github.com/appsmithorg/appsmith/blob/release/app/rts/start-server.sh#L5
    cd "${APPSMITH_BASE_DIR}/rts" || exit 1
    export PORT="$APPSMITH_RTS_PORT"
    cmd+=("node")
    args+=("${APPSMITH_BASE_DIR}/rts/bundle/server.js")
else
    # For the Client (UI) we just run nginx with the generated configuration
    cmd+=("${BITNAMI_ROOT_DIR}/scripts/nginx/run.sh")
fi

info "** Starting Appsmith ${APPSMITH_MODE} **"
if am_i_root; then
    exec_as_user "$APPSMITH_DAEMON_USER" "${cmd[@]}" "${args[@]}"
else
    exec "${cmd[@]}" "${args[@]}"
fi
