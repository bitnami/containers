#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for ghost

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
export MODULE="${MODULE:-ghost}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
ghost_env_vars=(
    GHOST_DATA_TO_PERSIST
    GHOST_ENABLE_HTTPS
    GHOST_EXTERNAL_HTTP_PORT_NUMBER
    GHOST_EXTERNAL_HTTPS_PORT_NUMBER
    GHOST_HOST
    GHOST_PORT_NUMBER
    GHOST_BLOG_TITLE
    GHOST_SKIP_BOOTSTRAP
    GHOST_USERNAME
    GHOST_PASSWORD
    GHOST_EMAIL
    GHOST_SMTP_FROM_ADDRESS
    GHOST_SMTP_HOST
    GHOST_SMTP_PORT_NUMBER
    GHOST_SMTP_USER
    GHOST_SMTP_PASSWORD
    GHOST_SMTP_PROTOCOL
    GHOST_DATABASE_HOST
    GHOST_DATABASE_PORT_NUMBER
    GHOST_DATABASE_NAME
    GHOST_DATABASE_USER
    GHOST_DATABASE_PASSWORD
    GHOST_DATABASE_ENABLE_SSL
    GHOST_DATABASE_SSL_CA_FILE
    BLOG_TITLE
    SMTP_FROM
    GHOST_EMAIL
    SMTP_HOST
    SMTP_PORT
    GHOST_SMTP_PORT
    SMTP_USER
    SMTP_PASSWORD
    SMTP_PROTOCOL
    MYSQL_HOST
    MYSQL_PORT_NUMBER
    MYSQL_DATABASE_NAME
    MYSQL_DATABASE_USER
    MYSQL_DATABASE_PASSWORD
)
for env_var in "${ghost_env_vars[@]}"; do
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
unset ghost_env_vars

# Paths
export GHOST_BASE_DIR="${BITNAMI_ROOT_DIR}/ghost"
export GHOST_BIN_DIR="${GHOST_BASE_DIR}/bin"
export GHOST_LOG_FILE="${GHOST_BASE_DIR}/content/logs/ghost.log"
export GHOST_CONF_FILE="${GHOST_BASE_DIR}/config.production.json"
export GHOST_PID_FILE="${GHOST_BASE_DIR}/.ghostpid"
export PATH="${GHOST_BIN_DIR}:${BITNAMI_ROOT_DIR}/common/bin:${BITNAMI_ROOT_DIR}/node/bin:${PATH}"

# Ghost persistence configuration
export GHOST_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/ghost"
export GHOST_DATA_TO_PERSIST="${GHOST_DATA_TO_PERSIST:-content config.production.json}"

# System users (when running with a privileged user)
export GHOST_DAEMON_USER="ghost"
export GHOST_DAEMON_GROUP="ghost"

# Ghost configuration
export GHOST_ENABLE_HTTPS="${GHOST_ENABLE_HTTPS:-no}" # only used during the first initialization
export GHOST_EXTERNAL_HTTP_PORT_NUMBER="${GHOST_EXTERNAL_HTTP_PORT_NUMBER:-80}" # only used during the first initialization
export GHOST_EXTERNAL_HTTPS_PORT_NUMBER="${GHOST_EXTERNAL_HTTPS_PORT_NUMBER:-443}" # only used during the first initialization
export GHOST_HOST="${GHOST_HOST:-localhost}" # only used during the first initialization
export GHOST_DEFAULT_PORT_NUMBER="2368" # only used at build time
export GHOST_PORT_NUMBER="${GHOST_PORT_NUMBER:-}" # only used during the first initialization
GHOST_BLOG_TITLE="${GHOST_BLOG_TITLE:-"${BLOG_TITLE:-}"}"
export GHOST_BLOG_TITLE="${GHOST_BLOG_TITLE:-"User's blog"}" # only used during the first initialization
export GHOST_SKIP_BOOTSTRAP="${GHOST_SKIP_BOOTSTRAP:-}" # only used during the first initialization

