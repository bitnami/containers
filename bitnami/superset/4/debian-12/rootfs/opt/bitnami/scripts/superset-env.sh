#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for superset

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
export MODULE="${MODULE:-superset}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
superset_env_vars=(
    SUPERSET_CONF_FILE
    SUPERSET_USERNAME
    SUPERSET_PASSWORD
    SUPERSET_FIRSTNAME
    SUPERSET_LASTNAME
    SUPERSET_EMAIL
    SUPERSET_HTTP_PORT_NUMBER
    SUPERSET_WEBSERVER_HOST
    SUPERSET_WEBSERVER_PORT_NUMBER
    SUPERSET_WEBSERVER_ACCESS_LOG_FILE
    SUPERSET_WEBSERVER_ERROR_LOG_FILE
    SUPERSET_WEBSERVER_WORKERS
    SUPERSET_WEBSERVER_WORKER_CLASS
    SUPERSET_WEBSERVER_THREADS
    SUPERSET_WEBSERVER_TIMEOUT
    SUPERSET_WEBSERVER_KEEPALIVE
    SUPERSET_WEBSERVER_MAX_REQUESTS
    SUPERSET_WEBSERVER_MAX_REQUESTS_JITTER
    SUPERSET_WEBSERVER_LIMIT_REQUEST_LINE
    SUPERSET_WEBSERVER_LIMIT_REQUEST_FIELD_SIZE
    FLOWER_BASIC_AUTH
    SUPERSET_DATABASE_DIALECT
    SUPERSET_LOAD_EXAMPLES
    SUPERSET_IMPORT_DATASOURCES
    SUPERSET_SKIP_DATABASE_WAIT
    SUPERSET_DATABASE_HOST
    SUPERSET_DATABASE_PORT_NUMBER
    SUPERSET_DATABASE_NAME
    SUPERSET_DATABASE_USERNAME
    SUPERSET_DATABASE_PASSWORD
    SUPERSET_DATABASE_USE_SSL
    REDIS_HOST
    REDIS_PORT_NUMBER
    REDIS_USER
    REDIS_PASSWORD
    REDIS_CELERY_DATABASE
    REDIS_RESULTS_DATABASE
    REDIS_USE_SSL
    SUPERSET_CONFIG_PATH
)
for env_var in "${superset_env_vars[@]}"; do
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
unset superset_env_vars

# Superset paths
export SUPERSET_BASE_DIR="${BITNAMI_ROOT_DIR}/superset"
export SUPERSET_HOME="${SUPERSET_BASE_DIR}/superset_home"
export SUPERSET_BIN_DIR="${SUPERSET_BASE_DIR}/venv/bin"
export SUPERSET_LOGS_DIR="${SUPERSET_BASE_DIR}/logs"
export SUPERSET_LOG_FILE="${SUPERSET_LOGS_DIR}/superset.log"
SUPERSET_CONF_FILE="${SUPERSET_CONF_FILE:-"${SUPERSET_CONFIG_PATH:-}"}"
export SUPERSET_CONF_FILE="${SUPERSET_CONF_FILE:-${SUPERSET_BASE_DIR}/superset_config.py}"
export SUPERSET_CONFIG_PATH="$SUPERSET_CONF_FILE"
export SUPERSET_TMP_DIR="${SUPERSET_BASE_DIR}/tmp"
export SUPERSET_CELERY_BEAT_PID="${SUPERSET_TMP_DIR}/superset-celerybeat.pid"
export SUPERSET_CELERY_BEAT_SCHEDULE="${SUPERSET_TMP_DIR}/superset-celerybeat-schedule"
export PATH="${SUPERSET_BIN_DIR}:${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# System users (when running with a privileged user)
export SUPERSET_DAEMON_USER="superset"
export SUPERSET_DAEMON_GROUP="superset"

# Superset user configuration
export SUPERSET_USERNAME="${SUPERSET_USERNAME:-user}"
export SUPERSET_PASSWORD="${SUPERSET_PASSWORD:-bitnami}"
export SUPERSET_FIRSTNAME="${SUPERSET_FIRSTNAME:-Firstname}"
export SUPERSET_LASTNAME="${SUPERSET_LASTNAME:-Lastname}"
export SUPERSET_EMAIL="${SUPERSET_EMAIL:-user@example.com}"

