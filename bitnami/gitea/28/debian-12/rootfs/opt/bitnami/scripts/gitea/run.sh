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
. /opt/bitnami/scripts/libgitea.sh

# Load Gitea environment variables
. /opt/bitnami/scripts/gitea-env.sh

declare -a cmd=("${GITEA_BASE_DIR}/bin/gitea")
declare -a args=("web" "--config=${GITEA_CONF_FILE}" "--pid=${GITEA_PID_FILE}" "--custom-path=${GITEA_CUSTOM_DIR}" "--work-path=${GITEA_WORK_DIR}")
args+=("$@")

info "** Starting Gitea **"
if am_i_root; then
    exec_as_user "$GITEA_DAEMON_USER" "${cmd[@]}" "${args[@]}"
else
    exec "${cmd[@]}" "${args[@]}"
fi
