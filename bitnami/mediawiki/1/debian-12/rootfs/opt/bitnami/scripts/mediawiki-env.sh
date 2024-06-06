#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for mediawiki

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
export MODULE="${MODULE:-mediawiki}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
mediawiki_env_vars=(
    MEDIAWIKI_DATA_TO_PERSIST
    MEDIAWIKI_SKIP_BOOTSTRAP
    MEDIAWIKI_WIKI_NAME
    MEDIAWIKI_WIKI_PREFIX
    MEDIAWIKI_SCRIPT_PATH
    MEDIAWIKI_HOST
    MEDIAWIKI_ENABLE_HTTPS
    MEDIAWIKI_EXTERNAL_HTTP_PORT_NUMBER
    MEDIAWIKI_EXTERNAL_HTTPS_PORT_NUMBER
    MEDIAWIKI_USERNAME
    MEDIAWIKI_PASSWORD
    MEDIAWIKI_EMAIL
    MEDIAWIKI_SMTP_HOST
    MEDIAWIKI_SMTP_HOST_ID
    MEDIAWIKI_SMTP_PORT_NUMBER
    MEDIAWIKI_SMTP_USER
    MEDIAWIKI_SMTP_PASSWORD
    MEDIAWIKI_ENABLE_SMTP_AUTH
    MEDIAWIKI_DATABASE_HOST
    MEDIAWIKI_DATABASE_PORT_NUMBER
    MEDIAWIKI_DATABASE_NAME
    MEDIAWIKI_DATABASE_USER
    MEDIAWIKI_DATABASE_PASSWORD
    MEDIAWIKI_SKIP_CONFIG_VALIDATION
    SMTP_HOST
    SMTP_HOST_ID
    SMTP_PORT
    MEDIAWIKI_SMTP_PORT
    SMTP_USER
    SMTP_PASSWORD
    SMTP_ENABLE_AUTH
    MARIADB_HOST
    MARIADB_PORT_NUMBER
)
for env_var in "${mediawiki_env_vars[@]}"; do
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
unset mediawiki_env_vars

# Paths
export MEDIAWIKI_BASE_DIR="${BITNAMI_ROOT_DIR}/mediawiki"
export MEDIAWIKI_CONF_FILE="${MEDIAWIKI_BASE_DIR}/LocalSettings.php"

# MediaWiki persistence configuration
export MEDIAWIKI_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/mediawiki"
export MEDIAWIKI_DATA_TO_PERSIST="${MEDIAWIKI_DATA_TO_PERSIST:-images extensions skins LocalSettings.php}"

# MediaWiki site configuration
export MEDIAWIKI_SKIP_BOOTSTRAP="${MEDIAWIKI_SKIP_BOOTSTRAP:-}" # only used during the first initialization
export MEDIAWIKI_WIKI_NAME="${MEDIAWIKI_WIKI_NAME:-Bitnami MediaWiki}" # only used during the first initialization
export MEDIAWIKI_WIKI_PREFIX="${MEDIAWIKI_WIKI_PREFIX:-/wiki}" # only used during the first initialization
export MEDIAWIKI_SCRIPT_PATH="${MEDIAWIKI_SCRIPT_PATH:-}" # only used during the first initialization
export MEDIAWIKI_HOST="${MEDIAWIKI_HOST:-localhost}" # only used during the first initialization
export MEDIAWIKI_ENABLE_HTTPS="${MEDIAWIKI_ENABLE_HTTPS:-no}" # only used during the first initialization
export MEDIAWIKI_EXTERNAL_HTTP_PORT_NUMBER="${MEDIAWIKI_EXTERNAL_HTTP_PORT_NUMBER:-80}" # only used during the first initialization
export MEDIAWIKI_EXTERNAL_HTTPS_PORT_NUMBER="${MEDIAWIKI_EXTERNAL_HTTPS_PORT_NUMBER:-443}" # only used during the first initialization

# MediaWiki credentials
export MEDIAWIKI_USERNAME="${MEDIAWIKI_USERNAME:-user}" # only used during the first initialization
export MEDIAWIKI_PASSWORD="${MEDIAWIKI_PASSWORD:-bitnami123}" # only used during the first initialization
export MEDIAWIKI_EMAIL="${MEDIAWIKI_EMAIL:-user@example.com}" # only used during the first initialization

# MediaWiki SMTP credentials
MEDIAWIKI_SMTP_HOST="${MEDIAWIKI_SMTP_HOST:-"${SMTP_HOST:-}"}"
export MEDIAWIKI_SMTP_HOST="${MEDIAWIKI_SMTP_HOST:-}" # only used during the first initialization
MEDIAWIKI_SMTP_HOST_ID="${MEDIAWIKI_SMTP_HOST_ID:-"${SMTP_HOST_ID:-}"}"
export MEDIAWIKI_SMTP_HOST_ID="${MEDIAWIKI_SMTP_HOST_ID:-$MEDIAWIKI_SMTP_HOST}" # only used during the first initialization
MEDIAWIKI_SMTP_PORT_NUMBER="${MEDIAWIKI_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
MEDIAWIKI_SMTP_PORT_NUMBER="${MEDIAWIKI_SMTP_PORT_NUMBER:-"${MEDIAWIKI_SMTP_PORT:-}"}"
export MEDIAWIKI_SMTP_PORT_NUMBER="${MEDIAWIKI_SMTP_PORT_NUMBER:-}" # only used during the first initialization
MEDIAWIKI_SMTP_USER="${MEDIAWIKI_SMTP_USER:-"${SMTP_USER:-}"}"
export MEDIAWIKI_SMTP_USER="${MEDIAWIKI_SMTP_USER:-}" # only used during the first initialization
MEDIAWIKI_SMTP_PASSWORD="${MEDIAWIKI_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export MEDIAWIKI_SMTP_PASSWORD="${MEDIAWIKI_SMTP_PASSWORD:-}" # only used during the first initialization
MEDIAWIKI_ENABLE_SMTP_AUTH="${MEDIAWIKI_ENABLE_SMTP_AUTH:-"${SMTP_ENABLE_AUTH:-}"}"
export MEDIAWIKI_ENABLE_SMTP_AUTH="${MEDIAWIKI_ENABLE_SMTP_AUTH:-yes}" # only used during the first initialization

# Database configuration
MEDIAWIKI_DATABASE_HOST="${MEDIAWIKI_DATABASE_HOST:-"${MARIADB_HOST:-}"}"
export MEDIAWIKI_DATABASE_HOST="${MEDIAWIKI_DATABASE_HOST:-mariadb}" # only used during the first initialization
MEDIAWIKI_DATABASE_PORT_NUMBER="${MEDIAWIKI_DATABASE_PORT_NUMBER:-"${MARIADB_PORT_NUMBER:-}"}"
export MEDIAWIKI_DATABASE_PORT_NUMBER="${MEDIAWIKI_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
export MEDIAWIKI_DATABASE_NAME="${MEDIAWIKI_DATABASE_NAME:-bitnami_mediawiki}" # only used during the first initialization
export MEDIAWIKI_DATABASE_USER="${MEDIAWIKI_DATABASE_USER:-bn_mediawiki}" # only used during the first initialization
export MEDIAWIKI_DATABASE_PASSWORD="${MEDIAWIKI_DATABASE_PASSWORD:-}" # only used during the first initialization
export MEDIAWIKI_SKIP_CONFIG_VALIDATION="${MEDIAWIKI_SKIP_CONFIG_VALIDATION:-no}" # only used during the first initialization

# PHP configuration
export PHP_DEFAULT_MEMORY_LIMIT="256M" # only used at build time

# Custom environment variables may be defined below
