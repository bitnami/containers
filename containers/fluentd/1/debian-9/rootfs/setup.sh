#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /libfs.sh
. /libos.sh
. /libfluentd.sh

# Load Fluentd environment
eval "$(fluentd_env)"

# Ensure fluentd user and group exist when running as 'root'
if am_i_root; then
    ensure_user_exists "$FLUENTD_DAEMON_USER" "$FLUENTD_DAEMON_GROUP"
    ensure_dir_exists "$FLUENTD_LOG_DIR" "$FLUENTD_DAEMON_USER"
    ensure_dir_exists "$FLUENTD_PLUGINS_DIR" "$FLUENTD_DAEMON_USER"
fi
