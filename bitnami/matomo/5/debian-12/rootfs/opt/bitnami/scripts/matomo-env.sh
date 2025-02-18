#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for matomo

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
export MODULE="${MODULE:-matomo}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
matomo_env_vars=(
    MATOMO_DATA_TO_PERSIST
    MATOMO_EXCLUDED_DATA_FROM_UPDATE
    MATOMO_SKIP_BOOTSTRAP
    MATOMO_PROXY_HOST_HEADER
    MATOMO_PROXY_CLIENT_HEADER
    MATOMO_ENABLE_ASSUME_SECURE_PROTOCOL
    MATOMO_ENABLE_FORCE_SSL
    MATOMO_ENABLE_PROXY_URI_HEADER
    MATOMO_USERNAME
    MATOMO_PASSWORD
    MATOMO_EMAIL
    MATOMO_HOST
    MATOMO_WEBSITE_NAME
    MATOMO_WEBSITE_HOST
    MATOMO_ENABLE_TRUSTED_HOST_CHECK
    MATOMO_ENABLE_DATABASE_SSL
    MATOMO_DATABASE_SSL_CA_FILE
    MATOMO_DATABASE_SSL_CERT_FILE
    MATOMO_DATABASE_SSL_KEY_FILE
    MATOMO_VERIFY_DATABASE_SSL
    MATOMO_SMTP_HOST
    MATOMO_SMTP_PORT_NUMBER
    MATOMO_SMTP_USER
    MATOMO_SMTP_PASSWORD
    MATOMO_SMTP_AUTH
    MATOMO_SMTP_PROTOCOL
    MATOMO_NOREPLY_NAME
    MATOMO_NOREPLY_ADDRESS
    MATOMO_DATABASE_HOST
    MATOMO_DATABASE_PORT_NUMBER
    MATOMO_DATABASE_NAME
    MATOMO_DATABASE_USER
    MATOMO_DATABASE_PASSWORD
    MATOMO_DATABASE_TABLE_PREFIX
    SMTP_HOST
    SMTP_PORT
    MATOMO_SMTP_PORT
    SMTP_USER
    SMTP_PASSWORD
    SMTP_AUTH
    SMTP_PROTOCOL
)
for env_var in "${matomo_env_vars[@]}"; do
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
unset matomo_env_vars

# Paths
export MATOMO_BASE_DIR="${BITNAMI_ROOT_DIR}/matomo"
export MATOMO_CONF_DIR="${MATOMO_BASE_DIR}/config"
export MATOMO_CONF_FILE="${MATOMO_CONF_DIR}/config.ini.php"

# Matomo persistence configuration
export MATOMO_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/matomo"
export MATOMO_DATA_TO_PERSIST="${MATOMO_DATA_TO_PERSIST:-$MATOMO_BASE_DIR}"
export MATOMO_EXCLUDED_DATA_FROM_UPDATE="${MATOMO_EXCLUDED_DATA_FROM_UPDATE:-}"

# Matomo configuration
export MATOMO_SKIP_BOOTSTRAP="${MATOMO_SKIP_BOOTSTRAP:-}" # only used during the first initialization

# Reverse Proxy Configuration options
export MATOMO_PROXY_HOST_HEADER="${MATOMO_PROXY_HOST_HEADER:-}" # only used during the first initialization
export MATOMO_PROXY_CLIENT_HEADER="${MATOMO_PROXY_CLIENT_HEADER:-}" # only used during the first initialization
export MATOMO_ENABLE_ASSUME_SECURE_PROTOCOL="${MATOMO_ENABLE_ASSUME_SECURE_PROTOCOL:-no}" # only used during the first initialization
export MATOMO_ENABLE_FORCE_SSL="${MATOMO_ENABLE_FORCE_SSL:-no}" # only used during the first initialization
export MATOMO_ENABLE_PROXY_URI_HEADER="${MATOMO_ENABLE_PROXY_URI_HEADER:-no}" # only used during the first initialization

