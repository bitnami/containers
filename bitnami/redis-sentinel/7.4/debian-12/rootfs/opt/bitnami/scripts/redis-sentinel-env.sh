#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for redis-sentinel

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
export MODULE="${MODULE:-redis-sentinel}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
redis_sentinel_env_vars=(
    REDIS_SENTINEL_DATA_DIR
    REDIS_SENTINEL_DISABLE_COMMANDS
    REDIS_SENTINEL_DATABASE
    REDIS_SENTINEL_AOF_ENABLED
    REDIS_SENTINEL_HOST
    REDIS_SENTINEL_MASTER_NAME
    REDIS_SENTINEL_PORT_NUMBER
    REDIS_SENTINEL_QUORUM
    REDIS_SENTINEL_DOWN_AFTER_MILLISECONDS
    REDIS_SENTINEL_FAILOVER_TIMEOUT
    REDIS_SENTINEL_MASTER_REBOOT_DOWN_AFTER_PERIOD
    REDIS_SENTINEL_RESOLVE_HOSTNAMES
    REDIS_SENTINEL_ANNOUNCE_HOSTNAMES
    ALLOW_EMPTY_PASSWORD
    REDIS_SENTINEL_PASSWORD
    REDIS_MASTER_USER
    REDIS_MASTER_PASSWORD
    REDIS_SENTINEL_ANNOUNCE_IP
    REDIS_SENTINEL_ANNOUNCE_PORT
    REDIS_SENTINEL_TLS_ENABLED
    REDIS_SENTINEL_TLS_PORT_NUMBER
    REDIS_SENTINEL_TLS_CERT_FILE
    REDIS_SENTINEL_TLS_KEY_FILE
    REDIS_SENTINEL_TLS_CA_FILE
    REDIS_SENTINEL_TLS_DH_PARAMS_FILE
    REDIS_SENTINEL_TLS_AUTH_CLIENTS
    REDIS_MASTER_HOST
    REDIS_MASTER_PORT_NUMBER
    REDIS_MASTER_SET
)
for env_var in "${redis_sentinel_env_vars[@]}"; do
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
unset redis_sentinel_env_vars

# Paths
export REDIS_SENTINEL_VOLUME_DIR="/bitnami/redis-sentinel"
export REDIS_SENTINEL_BASE_DIR="${BITNAMI_ROOT_DIR}/redis-sentinel"
export REDIS_SENTINEL_CONF_DIR="${REDIS_SENTINEL_BASE_DIR}/etc"
export REDIS_SENTINEL_DEFAULT_CONF_DIR="${REDIS_SENTINEL_BASE_DIR}/etc.default"
export REDIS_SENTINEL_DATA_DIR="${REDIS_SENTINEL_DATA_DIR:-${REDIS_SENTINEL_VOLUME_DIR}/data}"
export REDIS_SENTINEL_MOUNTED_CONF_DIR="${REDIS_SENTINEL_BASE_DIR}/mounted-etc"
export REDIS_SENTINEL_CONF_FILE="${REDIS_SENTINEL_CONF_DIR}/sentinel.conf"
export REDIS_SENTINEL_LOG_DIR="${REDIS_SENTINEL_BASE_DIR}/logs"
export REDIS_SENTINEL_TMP_DIR="${REDIS_SENTINEL_BASE_DIR}/tmp"
export REDIS_SENTINEL_PID_FILE="${REDIS_SENTINEL_TMP_DIR}/redis-sentinel.pid"
export REDIS_SENTINEL_BIN_DIR="${REDIS_SENTINEL_BASE_DIR}/bin"
export PATH="${REDIS_SENTINEL_BIN_DIR}:${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# System users (when running with a privileged user)
export REDIS_SENTINEL_DAEMON_USER="redis"
export REDIS_SENTINEL_DAEMON_GROUP="redis"

# Redis Sentinel settings
export REDIS_SENTINEL_DISABLE_COMMANDS="${REDIS_SENTINEL_DISABLE_COMMANDS:-}"
export REDIS_SENTINEL_DATABASE="${REDIS_SENTINEL_DATABASE:-redis}"
export REDIS_SENTINEL_AOF_ENABLED="${REDIS_SENTINEL_AOF_ENABLED:-yes}"
export REDIS_SENTINEL_HOST="${REDIS_SENTINEL_HOST:-}"
export REDIS_SENTINEL_MASTER_NAME="${REDIS_SENTINEL_MASTER_NAME:-}"
export REDIS_SENTINEL_DEFAULT_PORT_NUMBER="26379" # only used at build time
export REDIS_SENTINEL_PORT_NUMBER="${REDIS_SENTINEL_PORT_NUMBER:-$REDIS_SENTINEL_DEFAULT_PORT_NUMBER}"
export REDIS_SENTINEL_QUORUM="${REDIS_SENTINEL_QUORUM:-2}"
export REDIS_SENTINEL_DOWN_AFTER_MILLISECONDS="${REDIS_SENTINEL_DOWN_AFTER_MILLISECONDS:-60000}"
export REDIS_SENTINEL_FAILOVER_TIMEOUT="${REDIS_SENTINEL_FAILOVER_TIMEOUT:-180000}"
export REDIS_SENTINEL_MASTER_REBOOT_DOWN_AFTER_PERIOD="${REDIS_SENTINEL_MASTER_REBOOT_DOWN_AFTER_PERIOD:-0}"
export REDIS_SENTINEL_RESOLVE_HOSTNAMES="${REDIS_SENTINEL_RESOLVE_HOSTNAMES:-yes}"
export REDIS_SENTINEL_ANNOUNCE_HOSTNAMES="${REDIS_SENTINEL_ANNOUNCE_HOSTNAMES:-no}"
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"
export REDIS_SENTINEL_PASSWORD="${REDIS_SENTINEL_PASSWORD:-}"
export REDIS_MASTER_USER="${REDIS_MASTER_USER:-}"
export REDIS_MASTER_PASSWORD="${REDIS_MASTER_PASSWORD:-}"
export REDIS_SENTINEL_ANNOUNCE_IP="${REDIS_SENTINEL_ANNOUNCE_IP:-}"
export REDIS_SENTINEL_ANNOUNCE_PORT="${REDIS_SENTINEL_ANNOUNCE_PORT:-}"

# TLS settings
export REDIS_SENTINEL_TLS_ENABLED="${REDIS_SENTINEL_TLS_ENABLED:-no}"
export REDIS_SENTINEL_TLS_PORT_NUMBER="${REDIS_SENTINEL_TLS_PORT_NUMBER:-26379}"
export REDIS_SENTINEL_TLS_CERT_FILE="${REDIS_SENTINEL_TLS_CERT_FILE:-}"
export REDIS_SENTINEL_TLS_KEY_FILE="${REDIS_SENTINEL_TLS_KEY_FILE:-}"
export REDIS_SENTINEL_TLS_CA_FILE="${REDIS_SENTINEL_TLS_CA_FILE:-}"
export REDIS_SENTINEL_TLS_DH_PARAMS_FILE="${REDIS_SENTINEL_TLS_DH_PARAMS_FILE:-}"
export REDIS_SENTINEL_TLS_AUTH_CLIENTS="${REDIS_SENTINEL_TLS_AUTH_CLIENTS:-yes}"

# Redis Master settings
export REDIS_MASTER_HOST="${REDIS_MASTER_HOST:-redis}"
export REDIS_MASTER_PORT_NUMBER="${REDIS_MASTER_PORT_NUMBER:-6379}"
export REDIS_MASTER_SET="${REDIS_MASTER_SET:-mymaster}"

# Custom environment variables may be defined below
