#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for gitea

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
export MODULE="${MODULE:-gitea}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
gitea_env_vars=(
    GITEA_REPO_ROOT_PATH
    GITEA_LFS_ROOT_PATH
    GITEA_LOG_ROOT_PATH
    GITEA_LOG_MODE
    GITEA_LOG_ROUTER
    GITEA_ADMIN_USER
    GITEA_ADMIN_PASSWORD
    GITEA_ADMIN_EMAIL
    GITEA_APP_NAME
    GITEA_RUN_MODE
    GITEA_DOMAIN
    GITEA_SSH_DOMAIN
    GITEA_SSH_LISTEN_PORT
    GITEA_SSH_PORT
    GITEA_HTTP_PORT
    GITEA_PROTOCOL
    GITEA_ROOT_URL
    GITEA_PASSWORD_HASH_ALGO
    GITEA_LFS_START_SERVER
    GITEA_ENABLE_OPENID_SIGNIN
    GITEA_ENABLE_OPENID_SIGNUP
    GITEA_DATABASE_TYPE
    GITEA_DATABASE_HOST
    GITEA_DATABASE_PORT_NUMBER
    GITEA_DATABASE_NAME
    GITEA_DATABASE_USERNAME
    GITEA_DATABASE_PASSWORD
    GITEA_DATABASE_SSL_MODE
    GITEA_DATABASE_SCHEMA
    GITEA_DATABASE_CHARSET
    GITEA_SMTP_ENABLED
    GITEA_SMTP_HOST
    GITEA_SMTP_PORT
    GITEA_SMTP_FROM
    GITEA_SMTP_USER
    GITEA_SMTP_PASSWORD
    GITEA_OAUTH2_CLIENT_AUTO_REGISTRATION_ENABLED
    GITEA_OAUTH2_CLIENT_USERNAME
)
for env_var in "${gitea_env_vars[@]}"; do
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
unset gitea_env_vars

# Paths
export GITEA_BASE_DIR="${BITNAMI_ROOT_DIR}/gitea"
export GITEA_WORK_DIR="${GITEA_BASE_DIR}"
export GITEA_CUSTOM_DIR="${GITEA_BASE_DIR}/custom"
export GITEA_TMP_DIR="${GITEA_BASE_DIR}/tmp"
export GITEA_DATA_DIR="${GITEA_WORK_DIR}/data"
export GITEA_CONF_DIR="${GITEA_CUSTOM_DIR}/conf"
export GITEA_CONF_FILE="${GITEA_CONF_DIR}/app.ini"
export GITEA_PID_FILE="${GITEA_TMP_DIR}/gitea.pid"

# Gitea persistence configuration
export GITEA_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/gitea"
export GITEA_DATA_TO_PERSIST="${GITEA_CONF_FILE} data"

# Gitea configuration parameters
export GITEA_REPO_ROOT_PATH="${GITEA_REPO_ROOT_PATH:-${GITEA_DATA_DIR}/git/repositories}"
export GITEA_LFS_ROOT_PATH="${GITEA_LFS_ROOT_PATH:-}"
export GITEA_LOG_ROOT_PATH="${GITEA_LOG_ROOT_PATH:-${GITEA_TMP_DIR}/log}"
export GITEA_LOG_MODE="${GITEA_LOG_MODE:-}"
export GITEA_LOG_ROUTER="${GITEA_LOG_ROUTER:-}"
export GITEA_ADMIN_USER="${GITEA_ADMIN_USER:-bn_user}"
export GITEA_ADMIN_PASSWORD="${GITEA_ADMIN_PASSWORD:-bitnami}"
export GITEA_ADMIN_EMAIL="${GITEA_ADMIN_EMAIL:-user@bitnami.org}"
export GITEA_APP_NAME="${GITEA_APP_NAME:-Gitea: Git with a cup of tea}"
export GITEA_RUN_MODE="${GITEA_RUN_MODE:-prod}"
export GITEA_DOMAIN="${GITEA_DOMAIN:-localhost}"
export GITEA_SSH_DOMAIN="${GITEA_SSH_DOMAIN:-${GITEA_DOMAIN}}"
export GITEA_SSH_LISTEN_PORT="${GITEA_SSH_LISTEN_PORT:-2222}"
export GITEA_SSH_PORT="${GITEA_SSH_PORT:-${GITEA_SSH_LISTEN_PORT}}"
export GITEA_HTTP_PORT="${GITEA_HTTP_PORT:-3000}"
export GITEA_PROTOCOL="${GITEA_PROTOCOL:-http}"
export GITEA_ROOT_URL="${GITEA_ROOT_URL:-${GITEA_PROTOCOL}://${GITEA_DOMAIN}:${GITEA_HTTP_PORT}}"
export GITEA_PASSWORD_HASH_ALGO="${GITEA_PASSWORD_HASH_ALGO:-pbkdf2}"
export GITEA_LFS_START_SERVER="${GITEA_LFS_START_SERVER:-false}"
export GITEA_ENABLE_OPENID_SIGNIN="${GITEA_ENABLE_OPENID_SIGNIN:-false}"
export GITEA_ENABLE_OPENID_SIGNUP="${GITEA_ENABLE_OPENID_SIGNUP:-false}"
export GITEA_DATABASE_TYPE="${GITEA_DATABASE_TYPE:-postgres}"
export GITEA_DATABASE_HOST="${GITEA_DATABASE_HOST:-postgresql}"
export GITEA_DATABASE_PORT_NUMBER="${GITEA_DATABASE_PORT_NUMBER:-5432}"
export GITEA_DATABASE_NAME="${GITEA_DATABASE_NAME:-bitnami_gitea}"
export GITEA_DATABASE_USERNAME="${GITEA_DATABASE_USERNAME:-bn_gitea}"
export GITEA_DATABASE_PASSWORD="${GITEA_DATABASE_PASSWORD:-}"
export GITEA_DATABASE_SSL_MODE="${GITEA_DATABASE_SSL_MODE:-disable}"
export GITEA_DATABASE_SCHEMA="${GITEA_DATABASE_SCHEMA:-}"
export GITEA_DATABASE_CHARSET="${GITEA_DATABASE_CHARSET:-utf8}"
export GITEA_SMTP_ENABLED="${GITEA_SMTP_ENABLED:-false}"
export GITEA_SMTP_HOST="${GITEA_SMTP_HOST:-}"
export GITEA_SMTP_PORT="${GITEA_SMTP_PORT:-}"
export GITEA_SMTP_FROM="${GITEA_SMTP_FROM:-}"
export GITEA_SMTP_USER="${GITEA_SMTP_USER:-}"
export GITEA_SMTP_PASSWORD="${GITEA_SMTP_PASSWORD:-}"
export GITEA_OAUTH2_CLIENT_AUTO_REGISTRATION_ENABLED="${GITEA_OAUTH2_CLIENT_AUTO_REGISTRATION_ENABLED:-false}"
export GITEA_OAUTH2_CLIENT_USERNAME="${GITEA_OAUTH2_CLIENT_USERNAME:-nickname}"

# Gitea system parameters
export GITEA_DAEMON_USER="gitea"
export GITEA_DAEMON_GROUP="gitea"
export PATH="/opt/bitnami/common/bin:/opt/bitnami/gitea/bin:$PATH"

# Custom environment variables may be defined below
