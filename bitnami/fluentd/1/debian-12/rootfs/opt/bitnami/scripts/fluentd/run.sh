#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libfluentd.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

# Load Fluentd environment
eval "$(fluentd_env)"

EXEC="$(command -v fluentd)"
args=("--config" "${FLUENTD_CONF_DIR}/${FLUENTD_CONF:-fluentd.conf}" "--plugin" "$FLUENTD_PLUGINS_DIR")

# extra command line flags
if [[ -n "$FLUENTD_OPT" ]]; then
    read -r -a envExtraFlags <<< "$FLUENTD_OPT"
    args+=("${envExtraFlags[@]}")
fi

info "** Starting Fluentd **"
if am_i_root && [[ "$FLUENTD_DAEMON_USER" != "root" ]]; then
    info "Switching daemon from root to $FLUENTD_DAEMON_USER..."
    exec_as_user "$FLUENTD_DAEMON_USER" "$EXEC" "${args[@]}"
else
    exec "$EXEC" "${args[@]}"
fi
