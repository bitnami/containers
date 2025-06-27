#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for suitecrm

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
export MODULE="${MODULE:-suitecrm}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
suitecrm_env_vars=(
    SUITECRM_DATA_TO_PERSIST
    SUITECRM_SKIP_BOOTSTRAP
    SUITECRM_USERNAME
    SUITECRM_PASSWORD
    SUITECRM_EMAIL
    SUITECRM_HOST
    SUITECRM_ENABLE_HTTPS
    SUITECRM_EXTERNAL_HTTP_PORT_NUMBER
    SUITECRM_EXTERNAL_HTTPS_PORT_NUMBER
    SUITECRM_VALIDATE_USER_IP
    SUITECRM_SMTP_HOST
    SUITECRM_SMTP_PORT_NUMBER
    SUITECRM_SMTP_USER
    SUITECRM_SMTP_PASSWORD
    SUITECRM_SMTP_PROTOCOL
    SUITECRM_SMTP_NOTIFY_ADDRESS
    SUITECRM_SMTP_NOTIFY_NAME
    SUITECRM_DATABASE_HOST
    SUITECRM_DATABASE_PORT_NUMBER
    SUITECRM_DATABASE_NAME
    SUITECRM_DATABASE_USER
    SUITECRM_DATABASE_PASSWORD
    SMTP_HOST
    SMTP_PORT
    SUITECRM_SMTP_PORT
    SMTP_USER
    SMTP_PASSWORD
    SMTP_PROTOCOL
)
for env_var in "${suitecrm_env_vars[@]}"; do
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
unset suitecrm_env_vars

# Paths
export SUITECRM_BASE_DIR="${BITNAMI_ROOT_DIR}/suitecrm"
export SUITECRM_CONF_FILE="${SUITECRM_BASE_DIR}/public/legacy/config.php"
export SUITECRM_SILENT_INSTALL_CONF_FILE="${SUITECRM_BASE_DIR}/public/legacy/config_si.php"

# SuiteCRM persistence configuration
export SUITECRM_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/suitecrm"
export SUITECRM_MOUNTED_CONF_FILE="${SUITECRM_VOLUME_DIR}/config_si.php"
export SUITECRM_DATA_TO_PERSIST="${SUITECRM_DATA_TO_PERSIST:-$SUITECRM_BASE_DIR}"

# SuiteCRM configuration
export SUITECRM_SKIP_BOOTSTRAP="${SUITECRM_SKIP_BOOTSTRAP:-}" # only used during the first initialization

# SuiteCRM credentials
export SUITECRM_USERNAME="${SUITECRM_USERNAME:-user}" # only used during the first initialization
export SUITECRM_PASSWORD="${SUITECRM_PASSWORD:-bitnami}" # only used during the first initialization
export SUITECRM_EMAIL="${SUITECRM_EMAIL:-user@example.com}" # only used during the first initialization
export SUITECRM_HOST="${SUITECRM_HOST:-localhost}" # only used during the first initialization
export SUITECRM_ENABLE_HTTPS="${SUITECRM_ENABLE_HTTPS:-no}" # only used during the first initialization
export SUITECRM_EXTERNAL_HTTP_PORT_NUMBER="${SUITECRM_EXTERNAL_HTTP_PORT_NUMBER:-80}" # only used during the first initialization
export SUITECRM_EXTERNAL_HTTPS_PORT_NUMBER="${SUITECRM_EXTERNAL_HTTPS_PORT_NUMBER:-443}" # only used during the first initialization
export SUITECRM_VALIDATE_USER_IP="${SUITECRM_VALIDATE_USER_IP:-true}"

# SuiteCRM SMTP credentials
SUITECRM_SMTP_HOST="${SUITECRM_SMTP_HOST:-"${SMTP_HOST:-}"}"
export SUITECRM_SMTP_HOST="${SUITECRM_SMTP_HOST:-}" # only used during the first initialization
SUITECRM_SMTP_PORT_NUMBER="${SUITECRM_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
SUITECRM_SMTP_PORT_NUMBER="${SUITECRM_SMTP_PORT_NUMBER:-"${SUITECRM_SMTP_PORT:-}"}"
export SUITECRM_SMTP_PORT_NUMBER="${SUITECRM_SMTP_PORT_NUMBER:-}" # only used during the first initialization
SUITECRM_SMTP_USER="${SUITECRM_SMTP_USER:-"${SMTP_USER:-}"}"
export SUITECRM_SMTP_USER="${SUITECRM_SMTP_USER:-}" # only used during the first initialization
SUITECRM_SMTP_PASSWORD="${SUITECRM_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export SUITECRM_SMTP_PASSWORD="${SUITECRM_SMTP_PASSWORD:-}" # only used during the first initialization
SUITECRM_SMTP_PROTOCOL="${SUITECRM_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
export SUITECRM_SMTP_PROTOCOL="${SUITECRM_SMTP_PROTOCOL:-}" # only used during the first initialization
export SUITECRM_SMTP_NOTIFY_ADDRESS="${SUITECRM_SMTP_NOTIFY_ADDRESS:-${SUITECRM_EMAIL}}"
export SUITECRM_SMTP_NOTIFY_NAME="${SUITECRM_SMTP_NOTIFY_NAME:-SuiteCRM}"

# Database configuration
export SUITECRM_DEFAULT_DATABASE_HOST="mariadb" # only used at build time
export SUITECRM_DATABASE_HOST="${SUITECRM_DATABASE_HOST:-$SUITECRM_DEFAULT_DATABASE_HOST}" # only used during the first initialization
export SUITECRM_DATABASE_PORT_NUMBER="${SUITECRM_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
export SUITECRM_DATABASE_NAME="${SUITECRM_DATABASE_NAME:-bitnami_suitecrm}" # only used during the first initialization
export SUITECRM_DATABASE_USER="${SUITECRM_DATABASE_USER:-bn_suitecrm}" # only used during the first initialization
export SUITECRM_DATABASE_PASSWORD="${SUITECRM_DATABASE_PASSWORD:-}" # only used during the first initialization

# PHP configuration
export PHP_DEFAULT_MEMORY_LIMIT="256M" # only used at build time
export PHP_DEFAULT_POST_MAX_SIZE="60M" # only used at build time
export PHP_DEFAULT_UPLOAD_MAX_FILESIZE="60M" # only used at build time

# Custom environment variables may be defined below
