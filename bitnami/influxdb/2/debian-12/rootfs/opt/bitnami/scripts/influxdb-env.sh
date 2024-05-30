#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for influxdb

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
export MODULE="${MODULE:-influxdb}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
influxdb_env_vars=(
    INFLUXDB_DATA_DIR
    INFLUXDB_DATA_WAL_DIR
    INFLUXDB_META_DIR
    INFLUXD_CONFIG_PATH
    INFLUXDB_REPORTING_DISABLED
    INFLUXDB_HTTP_PORT_NUMBER
    INFLUXDB_HTTP_BIND_ADDRESS
    INFLUXDB_HTTP_READINESS_TIMEOUT
    INFLUXDB_PORT_NUMBER
    INFLUXDB_BIND_ADDRESS
    INFLUXDB_PORT_READINESS_TIMEOUT
    INFLUXDB_INIT_MODE
    INFLUXDB_INIT_V1_DIR
    INFLUXDB_INIT_V1_CONFIG
    INFLUXDB_UPGRADE_LOG_FILE
    INFLUXDB_CONTINUOUS_QUERY_EXPORT_FILE
    INFLUXDB_HTTP_AUTH_ENABLED
    INFLUXDB_ADMIN_USER
    INFLUXDB_ADMIN_USER_PASSWORD
    INFLUXDB_ADMIN_USER_TOKEN
    INFLUXDB_ADMIN_CONFIG_NAME
    INFLUXDB_ADMIN_ORG
    INFLUXDB_ADMIN_BUCKET
    INFLUXDB_ADMIN_RETENTION
    INFLUXDB_USER
    INFLUXDB_USER_PASSWORD
    INFLUXDB_USER_ORG
    INFLUXDB_USER_BUCKET
    INFLUXDB_CREATE_USER_TOKEN
    INFLUXDB_READ_USER
    INFLUXDB_READ_USER_PASSWORD
    INFLUXDB_WRITE_USER
    INFLUXDB_WRITE_USER_PASSWORD
    INFLUXDB_DB
)
for env_var in "${influxdb_env_vars[@]}"; do
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
unset influxdb_env_vars

# Paths
export INFLUXDB_BASE_DIR="${BITNAMI_ROOT_DIR}/influxdb"
export INFLUXDB_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/influxdb"
export INFLUXDB_BIN_DIR="${INFLUXDB_BASE_DIR}/bin"
export INFLUXDB_DATA_DIR="${INFLUXDB_DATA_DIR:-${INFLUXDB_VOLUME_DIR}/data}"
export INFLUXDB_DATA_WAL_DIR="${INFLUXDB_DATA_WAL_DIR:-${INFLUXDB_VOLUME_DIR}/wal}"
export INFLUXDB_META_DIR="${INFLUXDB_META_DIR:-${INFLUXDB_VOLUME_DIR}/meta}"
export INFLUXDB_CONF_DIR="${INFLUXDB_BASE_DIR}/etc"
export INFLUXDB_DEFAULT_CONF_DIR="${INFLUXDB_BASE_DIR}/etc.default"
export INFLUXDB_CONF_FILE="${INFLUXDB_CONF_DIR}/config.yaml"
export INFLUXDB_INITSCRIPTS_DIR="/docker-entrypoint-initdb.d"

# InfluxDB 2.x aliases
export INFLUXD_ENGINE_PATH="${INFLUXDB_VOLUME_DIR}"
export INFLUXD_BOLT_PATH="${INFLUXDB_VOLUME_DIR}/influxd.bolt"
export INFLUXD_CONFIG_PATH="${INFLUXD_CONFIG_PATH:-${INFLUXDB_CONF_DIR}}"
export INFLUX_CONFIGS_PATH="${INFLUXDB_VOLUME_DIR}/configs"

# System users (when running with a privileged user)
export INFLUXDB_DAEMON_USER="influxdb"
export INFLUXDB_DAEMON_GROUP="influxdb"

