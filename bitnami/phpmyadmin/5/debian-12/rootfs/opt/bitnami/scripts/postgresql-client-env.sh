#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for postgresql-client

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
export MODULE="${MODULE:-postgresql-client}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
postgresql_client_env_vars=(
    ALLOW_EMPTY_PASSWORD
    POSTGRESQL_CLIENT_DATABASE_HOST
    POSTGRESQL_CLIENT_DATABASE_PORT_NUMBER
    POSTGRESQL_CLIENT_POSTGRES_USER
    POSTGRESQL_CLIENT_POSTGRES_PASSWORD
    POSTGRESQL_CLIENT_CREATE_DATABASE_NAMES
    POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME
    POSTGRESQL_CLIENT_CREATE_DATABASE_PASSWORD
    POSTGRESQL_CLIENT_CREATE_DATABASE_EXTENSIONS
    POSTGRESQL_CLIENT_EXECUTE_SQL
    POSTGRESQL_HOST
    POSTGRESQL_PORT_NUMBER
    POSTGRESQL_CLIENT_ROOT_USER
    POSTGRESQL_POSTGRES_USER
    POSTGRESQL_ROOT_USER
    POSTGRESQL_CLIENT_ROOT_PASSWORD
    POSTGRESQL_POSTGRES_PASSWORD
    POSTGRESQL_ROOT_PASSWORD
    POSTGRESQL_CLIENT_CREATE_DATABASE_NAME
    POSTGRESQL_CLIENT_CREATE_DATABASE_USER
)
for env_var in "${postgresql_client_env_vars[@]}"; do
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
unset postgresql_client_env_vars

# Paths
export POSTGRESQL_BASE_DIR="/opt/bitnami/postgresql"
export POSTGRESQL_BIN_DIR="$POSTGRESQL_BASE_DIR/bin"
export PATH="${POSTGRESQL_BIN_DIR}:${PATH}"

# PostgreSQL settings
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"
POSTGRESQL_CLIENT_DATABASE_HOST="${POSTGRESQL_CLIENT_DATABASE_HOST:-"${POSTGRESQL_HOST:-}"}"
export POSTGRESQL_CLIENT_DATABASE_HOST="${POSTGRESQL_CLIENT_DATABASE_HOST:-postgresql}"
POSTGRESQL_CLIENT_DATABASE_PORT_NUMBER="${POSTGRESQL_CLIENT_DATABASE_PORT_NUMBER:-"${POSTGRESQL_PORT_NUMBER:-}"}"
export POSTGRESQL_CLIENT_DATABASE_PORT_NUMBER="${POSTGRESQL_CLIENT_DATABASE_PORT_NUMBER:-5432}"
POSTGRESQL_CLIENT_POSTGRES_USER="${POSTGRESQL_CLIENT_POSTGRES_USER:-"${POSTGRESQL_CLIENT_ROOT_USER:-}"}"
POSTGRESQL_CLIENT_POSTGRES_USER="${POSTGRESQL_CLIENT_POSTGRES_USER:-"${POSTGRESQL_POSTGRES_USER:-}"}"
POSTGRESQL_CLIENT_POSTGRES_USER="${POSTGRESQL_CLIENT_POSTGRES_USER:-"${POSTGRESQL_ROOT_USER:-}"}"
export POSTGRESQL_CLIENT_POSTGRES_USER="${POSTGRESQL_CLIENT_POSTGRES_USER:-postgres}" # only used during the first initialization
POSTGRESQL_CLIENT_POSTGRES_PASSWORD="${POSTGRESQL_CLIENT_POSTGRES_PASSWORD:-"${POSTGRESQL_CLIENT_ROOT_PASSWORD:-}"}"
POSTGRESQL_CLIENT_POSTGRES_PASSWORD="${POSTGRESQL_CLIENT_POSTGRES_PASSWORD:-"${POSTGRESQL_POSTGRES_PASSWORD:-}"}"
POSTGRESQL_CLIENT_POSTGRES_PASSWORD="${POSTGRESQL_CLIENT_POSTGRES_PASSWORD:-"${POSTGRESQL_ROOT_PASSWORD:-}"}"
export POSTGRESQL_CLIENT_POSTGRES_PASSWORD="${POSTGRESQL_CLIENT_POSTGRES_PASSWORD:-}" # only used during the first initialization
POSTGRESQL_CLIENT_CREATE_DATABASE_NAMES="${POSTGRESQL_CLIENT_CREATE_DATABASE_NAMES:-"${POSTGRESQL_CLIENT_CREATE_DATABASE_NAME:-}"}"
export POSTGRESQL_CLIENT_CREATE_DATABASE_NAMES="${POSTGRESQL_CLIENT_CREATE_DATABASE_NAMES:-}" # only used during the first initialization
POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME="${POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME:-"${POSTGRESQL_CLIENT_CREATE_DATABASE_USER:-}"}"
export POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME="${POSTGRESQL_CLIENT_CREATE_DATABASE_USERNAME:-}" # only used during the first initialization
export POSTGRESQL_CLIENT_CREATE_DATABASE_PASSWORD="${POSTGRESQL_CLIENT_CREATE_DATABASE_PASSWORD:-}" # only used during the first initialization
export POSTGRESQL_CLIENT_CREATE_DATABASE_EXTENSIONS="${POSTGRESQL_CLIENT_CREATE_DATABASE_EXTENSIONS:-}" # only used during the first initialization
export POSTGRESQL_CLIENT_EXECUTE_SQL="${POSTGRESQL_CLIENT_EXECUTE_SQL:-}" # only used during the first initialization

# Custom environment variables may be defined below
