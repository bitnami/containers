#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for prestashop

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
export MODULE="${MODULE:-prestashop}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
prestashop_env_vars=(
    PRESTASHOP_DATA_TO_PERSIST
    PRESTASHOP_HOST
    PRESTASHOP_ENABLE_HTTPS
    PRESTASHOP_EXTERNAL_HTTP_PORT_NUMBER
    PRESTASHOP_EXTERNAL_HTTPS_PORT_NUMBER
    PRESTASHOP_COOKIE_CHECK_IP
    PRESTASHOP_COUNTRY
    PRESTASHOP_LANGUAGE
    PRESTASHOP_TIMEZONE
    PRESTASHOP_SKIP_BOOTSTRAP
    PRESTASHOP_FIRST_NAME
    PRESTASHOP_LAST_NAME
    PRESTASHOP_PASSWORD
    PRESTASHOP_EMAIL
    PRESTASHOP_SMTP_HOST
    PRESTASHOP_SMTP_PORT_NUMBER
    PRESTASHOP_SMTP_USER
    PRESTASHOP_SMTP_PASSWORD
    PRESTASHOP_SMTP_PROTOCOL
    PRESTASHOP_DATABASE_HOST
    PRESTASHOP_DATABASE_PORT_NUMBER
    PRESTASHOP_DATABASE_NAME
    PRESTASHOP_DATABASE_PREFIX
    PRESTASHOP_DATABASE_USER
    PRESTASHOP_DATABASE_PASSWORD
    SMTP_HOST
    SMTP_PORT
    PRESTASHOP_SMTP_PORT
    SMTP_USER
    SMTP_PASSWORD
    SMTP_PROTOCOL
    MARIADB_HOST
    MARIADB_PORT_NUMBER
)
for env_var in "${prestashop_env_vars[@]}"; do
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
unset prestashop_env_vars

# Paths
export PRESTASHOP_BASE_DIR="${BITNAMI_ROOT_DIR}/prestashop"
export PRESTASHOP_CONF_FILE="${PRESTASHOP_BASE_DIR}/app/config/parameters.php"
export PATH="${BITNAMI_ROOT_DIR}/php/bin:${PATH}"

# PrestaShop persistence configuration
export PRESTASHOP_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/prestashop"
export PRESTASHOP_DATA_TO_PERSIST="${PRESTASHOP_DATA_TO_PERSIST:-$PRESTASHOP_BASE_DIR}"

# PrestaShop configuration
export PRESTASHOP_HOST="${PRESTASHOP_HOST:-}" # only used during the first initialization
export PRESTASHOP_ENABLE_HTTPS="${PRESTASHOP_ENABLE_HTTPS:-no}" # only used during the first initialization
export PRESTASHOP_EXTERNAL_HTTP_PORT_NUMBER="${PRESTASHOP_EXTERNAL_HTTP_PORT_NUMBER:-80}" # only used during the first initialization
export PRESTASHOP_EXTERNAL_HTTPS_PORT_NUMBER="${PRESTASHOP_EXTERNAL_HTTPS_PORT_NUMBER:-443}" # only used during the first initialization
export PRESTASHOP_COOKIE_CHECK_IP="${PRESTASHOP_COOKIE_CHECK_IP:-yes}" # only used during the first initialization
export PRESTASHOP_COUNTRY="${PRESTASHOP_COUNTRY:-us}" # only used during the first initialization
export PRESTASHOP_LANGUAGE="${PRESTASHOP_LANGUAGE:-en}" # only used during the first initialization
export PRESTASHOP_TIMEZONE="${PRESTASHOP_TIMEZONE:-America/Los_Angeles}" # only used during the first initialization
export PRESTASHOP_SKIP_BOOTSTRAP="${PRESTASHOP_SKIP_BOOTSTRAP:-}" # only used during the first initialization

# PrestaShop credentials
export PRESTASHOP_FIRST_NAME="${PRESTASHOP_FIRST_NAME:-Bitnami}" # only used during the first initialization
export PRESTASHOP_LAST_NAME="${PRESTASHOP_LAST_NAME:-User}" # only used during the first initialization
export PRESTASHOP_PASSWORD="${PRESTASHOP_PASSWORD:-bitnami1}" # only used during the first initialization
export PRESTASHOP_EMAIL="${PRESTASHOP_EMAIL:-user@example.com}" # only used during the first initialization

# PrestaShop SMTP credentials
PRESTASHOP_SMTP_HOST="${PRESTASHOP_SMTP_HOST:-"${SMTP_HOST:-}"}"
export PRESTASHOP_SMTP_HOST="${PRESTASHOP_SMTP_HOST:-}" # only used during the first initialization
PRESTASHOP_SMTP_PORT_NUMBER="${PRESTASHOP_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
PRESTASHOP_SMTP_PORT_NUMBER="${PRESTASHOP_SMTP_PORT_NUMBER:-"${PRESTASHOP_SMTP_PORT:-}"}"
export PRESTASHOP_SMTP_PORT_NUMBER="${PRESTASHOP_SMTP_PORT_NUMBER:-}" # only used during the first initialization
PRESTASHOP_SMTP_USER="${PRESTASHOP_SMTP_USER:-"${SMTP_USER:-}"}"
export PRESTASHOP_SMTP_USER="${PRESTASHOP_SMTP_USER:-}" # only used during the first initialization
PRESTASHOP_SMTP_PASSWORD="${PRESTASHOP_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export PRESTASHOP_SMTP_PASSWORD="${PRESTASHOP_SMTP_PASSWORD:-}" # only used during the first initialization
PRESTASHOP_SMTP_PROTOCOL="${PRESTASHOP_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
export PRESTASHOP_SMTP_PROTOCOL="${PRESTASHOP_SMTP_PROTOCOL:-}" # only used during the first initialization

# Database configuration
export PRESTASHOP_DEFAULT_DATABASE_HOST="mariadb" # only used at build time
PRESTASHOP_DATABASE_HOST="${PRESTASHOP_DATABASE_HOST:-"${MARIADB_HOST:-}"}"
export PRESTASHOP_DATABASE_HOST="${PRESTASHOP_DATABASE_HOST:-$PRESTASHOP_DEFAULT_DATABASE_HOST}" # only used during the first initialization
PRESTASHOP_DATABASE_PORT_NUMBER="${PRESTASHOP_DATABASE_PORT_NUMBER:-"${MARIADB_PORT_NUMBER:-}"}"
export PRESTASHOP_DATABASE_PORT_NUMBER="${PRESTASHOP_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
export PRESTASHOP_DATABASE_NAME="${PRESTASHOP_DATABASE_NAME:-bitnami_prestashop}" # only used during the first initialization
export PRESTASHOP_DATABASE_PREFIX="${PRESTASHOP_DATABASE_PREFIX:-ps_}" # only used during the first initialization
export PRESTASHOP_DATABASE_USER="${PRESTASHOP_DATABASE_USER:-bn_prestashop}" # only used during the first initialization
export PRESTASHOP_DATABASE_PASSWORD="${PRESTASHOP_DATABASE_PASSWORD:-}" # only used during the first initialization

# PHP configuration
export PHP_DEFAULT_MAX_INPUT_VARS="5000" # only used at build time
export PHP_DEFAULT_MEMORY_LIMIT="256M" # only used at build time
export PHP_DEFAULT_POST_MAX_SIZE="128M" # only used at build time
export PHP_DEFAULT_UPLOAD_MAX_FILESIZE="128M" # only used at build time

# Custom environment variables may be defined below
