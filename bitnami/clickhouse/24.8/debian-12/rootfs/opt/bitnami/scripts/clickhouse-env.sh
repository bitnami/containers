#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for clickhouse

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
export MODULE="${MODULE:-clickhouse}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
clickhouse_env_vars=(
    ALLOW_EMPTY_PASSWORD
    CLICKHOUSE_ADMIN_USER
    CLICKHOUSE_ADMIN_PASSWORD
    CLICKHOUSE_HTTP_PORT
    CLICKHOUSE_TCP_PORT
    CLICKHOUSE_MYSQL_PORT
    CLICKHOUSE_POSTGRESQL_PORT
    CLICKHOUSE_INTERSERVER_HTTP_PORT
    CLICKHOUSE_USER
    CLICKHOUSE_PASSWORD
)
for env_var in "${clickhouse_env_vars[@]}"; do
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
unset clickhouse_env_vars

# Paths
export CLICKHOUSE_BASE_DIR="${BITNAMI_ROOT_DIR}/clickhouse"
export CLICKHOUSE_VOLUME_DIR="/bitnami/clickhouse"
export CLICKHOUSE_CONF_DIR="${CLICKHOUSE_BASE_DIR}/etc"
export CLICKHOUSE_DEFAULT_CONF_DIR="${CLICKHOUSE_BASE_DIR}/etc.default"
export CLICKHOUSE_MOUNTED_CONF_DIR="${CLICKHOUSE_VOLUME_DIR}/etc"
export CLICKHOUSE_DATA_DIR="${CLICKHOUSE_VOLUME_DIR}/data"
export CLICKHOUSE_LOG_DIR="${CLICKHOUSE_BASE_DIR}/logs"
export CLICKHOUSE_CONF_FILE="${CLICKHOUSE_CONF_DIR}/config.xml"
export CLICKHOUSE_LOG_FILE="${CLICKHOUSE_LOG_DIR}/clickhouse.log"
export CLICKHOUSE_ERROR_LOG_FILE="${CLICKHOUSE_LOG_DIR}/clickhouse_error.log"
export CLICKHOUSE_TMP_DIR="${CLICKHOUSE_BASE_DIR}/tmp"
export CLICKHOUSE_PID_FILE="${CLICKHOUSE_TMP_DIR}/clickhouse.pid"
export CLICKHOUSE_INITSCRIPTS_DIR="/docker-entrypoint-initdb.d"

# ClickHouse configuration parameters
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"
CLICKHOUSE_ADMIN_USER="${CLICKHOUSE_ADMIN_USER:-"${CLICKHOUSE_USER:-}"}"
export CLICKHOUSE_ADMIN_USER="${CLICKHOUSE_ADMIN_USER:-default}"
CLICKHOUSE_ADMIN_PASSWORD="${CLICKHOUSE_ADMIN_PASSWORD:-"${CLICKHOUSE_PASSWORD:-}"}"
export CLICKHOUSE_ADMIN_PASSWORD="${CLICKHOUSE_ADMIN_PASSWORD:-}"
export CLICKHOUSE_HTTP_PORT="${CLICKHOUSE_HTTP_PORT:-8123}"
export CLICKHOUSE_TCP_PORT="${CLICKHOUSE_TCP_PORT:-9000}"
export CLICKHOUSE_MYSQL_PORT="${CLICKHOUSE_MYSQL_PORT:-9004}"
export CLICKHOUSE_POSTGRESQL_PORT="${CLICKHOUSE_POSTGRESQL_PORT:-9005}"
export CLICKHOUSE_INTERSERVER_HTTP_PORT="${CLICKHOUSE_INTERSERVER_HTTP_PORT:-9009}"

# ClickHouse system parameters
export CLICKHOUSE_DAEMON_USER="clickhouse"
export CLICKHOUSE_DAEMON_GROUP="clickhouse"
export PATH="${CLICKHOUSE_BASE_DIR}/bin:${BITNAMI_ROOT_DIR}/common/bin:$PATH"

# Custom environment variables may be defined below
