#!/bin/bash
#
# Environment configuration for mongodb-client

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
export MODULE="${MODULE:-mongodb-client}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
mongodb_client_env_vars=(
    ALLOW_EMPTY_PASSWORD
    MONGODB_CLIENT_DATABASE_HOST
    MONGODB_CLIENT_DATABASE_PORT_NUMBER
    MONGODB_CLIENT_DATABASE_ROOT_USER
    MONGODB_CLIENT_DATABASE_ROOT_PASSWORD
    MONGODB_CLIENT_CREATE_DATABASE_NAME
    MONGODB_CLIENT_CREATE_DATABASE_USERNAME
    MONGODB_CLIENT_CREATE_DATABASE_PASSWORD
    MONGODB_CLIENT_EXTRA_FLAGS
    MONGODB_HOST
    MONGODB_PORT_NUMBER
    MONGODB_CLIENT_ROOT_USER
    MONGODB_ROOT_USER
    MONGODB_CLIENT_ROOT_PASSWORD
    MONGODB_ROOT_PASSWORD
    MONGODB_CLIENT_CREATE_DATABASE_USER
)
for env_var in "${mongodb_client_env_vars[@]}"; do
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
unset mongodb_client_env_vars

# Paths
export MONGODB_BASE_DIR="/opt/bitnami/mongodb-client"
export MONGODB_BIN_DIR="$MONGODB_BASE_DIR/bin"
export PATH="${MONGODB_BIN_DIR}:${PATH}"

# MongoDB settings
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"
MONGODB_CLIENT_DATABASE_HOST="${MONGODB_CLIENT_DATABASE_HOST:-"${MONGODB_HOST:-}"}"
export MONGODB_CLIENT_DATABASE_HOST="${MONGODB_CLIENT_DATABASE_HOST:-mongodb}"
MONGODB_CLIENT_DATABASE_PORT_NUMBER="${MONGODB_CLIENT_DATABASE_PORT_NUMBER:-"${MONGODB_PORT_NUMBER:-}"}"
export MONGODB_CLIENT_DATABASE_PORT_NUMBER="${MONGODB_CLIENT_DATABASE_PORT_NUMBER:-27017}"
MONGODB_CLIENT_DATABASE_ROOT_USER="${MONGODB_CLIENT_DATABASE_ROOT_USER:-"${MONGODB_CLIENT_ROOT_USER:-}"}"
MONGODB_CLIENT_DATABASE_ROOT_USER="${MONGODB_CLIENT_DATABASE_ROOT_USER:-"${MONGODB_ROOT_USER:-}"}"
export MONGODB_CLIENT_DATABASE_ROOT_USER="${MONGODB_CLIENT_DATABASE_ROOT_USER:-root}" # only used during the first initialization
MONGODB_CLIENT_DATABASE_ROOT_PASSWORD="${MONGODB_CLIENT_DATABASE_ROOT_PASSWORD:-"${MONGODB_CLIENT_ROOT_PASSWORD:-}"}"
MONGODB_CLIENT_DATABASE_ROOT_PASSWORD="${MONGODB_CLIENT_DATABASE_ROOT_PASSWORD:-"${MONGODB_ROOT_PASSWORD:-}"}"
export MONGODB_CLIENT_DATABASE_ROOT_PASSWORD="${MONGODB_CLIENT_DATABASE_ROOT_PASSWORD:-}" # only used during the first initialization
export MONGODB_CLIENT_CREATE_DATABASE_NAME="${MONGODB_CLIENT_CREATE_DATABASE_NAME:-}" # only used during the first initialization
MONGODB_CLIENT_CREATE_DATABASE_USERNAME="${MONGODB_CLIENT_CREATE_DATABASE_USERNAME:-"${MONGODB_CLIENT_CREATE_DATABASE_USER:-}"}"
export MONGODB_CLIENT_CREATE_DATABASE_USERNAME="${MONGODB_CLIENT_CREATE_DATABASE_USERNAME:-}" # only used during the first initialization
export MONGODB_CLIENT_CREATE_DATABASE_PASSWORD="${MONGODB_CLIENT_CREATE_DATABASE_PASSWORD:-}" # only used during the first initialization
export MONGODB_CLIENT_EXTRA_FLAGS="${MONGODB_CLIENT_EXTRA_FLAGS:-}"

# Custom environment variables may be defined below
