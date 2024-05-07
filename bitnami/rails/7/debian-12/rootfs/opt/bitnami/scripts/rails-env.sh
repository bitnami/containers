#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for rails

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
export MODULE="${MODULE:-rails}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
rails_env_vars=(
    RAILS_ENV
    RAILS_SKIP_ACTIVE_RECORD
    RAILS_SKIP_DB_SETUP
    RAILS_SKIP_DB_WAIT
    RAILS_RETRY_ATTEMPTS
    RAILS_DATABASE_TYPE
    RAILS_DATABASE_HOST
    RAILS_DATABASE_PORT_NUMBER
    RAILS_DATABASE_NAME
    SKIP_ACTIVE_RECORD
    SKIP_DB_SETUP
    SKIP_DB_WAIT
    RETRY_ATTEMPTS
    DATABASE_TYPE
    DATABASE_HOST
    DATABASE_PORT_NUMBER
    DATABASE_NAME
)
for env_var in "${rails_env_vars[@]}"; do
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
unset rails_env_vars

# Rails configuration
export RAILS_ENV="${RAILS_ENV:-development}"
RAILS_SKIP_ACTIVE_RECORD="${RAILS_SKIP_ACTIVE_RECORD:-"${SKIP_ACTIVE_RECORD:-}"}"
export RAILS_SKIP_ACTIVE_RECORD="${RAILS_SKIP_ACTIVE_RECORD:-no}"
RAILS_SKIP_DB_SETUP="${RAILS_SKIP_DB_SETUP:-"${SKIP_DB_SETUP:-}"}"
export RAILS_SKIP_DB_SETUP="${RAILS_SKIP_DB_SETUP:-no}"
RAILS_SKIP_DB_WAIT="${RAILS_SKIP_DB_WAIT:-"${SKIP_DB_WAIT:-}"}"
export RAILS_SKIP_DB_WAIT="${RAILS_SKIP_DB_WAIT:-no}"
RAILS_RETRY_ATTEMPTS="${RAILS_RETRY_ATTEMPTS:-"${RETRY_ATTEMPTS:-}"}"
export RAILS_RETRY_ATTEMPTS="${RAILS_RETRY_ATTEMPTS:-30}"
export PATH="${BITNAMI_ROOT_DIR}/ruby/bin:${BITNAMI_ROOT_DIR}/mysql/bin:${BITNAMI_ROOT_DIR}/node/bin:${BITNAMI_ROOT_DIR}/git/bin:${PATH}"

# Database configuration
RAILS_DATABASE_TYPE="${RAILS_DATABASE_TYPE:-"${DATABASE_TYPE:-}"}"
export RAILS_DATABASE_TYPE="${RAILS_DATABASE_TYPE:-mariadb}"
export DATABASE_TYPE="$RAILS_DATABASE_TYPE" # only used during the first initialization
RAILS_DATABASE_HOST="${RAILS_DATABASE_HOST:-"${DATABASE_HOST:-}"}"
export RAILS_DATABASE_HOST="${RAILS_DATABASE_HOST:-mariadb}"
export DATABASE_HOST="$RAILS_DATABASE_HOST" # only used during the first initialization
RAILS_DATABASE_PORT_NUMBER="${RAILS_DATABASE_PORT_NUMBER:-"${DATABASE_PORT_NUMBER:-}"}"
export RAILS_DATABASE_PORT_NUMBER="${RAILS_DATABASE_PORT_NUMBER:-3306}"
export DATABASE_PORT_NUMBER="$RAILS_DATABASE_PORT_NUMBER" # only used during the first initialization
RAILS_DATABASE_NAME="${RAILS_DATABASE_NAME:-"${DATABASE_NAME:-}"}"
export RAILS_DATABASE_NAME="${RAILS_DATABASE_NAME:-bitnami_myapp}"
export DATABASE_NAME="$RAILS_DATABASE_NAME" # only used during the first initialization

# Custom environment variables may be defined below
