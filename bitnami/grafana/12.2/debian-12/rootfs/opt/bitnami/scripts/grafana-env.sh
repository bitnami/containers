#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for grafana

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

# Load logging library
# shellcheck disable=SC1090,SC1091
. /opt/bitnami/scripts/liblog.sh

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-grafana}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
grafana_env_vars=(
    GRAFANA_TMP_DIR
    GRAFANA_PID_FILE
    GRAFANA_DEFAULT_CONF_DIR
    GRAFANA_DEFAULT_PLUGINS_DIR
    GF_PATHS_HOME
    GF_PATHS_CONFIG
    GF_PATHS_DATA
    GF_PATHS_LOGS
    GF_PATHS_PLUGINS
    GF_PATHS_PROVISIONING
    GF_INSTALL_PLUGINS
    GF_INSTALL_PLUGINS_SKIP_TLS
    GF_FEATURE_TOGGLES
    GF_SECURITY_ADMIN_PASSWORD
    GRAFANA_MIGRATION_LOCK
    GRAFANA_SLEEP_TIME
    GRAFANA_RETRY_ATTEMPTS
    GRAFANA_PLUGINS
)
for env_var in "${grafana_env_vars[@]}"; do
    file_env_var="${env_var}_FILE"
    if [[ -n "${!file_env_var:-}" ]]; then
        if [[ -r "${!file_env_var:-}" ]]; then
            export "${env_var}=$(< "${!file_env_var}")"
            unset "${file_env_var}"
        else
            warn "Skipping export of '${env_var}'. '${!file_env_var:-}' is not readable."
        fi
    fi
done
unset grafana_env_vars

# Grafana paths
export GRAFANA_BASE_DIR="${BITNAMI_ROOT_DIR}/grafana"
export GRAFANA_BIN_DIR="${GRAFANA_BASE_DIR}/bin"
export GRAFANA_TMP_DIR="${GRAFANA_TMP_DIR:-${GRAFANA_BASE_DIR}/tmp}"
export GRAFANA_CONF_DIR="${GRAFANA_BASE_DIR}/conf"
export GRAFANA_PID_FILE="${GRAFANA_PID_FILE:-${GRAFANA_TMP_DIR}/grafana.pid}"
export PATH="${GRAFANA_BIN_DIR}:${BITNAMI_ROOT_DIR}/common/bin:${PATH}"
export GRAFANA_DEFAULT_CONF_DIR="${GRAFANA_DEFAULT_CONF_DIR:-${GRAFANA_BASE_DIR}/conf.default}"
export GRAFANA_DEFAULT_PLUGINS_DIR="${GRAFANA_DEFAULT_PLUGINS_DIR:-${GRAFANA_BASE_DIR}/default-plugins}"

# System users (when running with a privileged user)
export GRAFANA_DAEMON_USER="grafana"
export GRAFANA_DAEMON_GROUP="grafana"

# Grafana configuration
export GF_PATHS_HOME="${GF_PATHS_HOME:-$GRAFANA_BASE_DIR}"
export GF_PATHS_CONFIG="${GF_PATHS_CONFIG:-${GRAFANA_BASE_DIR}/conf/grafana.ini}"
export GF_PATHS_DATA="${GF_PATHS_DATA:-${GRAFANA_BASE_DIR}/data}"
export GF_PATHS_LOGS="${GF_PATHS_LOGS:-${GRAFANA_BASE_DIR}/logs}"
export GF_PATHS_PLUGINS="${GF_PATHS_PLUGINS:-${GF_PATHS_DATA}/plugins}"
export GF_PATHS_PROVISIONING="${GF_PATHS_PROVISIONING:-${GRAFANA_BASE_DIR}/conf/provisioning}"
GF_INSTALL_PLUGINS="${GF_INSTALL_PLUGINS:-"${GRAFANA_PLUGINS:-}"}"
export GF_INSTALL_PLUGINS="${GF_INSTALL_PLUGINS:-}"
export GF_INSTALL_PLUGINS_SKIP_TLS="${GF_INSTALL_PLUGINS_SKIP_TLS:-yes}"
export GF_FEATURE_TOGGLES="${GF_FEATURE_TOGGLES:-}"
export GF_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/grafana"
export GF_SECURITY_ADMIN_PASSWORD="${GF_SECURITY_ADMIN_PASSWORD:-}"
export GRAFANA_MIGRATION_LOCK="${GRAFANA_MIGRATION_LOCK:-false}"
export GRAFANA_SLEEP_TIME="${GRAFANA_SLEEP_TIME:-10}"
export GRAFANA_RETRY_ATTEMPTS="${GRAFANA_RETRY_ATTEMPTS:-12}"

# Grafana Operator configuration
export GF_OP_PATHS_CONFIG="/etc/grafana/grafana.ini"
export GF_OP_PATHS_DATA="/var/lib/grafana"
export GF_OP_PATHS_LOGS="/var/log/grafana"
export GF_OP_PATHS_PROVISIONING="/etc/grafana/provisioning"
export GF_OP_PLUGINS_INIT_DIR="/opt/plugins"

# Custom environment variables may be defined below
