#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /libos.sh
. /libfluentd.sh

# Load Fluentd environment
eval "$(fluentd_env)"

# Ensure fluentd user and group exist when running as 'root'
if am_i_root; then
    ensure_user_exists "$FLUENTD_DAEMON_USER" "$FLUENTD_DAEMON_GROUP"
    chown -R "$FLUENTD_DAEMON_USER" "$FLUENTD_BASE_DIR";
fi