# Superset user configuration
export SUPERSET_HTTP_PORT_NUMBER="${SUPERSET_HTTP_PORT_NUMBER:-8080}"

# Superset webserver configuration
export SUPERSET_WEBSERVER_HOST="${SUPERSET_WEBSERVER_HOST:-0.0.0.0}"
export SUPERSET_WEBSERVER_PORT_NUMBER="${SUPERSET_WEBSERVER_PORT_NUMBER:-8080}"
export SUPERSET_WEBSERVER_ACCESS_LOG_FILE="${SUPERSET_WEBSERVER_ACCESS_LOG_FILE:--}"
export SUPERSET_WEBSERVER_ERROR_LOG_FILE="${SUPERSET_WEBSERVER_ERROR_LOG_FILE:--}"
export SUPERSET_WEBSERVER_WORKERS="${SUPERSET_WEBSERVER_WORKERS:-1}"
export SUPERSET_WEBSERVER_WORKER_CLASS="${SUPERSET_WEBSERVER_WORKER_CLASS:-gthread}"
export SUPERSET_WEBSERVER_THREADS="${SUPERSET_WEBSERVER_THREADS:-20}"
export SUPERSET_WEBSERVER_TIMEOUT="${SUPERSET_WEBSERVER_TIMEOUT:-60}"
export SUPERSET_WEBSERVER_KEEPALIVE="${SUPERSET_WEBSERVER_KEEPALIVE:-2}"
export SUPERSET_WEBSERVER_MAX_REQUESTS="${SUPERSET_WEBSERVER_MAX_REQUESTS:-0}"
export SUPERSET_WEBSERVER_MAX_REQUESTS_JITTER="${SUPERSET_WEBSERVER_MAX_REQUESTS_JITTER:-0}"
export SUPERSET_WEBSERVER_LIMIT_REQUEST_LINE="${SUPERSET_WEBSERVER_LIMIT_REQUEST_LINE:-0}"
export SUPERSET_WEBSERVER_LIMIT_REQUEST_FIELD_SIZE="${SUPERSET_WEBSERVER_LIMIT_REQUEST_FIELD_SIZE:-0}"
export FLOWER_BASIC_AUTH="${FLOWER_BASIC_AUTH:-}"

# Superset database configuration
export SUPERSET_DATABASE_DIALECT="${SUPERSET_DATABASE_DIALECT:-postgresql}"
export SUPERSET_LOAD_EXAMPLES="${SUPERSET_LOAD_EXAMPLES:-false}"
export SUPERSET_IMPORT_DATASOURCES="${SUPERSET_IMPORT_DATASOURCES:-}"
export SUPERSET_SKIP_DATABASE_WAIT="${SUPERSET_SKIP_DATABASE_WAIT:-no}"
export SUPERSET_DATABASE_HOST="${SUPERSET_DATABASE_HOST:-postgresql}"
export SUPERSET_DATABASE_PORT_NUMBER="${SUPERSET_DATABASE_PORT_NUMBER:-5432}"
export SUPERSET_DATABASE_NAME="${SUPERSET_DATABASE_NAME:-bitnami_superset}"
export SUPERSET_DATABASE_USERNAME="${SUPERSET_DATABASE_USERNAME:-bn_superset}"
export SUPERSET_DATABASE_PASSWORD="${SUPERSET_DATABASE_PASSWORD:-}"
export SUPERSET_DATABASE_USE_SSL="${SUPERSET_DATABASE_USE_SSL:-no}"
export REDIS_HOST="${REDIS_HOST:-redis}"
export REDIS_PORT_NUMBER="${REDIS_PORT_NUMBER:-6379}"
export REDIS_USER="${REDIS_USER:-}"
export REDIS_PASSWORD="${REDIS_PASSWORD:-}"
export REDIS_CELERY_DATABASE="${REDIS_CELERY_DATABASE:-0}"
export REDIS_RESULTS_DATABASE="${REDIS_RESULTS_DATABASE:-1}"
export REDIS_USE_SSL="${REDIS_USE_SSL:-no}"

# Custom environment variables may be defined below
