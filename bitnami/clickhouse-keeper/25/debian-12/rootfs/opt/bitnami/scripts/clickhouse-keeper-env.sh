#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for clickhouse-keeper

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
export MODULE="${MODULE:-clickhouse-keeper}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
clickhouse_keeper_env_vars=(
    CLICKHOUSE_KEEPER_SKIP_SETUP
    CLICKHOUSE_KEEPER_SERVER_ID
    CLICKHOUSE_KEEPER_TCP_PORT
    CLICKHOUSE_KEEPER_RAFT_PORT
)
for env_var in "${clickhouse_keeper_env_vars[@]}"; do
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
unset clickhouse_keeper_env_vars

# Paths
export CLICKHOUSE_KEEPER_BASE_DIR="${BITNAMI_ROOT_DIR}/clickhouse-keeper"
export CLICKHOUSE_KEEPER_VOLUME_DIR="/bitnami/clickhouse-keeper"
export CLICKHOUSE_KEEPER_CONF_DIR="${CLICKHOUSE_KEEPER_BASE_DIR}/etc"
export CLICKHOUSE_KEEPER_DEFAULT_CONF_DIR="${CLICKHOUSE_KEEPER_BASE_DIR}/etc.default"
export CLICKHOUSE_KEEPER_MOUNTED_CONF_DIR="${CLICKHOUSE_KEEPER_VOLUME_DIR}/etc"
export CLICKHOUSE_KEEPER_CONF_FILE="${CLICKHOUSE_KEEPER_CONF_DIR}/keeper_config.xml"
export CLICKHOUSE_KEEPER_DATA_DIR="${CLICKHOUSE_KEEPER_VOLUME_DIR}/coordination"
export CLICKHOUSE_KEEPER_COORD_LOGS_DIR="${CLICKHOUSE_KEEPER_DATA_DIR}/logs"
export CLICKHOUSE_KEEPER_COORD_SNAPSHOTS_DIR="${CLICKHOUSE_KEEPER_DATA_DIR}/snapshots"
export CLICKHOUSE_KEEPER_LOG_DIR="${CLICKHOUSE_KEEPER_BASE_DIR}/logs"
export CLICKHOUSE_KEEPER_LOG_FILE="${CLICKHOUSE_KEEPER_LOG_DIR}/clickhouse-keeper.log"
export CLICKHOUSE_KEEPER_ERROR_LOG_FILE="${CLICKHOUSE_KEEPER_LOG_DIR}/clickhouse-keeper.err.log"
export CLICKHOUSE_KEEPER_TMP_DIR="${CLICKHOUSE_KEEPER_BASE_DIR}/tmp"
export CLICKHOUSE_KEEPER_PID_FILE="${CLICKHOUSE_KEEPER_TMP_DIR}/clickhouse-keeper.pid"

# ClickHouse Keeper configuration parameters
export CLICKHOUSE_KEEPER_SKIP_SETUP="${CLICKHOUSE_KEEPER_SKIP_SETUP:-no}"
export CLICKHOUSE_KEEPER_SERVER_ID="${CLICKHOUSE_KEEPER_SERVER_ID:-}"
export CLICKHOUSE_KEEPER_TCP_PORT="${CLICKHOUSE_KEEPER_TCP_PORT:-9181}"
export CLICKHOUSE_KEEPER_RAFT_PORT="${CLICKHOUSE_KEEPER_RAFT_PORT:-9234}"

# ClickHouse system parameters
export CLICKHOUSE_DAEMON_USER="clickhouse"
export CLICKHOUSE_DAEMON_GROUP="clickhouse"
export PATH="${CLICKHOUSE_KEEPER_BASE_DIR}/bin:${BITNAMI_ROOT_DIR}/common/bin:$PATH"

# Custom environment variables may be defined below
