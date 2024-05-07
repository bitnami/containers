#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Fluentd library

# shellcheck disable=SC1090,SC1091

########################
# Load global variables used on Fluentd configuration.
# Globals:
#   FLUENTD_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
fluentd_env() {
    cat <<"EOF"
# Bitnami debug
export MODULE=fluentd
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# Paths
export FLUENTD_BASE_DIR="/opt/bitnami/fluentd"
export FLUENTD_BIN_DIR="${FLUENTD_BASE_DIR}/bin"
export FLUENTD_CONF_DIR="${FLUENTD_BASE_DIR}/conf"
export FLUENTD_LOG_DIR="${FLUENTD_BASE_DIR}/logs"
export FLUENTD_PLUGINS_DIR="${FLUENTD_BASE_DIR}/plugins"
export FLUENTD_INITSCRIPTS_DIR="/docker-entrypoint-initdb.d"

# Users
export FLUENTD_DAEMON_USER="${FLUENTD_DAEMON_USER:-fluentd}"
export FLUENTD_DAEMON_GROUP="${FLUENTD_DAEMON_GROUP:-fluentd}"

# Configuration
export FLUENTD_CONF="${FLUENTD_CONF:-}"
export FLUENTD_OPT="${FLUENTD_OPT:-}"
EOF
}

########################
# Run custom initialization scripts
# Globals:
#   FLUENTD_*
# Arguments:
#   None
# Returns:
#   None
#########################
fluentd_custom_init_scripts() {
    if [[ -n $(find "${FLUENTD_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh") ]]; then
        info "Loading user's custom files from $FLUENTD_INITSCRIPTS_DIR ..."
        local -r tmp_file="/tmp/filelist"
        find "${FLUENTD_INITSCRIPTS_DIR}/" -type f -regex ".*\.sh" | sort >"$tmp_file"
        while read -r f; do
            case "$f" in
            *.sh)
                if [[ -x "$f" ]]; then
                    debug "Executing $f"
                    "$f"
                else
                    debug "Sourcing $f"
                    . "$f"
                fi
                ;;
            *)
                debug "Ignoring $f"
                ;;
            esac
        done <$tmp_file
        rm -f "$tmp_file"
    else
        info "No custom scripts in $FLUENTD_INITSCRIPTS_DIR"
    fi
}
