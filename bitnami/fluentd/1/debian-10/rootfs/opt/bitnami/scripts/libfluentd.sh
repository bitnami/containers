#!/bin/bash
#
# Bitnami Fluentd library

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

# Users
export FLUENTD_DAEMON_USER="${FLUENTD_DAEMON_USER:-fluentd}"
export FLUENTD_DAEMON_GROUP="${FLUENTD_DAEMON_GROUP:-fluentd}"

# Configuration
export FLUENTD_CONF="${FLUENTD_CONF:-}"
export FLUENTD_OPT="${FLUENTD_OPT:-}"
EOF
}
