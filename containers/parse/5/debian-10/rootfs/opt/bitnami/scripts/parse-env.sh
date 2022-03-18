#!/bin/bash
#
# Environment configuration for parse

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

# Load logging library
. /opt/bitnami/scripts/liblog.sh

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-parse}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
parse_env_vars=(
    PARSE_ENABLE_HTTPS
    PARSE_BIND_HOST
    PARSE_HOST
    PARSE_PORT_NUMBER
    PARSE_APP_ID
    PARSE_MASTER_KEY
    PARSE_APP_NAME
    PARSE_MOUNT_PATH
    PARSE_ENABLE_CLOUD_CODE
    PARSE_DATABASE_HOST
    PARSE_DATABASE_PORT_NUMBER
    PARSE_DATABASE_NAME
    PARSE_DATABASE_USER
    PARSE_DATABASE_PASSWORD
    MONGODB_HOST
    MONGODB_PORT_NUMBER
    MONGODB_PORT
    MONGODB_DATABASE_NAME
    MONGODB_DATABASE_USER
    MONGODB_DATABASE_USERNAME
    MONGODB_DATABASE_PASSWORD
    MONGODB_PASSWORD
)
for env_var in "${parse_env_vars[@]}"; do
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
unset parse_env_vars

# Paths
export PARSE_BASE_DIR="${BITNAMI_ROOT_DIR}/parse"
export PARSE_TMP_DIR="${PARSE_BASE_DIR}/tmp"
export PARSE_LOGS_DIR="${PARSE_BASE_DIR}/logs"
export PARSE_PID_FILE="${PARSE_TMP_DIR}/parse.pid"
export PARSE_LOG_FILE="${PARSE_LOGS_DIR}/parse.log"
export PARSE_CONF_FILE="${PARSE_BASE_DIR}/config.json"

# Parse persistence configuration
export PARSE_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/parse"

# System users (when running with a privileged user)
export PARSE_DAEMON_USER="parse"
export PARSE_DAEMON_GROUP="parse"

# Parse configuration
export PARSE_ENABLE_HTTPS="${PARSE_ENABLE_HTTPS:-no}" # only used during the first initialization
export PARSE_BIND_HOST="${PARSE_BIND_HOST:-0.0.0.0}"
export PARSE_HOST="${PARSE_HOST:-127.0.0.1}"
export PARSE_PORT_NUMBER="${PARSE_PORT_NUMBER:-1337}"
export PARSE_APP_ID="${PARSE_APP_ID:-myappID}"
export PARSE_MASTER_KEY="${PARSE_MASTER_KEY:-mymasterKey}"
export PARSE_APP_NAME="${PARSE_APP_NAME:-parse-server}"
export PARSE_MOUNT_PATH="${PARSE_MOUNT_PATH:-/parse}"
export PARSE_ENABLE_CLOUD_CODE="${PARSE_ENABLE_CLOUD_CODE:-no}"

# Database configuration
export PARSE_DEFAULT_DATABASE_HOST="mongodb" # only used at build time
PARSE_DATABASE_HOST="${PARSE_DATABASE_HOST:-"${MONGODB_HOST:-}"}"
export PARSE_DATABASE_HOST="${PARSE_DATABASE_HOST:-$PARSE_DEFAULT_DATABASE_HOST}" # only used during the first initialization
PARSE_DATABASE_PORT_NUMBER="${PARSE_DATABASE_PORT_NUMBER:-"${MONGODB_PORT_NUMBER:-}"}"
PARSE_DATABASE_PORT_NUMBER="${PARSE_DATABASE_PORT_NUMBER:-"${MONGODB_PORT:-}"}"
export PARSE_DATABASE_PORT_NUMBER="${PARSE_DATABASE_PORT_NUMBER:-27017}" # only used during the first initialization
PARSE_DATABASE_NAME="${PARSE_DATABASE_NAME:-"${MONGODB_DATABASE_NAME:-}"}"
export PARSE_DATABASE_NAME="${PARSE_DATABASE_NAME:-bitnami_parse}" # only used during the first initialization
PARSE_DATABASE_USER="${PARSE_DATABASE_USER:-"${MONGODB_DATABASE_USER:-}"}"
PARSE_DATABASE_USER="${PARSE_DATABASE_USER:-"${MONGODB_DATABASE_USERNAME:-}"}"
export PARSE_DATABASE_USER="${PARSE_DATABASE_USER:-bn_parse}" # only used during the first initialization
PARSE_DATABASE_PASSWORD="${PARSE_DATABASE_PASSWORD:-"${MONGODB_DATABASE_PASSWORD:-}"}"
PARSE_DATABASE_PASSWORD="${PARSE_DATABASE_PASSWORD:-"${MONGODB_PASSWORD:-}"}"
export PARSE_DATABASE_PASSWORD="${PARSE_DATABASE_PASSWORD:-}" # only used during the first initialization

# Custom environment variables may be defined below