# Ghost credentials
export GHOST_USERNAME="${GHOST_USERNAME:-user}" # only used during the first initialization
export GHOST_PASSWORD="${GHOST_PASSWORD:-bitnami123}" # only used during the first initialization
export GHOST_EMAIL="${GHOST_EMAIL:-user@example.com}" # only used during the first initialization

# Ghost SMTP credentials
GHOST_SMTP_FROM_ADDRESS="${GHOST_SMTP_FROM_ADDRESS:-"${SMTP_FROM:-}"}"
GHOST_SMTP_FROM_ADDRESS="${GHOST_SMTP_FROM_ADDRESS:-"${GHOST_EMAIL:-}"}"
export GHOST_SMTP_FROM_ADDRESS="${GHOST_SMTP_FROM_ADDRESS:-}" # only used during the first initialization
GHOST_SMTP_HOST="${GHOST_SMTP_HOST:-"${SMTP_HOST:-}"}"
export GHOST_SMTP_HOST="${GHOST_SMTP_HOST:-}" # only used during the first initialization
GHOST_SMTP_PORT_NUMBER="${GHOST_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
GHOST_SMTP_PORT_NUMBER="${GHOST_SMTP_PORT_NUMBER:-"${GHOST_SMTP_PORT:-}"}"
export GHOST_SMTP_PORT_NUMBER="${GHOST_SMTP_PORT_NUMBER:-}" # only used during the first initialization
GHOST_SMTP_USER="${GHOST_SMTP_USER:-"${SMTP_USER:-}"}"
export GHOST_SMTP_USER="${GHOST_SMTP_USER:-}" # only used during the first initialization
GHOST_SMTP_PASSWORD="${GHOST_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export GHOST_SMTP_PASSWORD="${GHOST_SMTP_PASSWORD:-}" # only used during the first initialization
GHOST_SMTP_PROTOCOL="${GHOST_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
export GHOST_SMTP_PROTOCOL="${GHOST_SMTP_PROTOCOL:-}" # only used during the first initialization

# Database configuration
export GHOST_DEFAULT_DATABASE_HOST="mysql" # only used at build time
GHOST_DATABASE_HOST="${GHOST_DATABASE_HOST:-"${MYSQL_HOST:-}"}"
export GHOST_DATABASE_HOST="${GHOST_DATABASE_HOST:-$GHOST_DEFAULT_DATABASE_HOST}" # only used during the first initialization
GHOST_DATABASE_PORT_NUMBER="${GHOST_DATABASE_PORT_NUMBER:-"${MYSQL_PORT_NUMBER:-}"}"
export GHOST_DATABASE_PORT_NUMBER="${GHOST_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
GHOST_DATABASE_NAME="${GHOST_DATABASE_NAME:-"${MYSQL_DATABASE_NAME:-}"}"
export GHOST_DATABASE_NAME="${GHOST_DATABASE_NAME:-bitnami_ghost}" # only used during the first initialization
GHOST_DATABASE_USER="${GHOST_DATABASE_USER:-"${MYSQL_DATABASE_USER:-}"}"
export GHOST_DATABASE_USER="${GHOST_DATABASE_USER:-bn_ghost}" # only used during the first initialization
GHOST_DATABASE_PASSWORD="${GHOST_DATABASE_PASSWORD:-"${MYSQL_DATABASE_PASSWORD:-}"}"
export GHOST_DATABASE_PASSWORD="${GHOST_DATABASE_PASSWORD:-}" # only used during the first initialization
export GHOST_DATABASE_ENABLE_SSL="${GHOST_DATABASE_ENABLE_SSL:-no}" # only used during the first initialization
export GHOST_DATABASE_SSL_CA_FILE="${GHOST_DATABASE_SSL_CA_FILE:-}" # only used during the first initialization

# Custom environment variables may be defined below