# InfluxDB server settings
export INFLUXDB_REPORTING_DISABLED="${INFLUXDB_REPORTING_DISABLED:-true}"
export INFLUXDB_HTTP_PORT_NUMBER="${INFLUXDB_HTTP_PORT_NUMBER:-8086}"
export INFLUXDB_HTTP_BIND_ADDRESS="${INFLUXDB_HTTP_BIND_ADDRESS:-0.0.0.0:${INFLUXDB_HTTP_PORT_NUMBER}}"
export INFLUXD_HTTP_BIND_ADDRESS="$INFLUXDB_HTTP_BIND_ADDRESS"
export INFLUXDB_HTTP_READINESS_TIMEOUT="${INFLUXDB_HTTP_READINESS_TIMEOUT:-60}"
export INFLUXDB_PORT_NUMBER="${INFLUXDB_PORT_NUMBER:-8088}"
export INFLUXDB_BIND_ADDRESS="${INFLUXDB_BIND_ADDRESS:-0.0.0.0:${INFLUXDB_PORT_NUMBER}}"
export INFLUXDB_PORT_READINESS_TIMEOUT="${INFLUXDB_PORT_READINESS_TIMEOUT:-30}"
export INFLUXDB_INIT_MODE="${INFLUXDB_INIT_MODE:-setup}"
export INFLUXDB_INIT_V1_DIR="${INFLUXDB_INIT_V1_DIR:-${BITNAMI_VOLUME_DIR}/v1}"
export INFLUXDB_INIT_V1_CONFIG="${INFLUXDB_INIT_V1_CONFIG:-${BITNAMI_VOLUME_DIR}/v1/config.yaml}"
export INFLUXDB_UPGRADE_LOG_FILE="${INFLUXDB_UPGRADE_LOG_FILE:-${INFLUXDB_INIT_V1_DIR}/upgrade.log}"
export INFLUXDB_CONTINUOUS_QUERY_EXPORT_FILE="${INFLUXDB_CONTINUOUS_QUERY_EXPORT_FILE:-${INFLUXDB_INIT_V1_DIR}/v1-cq-export.txt}"

# InfluxDB auth settings
export INFLUXDB_HTTP_AUTH_ENABLED="${INFLUXDB_HTTP_AUTH_ENABLED:-true}"
export INFLUXDB_ADMIN_USER="${INFLUXDB_ADMIN_USER:-admin}"
export INFLUXDB_ADMIN_USER_PASSWORD="${INFLUXDB_ADMIN_USER_PASSWORD:-}"
export INFLUXDB_ADMIN_USER_TOKEN="${INFLUXDB_ADMIN_USER_TOKEN:-}"
export INFLUXDB_ADMIN_CONFIG_NAME="${INFLUXDB_ADMIN_CONFIG_NAME:-default}"
export INFLUXDB_ADMIN_ORG="${INFLUXDB_ADMIN_ORG:-primary}"
export INFLUXDB_ADMIN_BUCKET="${INFLUXDB_ADMIN_BUCKET:-primary}"
export INFLUXDB_ADMIN_RETENTION="${INFLUXDB_ADMIN_RETENTION:-0}"
export INFLUXDB_USER="${INFLUXDB_USER:-}"
export INFLUXDB_USER_PASSWORD="${INFLUXDB_USER_PASSWORD:-}"
export INFLUXDB_USER_ORG="${INFLUXDB_USER_ORG:-${INFLUXDB_ADMIN_ORG}}"
export INFLUXDB_USER_BUCKET="${INFLUXDB_USER_BUCKET:-}"
export INFLUXDB_CREATE_USER_TOKEN="${INFLUXDB_CREATE_USER_TOKEN:-no}"
export INFLUXDB_READ_USER="${INFLUXDB_READ_USER:-}"
export INFLUXDB_READ_USER_PASSWORD="${INFLUXDB_READ_USER_PASSWORD:-}"
export INFLUXDB_WRITE_USER="${INFLUXDB_WRITE_USER:-}"
export INFLUXDB_WRITE_USER_PASSWORD="${INFLUXDB_WRITE_USER_PASSWORD:-}"
export INFLUXDB_DB="${INFLUXDB_DB:-}"

# Custom environment variables may be defined below
