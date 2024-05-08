#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for appsmith

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
export MODULE="${MODULE:-appsmith}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
appsmith_env_vars=(
    ALLOW_EMPTY_PASSWORD
    APPSMITH_USERNAME
    APPSMITH_PASSWORD
    APPSMITH_EMAIL
    APPSMITH_MODE
    APPSMITH_ENCRYPTION_PASSWORD
    APPSMITH_ENCRYPTION_SALT
    APPSMITH_API_HOST
    APPSMITH_API_PORT
    APPSMITH_UI_HTTP_PORT
    APPSMITH_UI_HTTPS_PORT
    APPSMITH_RTS_HOST
    APPSMITH_RTS_PORT
    APPSMITH_DATABASE_HOST
    APPSMITH_DATABASE_PORT_NUMBER
    APPSMITH_DATABASE_NAME
    APPSMITH_DATABASE_USER
    APPSMITH_DATABASE_PASSWORD
    APPSMITH_DATABASE_INIT_DELAY
    APPSMITH_REDIS_HOST
    APPSMITH_REDIS_PORT_NUMBER
    APPSMITH_REDIS_PASSWORD
    APPSMITH_STARTUP_TIMEOUT
    APPSMITH_STARTUP_ATTEMPTS
    APPSMITH_DATA_TO_PERSIST
    MONGODB_HOST
    MONGODB_PORT_NUMBER
    MONGODB_DATABASE_NAME
    MONGODB_DATABASE_USER
    MONGODB_DATABASE_PASSWORD
    REDIS_HOST
    REDIS_PORT_NUMBER
    REDIS_PASSWORD
)
for env_var in "${appsmith_env_vars[@]}"; do
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
unset appsmith_env_vars

# Paths
export APPSMITH_BASE_DIR="${BITNAMI_ROOT_DIR}/appsmith"
export APPSMITH_VOLUME_DIR="/bitnami/appsmith"
export APPSMITH_LOG_DIR="${APPSMITH_BASE_DIR}/logs"
export APPSMITH_LOG_FILE="${APPSMITH_LOG_DIR}/appsmith.log"
export APPSMITH_CONF_DIR="${APPSMITH_BASE_DIR}/conf"
export APPSMITH_DEFAULT_CONF_DIR="${APPSMITH_BASE_DIR}/conf.default"
export APPSMITH_CONF_FILE="${APPSMITH_CONF_DIR}/docker.env"
export APPSMITH_TMP_DIR="${APPSMITH_BASE_DIR}/tmp"
export APPSMITH_PID_FILE="${APPSMITH_TMP_DIR}/appsmith.pid"

# Appsmith configuration parameters
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"
export APPSMITH_USERNAME="${APPSMITH_USERNAME:-user}" # only used during the first initialization
export APPSMITH_PASSWORD="${APPSMITH_PASSWORD:-bitnami123}" # only used during the first initialization
export APPSMITH_EMAIL="${APPSMITH_EMAIL:-user@example.com}" # only used during the first initialization
export APPSMITH_MODE="${APPSMITH_MODE:-backend}"
export APPSMITH_ENCRYPTION_PASSWORD="${APPSMITH_ENCRYPTION_PASSWORD:-bitnami123}" # only used during the first initialization
export APPSMITH_ENCRYPTION_SALT="${APPSMITH_ENCRYPTION_SALT:-}"
export APPSMITH_API_HOST="${APPSMITH_API_HOST:-appsmith-api}"
export APPSMITH_API_PORT="${APPSMITH_API_PORT:-8080}"
export APPSMITH_UI_HTTP_PORT="${APPSMITH_UI_HTTP_PORT:-8080}"
export APPSMITH_UI_HTTPS_PORT="${APPSMITH_UI_HTTPS_PORT:-8443}"
export APPSMITH_RTS_HOST="${APPSMITH_RTS_HOST:-appsmith-rts}"
export APPSMITH_RTS_PORT="${APPSMITH_RTS_PORT:-8091}"
APPSMITH_DATABASE_HOST="${APPSMITH_DATABASE_HOST:-"${MONGODB_HOST:-}"}"
export APPSMITH_DATABASE_HOST="${APPSMITH_DATABASE_HOST:-mongodb}" # only used during the first initialization
APPSMITH_DATABASE_PORT_NUMBER="${APPSMITH_DATABASE_PORT_NUMBER:-"${MONGODB_PORT_NUMBER:-}"}"
export APPSMITH_DATABASE_PORT_NUMBER="${APPSMITH_DATABASE_PORT_NUMBER:-27017}" # only used during the first initialization
APPSMITH_DATABASE_NAME="${APPSMITH_DATABASE_NAME:-"${MONGODB_DATABASE_NAME:-}"}"
export APPSMITH_DATABASE_NAME="${APPSMITH_DATABASE_NAME:-bitnami_appsmith}" # only used during the first initialization
APPSMITH_DATABASE_USER="${APPSMITH_DATABASE_USER:-"${MONGODB_DATABASE_USER:-}"}"
export APPSMITH_DATABASE_USER="${APPSMITH_DATABASE_USER:-bn_appsmith}" # only used during the first initialization
APPSMITH_DATABASE_PASSWORD="${APPSMITH_DATABASE_PASSWORD:-"${MONGODB_DATABASE_PASSWORD:-}"}"
export APPSMITH_DATABASE_PASSWORD="${APPSMITH_DATABASE_PASSWORD:-}" # only used during the first initialization
export APPSMITH_DATABASE_INIT_DELAY="${APPSMITH_DATABASE_INIT_DELAY:-0}"
APPSMITH_REDIS_HOST="${APPSMITH_REDIS_HOST:-"${REDIS_HOST:-}"}"
export APPSMITH_REDIS_HOST="${APPSMITH_REDIS_HOST:-redis}" # only used during the first initialization
APPSMITH_REDIS_PORT_NUMBER="${APPSMITH_REDIS_PORT_NUMBER:-"${REDIS_PORT_NUMBER:-}"}"
export APPSMITH_REDIS_PORT_NUMBER="${APPSMITH_REDIS_PORT_NUMBER:-6379}" # only used during the first initialization
APPSMITH_REDIS_PASSWORD="${APPSMITH_REDIS_PASSWORD:-"${REDIS_PASSWORD:-}"}"
export APPSMITH_REDIS_PASSWORD="${APPSMITH_REDIS_PASSWORD:-}" # only used during the first initialization
export APPSMITH_STARTUP_TIMEOUT="${APPSMITH_STARTUP_TIMEOUT:-120}"
export APPSMITH_STARTUP_ATTEMPTS="${APPSMITH_STARTUP_ATTEMPTS:-5}"
export APPSMITH_DATA_TO_PERSIST="${APPSMITH_DATA_TO_PERSIST:-$APPSMITH_CONF_FILE}"

# Appsmith system parameters
export APPSMITH_DAEMON_USER="appsmith"
export APPSMITH_DAEMON_GROUP="appsmith"

# Custom environment variables may be defined below
