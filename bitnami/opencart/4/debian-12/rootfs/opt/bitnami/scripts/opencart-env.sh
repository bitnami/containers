#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for opencart

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
export MODULE="${MODULE:-opencart}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
opencart_env_vars=(
    OPENCART_DATA_TO_PERSIST
    OPENCART_HOST
    OPENCART_EXTERNAL_HTTP_PORT_NUMBER
    OPENCART_EXTERNAL_HTTPS_PORT_NUMBER
    OPENCART_ENABLE_HTTPS
    OPENCART_SKIP_BOOTSTRAP
    OPENCART_USERNAME
    OPENCART_PASSWORD
    OPENCART_EMAIL
    OPENCART_SMTP_HOST
    OPENCART_SMTP_PORT_NUMBER
    OPENCART_SMTP_USER
    OPENCART_SMTP_PASSWORD
    OPENCART_SMTP_PROTOCOL
    OPENCART_DATABASE_HOST
    OPENCART_DATABASE_PORT_NUMBER
    OPENCART_DATABASE_NAME
    OPENCART_DATABASE_USER
    OPENCART_DATABASE_PASSWORD
    OPENCART_EXTERNAL_HTTP_PORT
    OPENCART_EXTERNAL_HTTPS_PORT
    SMTP_HOST
    SMTP_PORT
    OPENCART_SMTP_PORT
    SMTP_USER
    SMTP_PASSWORD
    SMTP_PROTOCOL
)
for env_var in "${opencart_env_vars[@]}"; do
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
unset opencart_env_vars

# Paths
export OPENCART_BASE_DIR="${BITNAMI_ROOT_DIR}/opencart"
export OPENCART_CONF_FILE="${OPENCART_BASE_DIR}/config.php"
export OPENCART_ADMIN_CONF_FILE="${OPENCART_BASE_DIR}/administration/config.php"

# OpenCart persistence configuration
export OPENCART_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/opencart"
export OPENCART_STORAGE_DIR="${BITNAMI_VOLUME_DIR}/opencart_storage"
export OPENCART_DATA_TO_PERSIST="${OPENCART_DATA_TO_PERSIST:-config.php administration/config.php}"

# OpenCart configuration
export OPENCART_HOST="${OPENCART_HOST:-}" # only used during the first initialization
OPENCART_EXTERNAL_HTTP_PORT_NUMBER="${OPENCART_EXTERNAL_HTTP_PORT_NUMBER:-"${OPENCART_EXTERNAL_HTTP_PORT:-}"}"
export OPENCART_EXTERNAL_HTTP_PORT_NUMBER="${OPENCART_EXTERNAL_HTTP_PORT_NUMBER:-80}" # only used during the first initialization
OPENCART_EXTERNAL_HTTPS_PORT_NUMBER="${OPENCART_EXTERNAL_HTTPS_PORT_NUMBER:-"${OPENCART_EXTERNAL_HTTPS_PORT:-}"}"
export OPENCART_EXTERNAL_HTTPS_PORT_NUMBER="${OPENCART_EXTERNAL_HTTPS_PORT_NUMBER:-443}" # only used during the first initialization
export OPENCART_ENABLE_HTTPS="${OPENCART_ENABLE_HTTPS:-no}" # only used during the first initialization
export OPENCART_SKIP_BOOTSTRAP="${OPENCART_SKIP_BOOTSTRAP:-}" # only used during the first initialization

# OpenCart credentials
export OPENCART_USERNAME="${OPENCART_USERNAME:-user}" # only used during the first initialization
export OPENCART_PASSWORD="${OPENCART_PASSWORD:-bitnami}" # only used during the first initialization
export OPENCART_EMAIL="${OPENCART_EMAIL:-user@example.com}" # only used during the first initialization

# OpenCart SMTP credentials
OPENCART_SMTP_HOST="${OPENCART_SMTP_HOST:-"${SMTP_HOST:-}"}"
export OPENCART_SMTP_HOST="${OPENCART_SMTP_HOST:-}" # only used during the first initialization
OPENCART_SMTP_PORT_NUMBER="${OPENCART_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
OPENCART_SMTP_PORT_NUMBER="${OPENCART_SMTP_PORT_NUMBER:-"${OPENCART_SMTP_PORT:-}"}"
export OPENCART_SMTP_PORT_NUMBER="${OPENCART_SMTP_PORT_NUMBER:-}" # only used during the first initialization
OPENCART_SMTP_USER="${OPENCART_SMTP_USER:-"${SMTP_USER:-}"}"
export OPENCART_SMTP_USER="${OPENCART_SMTP_USER:-}" # only used during the first initialization
OPENCART_SMTP_PASSWORD="${OPENCART_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export OPENCART_SMTP_PASSWORD="${OPENCART_SMTP_PASSWORD:-}" # only used during the first initialization
OPENCART_SMTP_PROTOCOL="${OPENCART_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
export OPENCART_SMTP_PROTOCOL="${OPENCART_SMTP_PROTOCOL:-}" # only used during the first initialization

# Database configuration
export OPENCART_DEFAULT_DATABASE_HOST="mariadb" # only used at build time
export OPENCART_DATABASE_HOST="${OPENCART_DATABASE_HOST:-$OPENCART_DEFAULT_DATABASE_HOST}" # only used during the first initialization
export OPENCART_DATABASE_PORT_NUMBER="${OPENCART_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
export OPENCART_DATABASE_NAME="${OPENCART_DATABASE_NAME:-bitnami_opencart}" # only used during the first initialization
export OPENCART_DATABASE_USER="${OPENCART_DATABASE_USER:-bn_opencart}" # only used during the first initialization
export OPENCART_DATABASE_PASSWORD="${OPENCART_DATABASE_PASSWORD:-}" # only used during the first initialization

# PHP configuration
export PHP_DEFAULT_MEMORY_LIMIT="256M" # only used at build time

# Custom environment variables may be defined below
