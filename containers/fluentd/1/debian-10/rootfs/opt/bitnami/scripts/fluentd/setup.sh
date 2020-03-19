#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfluentd.sh

# Load Fluentd environment
eval "$(fluentd_env)"

# Ensure fluentd user and group exist when running as 'root'
if am_i_root; then
    ensure_user_exists "$FLUENTD_DAEMON_USER" "$FLUENTD_DAEMON_GROUP"

    # Ensure FLUENTD_DAEMON_USER has directory level permissions for installing fluentd plugins
    for subdir in "gems" "specifications" "cache" "doc"; do
        ensure_dir_exists "$FLUENTD_BASE_DIR/$subdir"
        chown "$FLUENTD_DAEMON_USER:$FLUENTD_DAEMON_GROUP" "$FLUENTD_BASE_DIR/$subdir"
    done

    # Ensure required directories exist and have the right persmissions
    for dir in "$FLUENTD_LOG_DIR" "$FLUENTD_PLUGINS_DIR"; do
        ensure_dir_exists "$dir"
        chown "$FLUENTD_DAEMON_USER:$FLUENTD_DAEMON_GROUP" "$dir"
    done
fi
