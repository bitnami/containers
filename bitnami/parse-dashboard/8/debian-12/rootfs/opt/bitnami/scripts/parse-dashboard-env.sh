#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for parse-dashboard

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
export MODULE="${MODULE:-parse-dashboard}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
parse_dashboard_env_vars=(
    PARSE_DASHBOARD_FORCE_OVERWRITE_CONF_FILE
    PARSE_DASHBOARD_ENABLE_HTTPS
    PARSE_DASHBOARD_EXTERNAL_HTTP_PORT_NUMBER
    PARSE_DASHBOARD_EXTERNAL_HTTPS_PORT_NUMBER
    PARSE_DASHBOARD_PARSE_HOST
    PARSE_DASHBOARD_PORT_NUMBER
    PARSE_DASHBOARD_PARSE_PORT_NUMBER
    PARSE_DASHBOARD_PARSE_APP_ID
    PARSE_DASHBOARD_APP_NAME
    PARSE_DASHBOARD_PARSE_MASTER_KEY
    PARSE_DASHBOARD_PARSE_MOUNT_PATH
    PARSE_DASHBOARD_PARSE_PROTOCOL
    PARSE_DASHBOARD_USERNAME
    PARSE_DASHBOARD_PASSWORD
    PARSE_HOST
    PARSE_PORT_NUMBER
    PARSE_APP_ID
    PARSE_MASTER_KEY
    PARSE_MOUNT_PATH
    PARSE_PROTOCOL
    PARSE_DASHBOARD_USER
)
for env_var in "${parse_dashboard_env_vars[@]}"; do
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
unset parse_dashboard_env_vars

# Paths
export PARSE_DASHBOARD_BASE_DIR="${BITNAMI_ROOT_DIR}/parse-dashboard"
export PARSE_DASHBOARD_TMP_DIR="${PARSE_DASHBOARD_BASE_DIR}/tmp"
export PARSE_DASHBOARD_LOGS_DIR="${PARSE_DASHBOARD_BASE_DIR}/logs"
export PARSE_DASHBOARD_PID_FILE="${PARSE_DASHBOARD_TMP_DIR}/parse-dashboard.pid"
export PARSE_DASHBOARD_LOG_FILE="${PARSE_DASHBOARD_LOGS_DIR}/parse-dashboard.log"
export PARSE_DASHBOARD_CONF_FILE="${PARSE_DASHBOARD_BASE_DIR}/config.json"
export PARSE_DASHBOARD_FORCE_OVERWRITE_CONF_FILE="${PARSE_DASHBOARD_FORCE_OVERWRITE_CONF_FILE:-no}"

# Parse persistence configuration
export PARSE_DASHBOARD_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/parse-dashboard"

# System users (when running with a privileged user)
export PARSE_DASHBOARD_DAEMON_USER="parsedashboard"
export PARSE_DASHBOARD_DAEMON_GROUP="parsedashboard"

# Parse configuration
export PARSE_DASHBOARD_ENABLE_HTTPS="${PARSE_DASHBOARD_ENABLE_HTTPS:-no}"
export PARSE_DASHBOARD_EXTERNAL_HTTP_PORT_NUMBER="${PARSE_DASHBOARD_EXTERNAL_HTTP_PORT_NUMBER:-80}" # only used during the first initialization
export PARSE_DASHBOARD_EXTERNAL_HTTPS_PORT_NUMBER="${PARSE_DASHBOARD_EXTERNAL_HTTPS_PORT_NUMBER:-443}" # only used during the first initialization
PARSE_DASHBOARD_PARSE_HOST="${PARSE_DASHBOARD_PARSE_HOST:-"${PARSE_HOST:-}"}"
export PARSE_DASHBOARD_PARSE_HOST="${PARSE_DASHBOARD_PARSE_HOST:-parse}"
export PARSE_DASHBOARD_PORT_NUMBER="${PARSE_DASHBOARD_PORT_NUMBER:-4040}"
PARSE_DASHBOARD_PARSE_PORT_NUMBER="${PARSE_DASHBOARD_PARSE_PORT_NUMBER:-"${PARSE_PORT_NUMBER:-}"}"
export PARSE_DASHBOARD_PARSE_PORT_NUMBER="${PARSE_DASHBOARD_PARSE_PORT_NUMBER:-1337}"
PARSE_DASHBOARD_PARSE_APP_ID="${PARSE_DASHBOARD_PARSE_APP_ID:-"${PARSE_APP_ID:-}"}"
export PARSE_DASHBOARD_PARSE_APP_ID="${PARSE_DASHBOARD_PARSE_APP_ID:-myappID}"
export PARSE_DASHBOARD_APP_NAME="${PARSE_DASHBOARD_APP_NAME:-MyDashboard}"
PARSE_DASHBOARD_PARSE_MASTER_KEY="${PARSE_DASHBOARD_PARSE_MASTER_KEY:-"${PARSE_MASTER_KEY:-}"}"
export PARSE_DASHBOARD_PARSE_MASTER_KEY="${PARSE_DASHBOARD_PARSE_MASTER_KEY:-mymasterKey}"
PARSE_DASHBOARD_PARSE_MOUNT_PATH="${PARSE_DASHBOARD_PARSE_MOUNT_PATH:-"${PARSE_MOUNT_PATH:-}"}"
export PARSE_DASHBOARD_PARSE_MOUNT_PATH="${PARSE_DASHBOARD_PARSE_MOUNT_PATH:-/parse}"
PARSE_DASHBOARD_PARSE_PROTOCOL="${PARSE_DASHBOARD_PARSE_PROTOCOL:-"${PARSE_PROTOCOL:-}"}"
export PARSE_DASHBOARD_PARSE_PROTOCOL="${PARSE_DASHBOARD_PARSE_PROTOCOL:-http}"

# Parse credentials
PARSE_DASHBOARD_USERNAME="${PARSE_DASHBOARD_USERNAME:-"${PARSE_DASHBOARD_USER:-}"}"
export PARSE_DASHBOARD_USERNAME="${PARSE_DASHBOARD_USERNAME:-user}"
export PARSE_DASHBOARD_PASSWORD="${PARSE_DASHBOARD_PASSWORD:-bitnami}"

# Custom environment variables may be defined below