# Matomo credentials
export MATOMO_USERNAME="${MATOMO_USERNAME:-user}" # only used during the first initialization
export MATOMO_PASSWORD="${MATOMO_PASSWORD:-bitnami}" # only used during the first initialization
export MATOMO_EMAIL="${MATOMO_EMAIL:-user@example.com}" # only used during the first initialization
export MATOMO_HOST="${MATOMO_HOST:-127.0.0.1}" # only used during the first initialization
export MATOMO_WEBSITE_NAME="${MATOMO_WEBSITE_NAME:-example}" # only used during the first initialization
export MATOMO_WEBSITE_HOST="${MATOMO_WEBSITE_HOST:-https://example.org}" # only used during the first initialization
export MATOMO_ENABLE_TRUSTED_HOST_CHECK="${MATOMO_ENABLE_TRUSTED_HOST_CHECK:-no}" # only used during the first initialization
export MATOMO_ENABLE_DATABASE_SSL="${MATOMO_ENABLE_DATABASE_SSL:-no}" # only used during the first initialization
export MATOMO_DATABASE_SSL_CA_FILE="${MATOMO_DATABASE_SSL_CA_FILE:-}" # only used during the first initialization
export MATOMO_DATABASE_SSL_CERT_FILE="${MATOMO_DATABASE_SSL_CERT_FILE:-}" # only used during the first initialization
export MATOMO_DATABASE_SSL_KEY_FILE="${MATOMO_DATABASE_SSL_KEY_FILE:-}" # only used during the first initialization
export MATOMO_VERIFY_DATABASE_SSL="${MATOMO_VERIFY_DATABASE_SSL:-yes}" # only used during the first initialization

# Matomo SMTP credentials
MATOMO_SMTP_HOST="${MATOMO_SMTP_HOST:-"${SMTP_HOST:-}"}"
export MATOMO_SMTP_HOST="${MATOMO_SMTP_HOST:-}" # only used during the first initialization
MATOMO_SMTP_PORT_NUMBER="${MATOMO_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
MATOMO_SMTP_PORT_NUMBER="${MATOMO_SMTP_PORT_NUMBER:-"${MATOMO_SMTP_PORT:-}"}"
export MATOMO_SMTP_PORT_NUMBER="${MATOMO_SMTP_PORT_NUMBER:-}" # only used during the first initialization
MATOMO_SMTP_USER="${MATOMO_SMTP_USER:-"${SMTP_USER:-}"}"
export MATOMO_SMTP_USER="${MATOMO_SMTP_USER:-}" # only used during the first initialization
MATOMO_SMTP_PASSWORD="${MATOMO_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export MATOMO_SMTP_PASSWORD="${MATOMO_SMTP_PASSWORD:-}" # only used during the first initialization
MATOMO_SMTP_AUTH="${MATOMO_SMTP_AUTH:-"${SMTP_AUTH:-}"}"
export MATOMO_SMTP_AUTH="${MATOMO_SMTP_AUTH:-}" # only used during the first initialization
MATOMO_SMTP_PROTOCOL="${MATOMO_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
export MATOMO_SMTP_PROTOCOL="${MATOMO_SMTP_PROTOCOL:-}" # only used during the first initialization
export MATOMO_NOREPLY_NAME="${MATOMO_NOREPLY_NAME:-}" # only used during the first initialization
export MATOMO_NOREPLY_ADDRESS="${MATOMO_NOREPLY_ADDRESS:-}" # only used during the first initialization

# Database configuration
export MATOMO_DEFAULT_DATABASE_HOST="mariadb" # only used at build time
export MATOMO_DATABASE_HOST="${MATOMO_DATABASE_HOST:-$MATOMO_DEFAULT_DATABASE_HOST}" # only used during the first initialization
export MATOMO_DATABASE_PORT_NUMBER="${MATOMO_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
export MATOMO_DATABASE_NAME="${MATOMO_DATABASE_NAME:-bitnami_matomo}" # only used during the first initialization
export MATOMO_DATABASE_USER="${MATOMO_DATABASE_USER:-bn_matomo}" # only used during the first initialization
export MATOMO_DATABASE_PASSWORD="${MATOMO_DATABASE_PASSWORD:-}" # only used during the first initialization
export MATOMO_DATABASE_TABLE_PREFIX="${MATOMO_DATABASE_TABLE_PREFIX:-matomo_}" # only used during the first initialization

# PHP configuration
export PHP_DEFAULT_MEMORY_LIMIT="256M" # only used at build time

# Custom environment variables may be defined below
