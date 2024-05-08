#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for phpbb

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
export MODULE="${MODULE:-phpbb}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
phpbb_env_vars=(
    PHPBB_DATA_TO_PERSIST
    PHPBB_FORUM_LANGUAGE
    PHPBB_FORUM_NAME
    PHPBB_COOKIE_SECURE
    PHPBB_FORUM_DESCRIPTION
    PHPBB_FORUM_SERVER_PROTOCOL
    PHPBB_FORUM_SERVER_PORT
    PHPBB_DISABLE_SESSION_VALIDATION
    PHPBB_HOST
    PHPBB_SKIP_BOOTSTRAP
    PHPBB_USERNAME
    PHPBB_PASSWORD
    PHPBB_EMAIL
    PHPBB_SMTP_HOST
    PHPBB_SMTP_PORT_NUMBER
    PHPBB_SMTP_USER
    PHPBB_SMTP_PASSWORD
    PHPBB_SMTP_PROTOCOL
    PHPBB_DATABASE_HOST
    PHPBB_DATABASE_PORT_NUMBER
    PHPBB_DATABASE_NAME
    PHPBB_DATABASE_USER
    PHPBB_DATABASE_PASSWORD
    SMTP_HOST
    SMTP_PORT
    PHPBB_SMTP_PORT
    SMTP_USER
    SMTP_PASSWORD
    SMTP_PROTOCOL
)
for env_var in "${phpbb_env_vars[@]}"; do
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
unset phpbb_env_vars

# Paths
export PHPBB_BASE_DIR="${BITNAMI_ROOT_DIR}/phpbb"
export PHPBB_BIN_DIR="${PHPBB_BASE_DIR}/bin"
export PHPBB_CACHE_DIR="${PHPBB_BASE_DIR}/cache"
export PHPBB_STORE_DIR="${PHPBB_BASE_DIR}/store"
export PHPBB_WIZARD_DIR="${PHPBB_BASE_DIR}/install"
export PHPBB_CONF_FILE="${PHPBB_BASE_DIR}/config.php"
export PHPBB_INSTALL_JSON_FILE="${PHPBB_WIZARD_DIR}/install_config.json"
export PHPBB_INSTALL_PHP_FILE="${PHPBB_STORE_DIR}/install_config.php"

# phpBB persistence configuration
export PHPBB_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/phpbb"
export PHPBB_MOUNTED_CONF_FILE="${PHPBB_VOLUME_DIR}/config.inc.php"
export PHPBB_DATA_TO_PERSIST="${PHPBB_DATA_TO_PERSIST:-store language files images config.php ext styles}"

# phpBB configuration
export PHPBB_FORUM_LANGUAGE="${PHPBB_FORUM_LANGUAGE:-en}" # only used during the first initialization
export PHPBB_FORUM_NAME="${PHPBB_FORUM_NAME:-My forum}" # only used during the first initialization
export PHPBB_COOKIE_SECURE="${PHPBB_COOKIE_SECURE:-false}" # only used during the first initialization
export PHPBB_FORUM_DESCRIPTION="${PHPBB_FORUM_DESCRIPTION:-A little text to describe your forum}" # only used during the first initialization
export PHPBB_FORUM_SERVER_PROTOCOL="${PHPBB_FORUM_SERVER_PROTOCOL:-http://}" # only used during the first initialization
export PHPBB_FORUM_SERVER_PORT="${PHPBB_FORUM_SERVER_PORT:-80}" # only used during the first initialization
export PHPBB_DISABLE_SESSION_VALIDATION="${PHPBB_DISABLE_SESSION_VALIDATION:-false}" # only used during the first initialization
export PHPBB_HOST="${PHPBB_HOST:-localhost}" # only used during the first initialization
export PHPBB_SKIP_BOOTSTRAP="${PHPBB_SKIP_BOOTSTRAP:-}" # only used during the first initialization

# phpBB credentials
export PHPBB_USERNAME="${PHPBB_USERNAME:-user}" # only used during the first initialization
export PHPBB_PASSWORD="${PHPBB_PASSWORD:-bitnami}" # only used during the first initialization
export PHPBB_EMAIL="${PHPBB_EMAIL:-user@example.com}" # only used during the first initialization

# phpBB SMTP credentials
PHPBB_SMTP_HOST="${PHPBB_SMTP_HOST:-"${SMTP_HOST:-}"}"
export PHPBB_SMTP_HOST="${PHPBB_SMTP_HOST:-}" # only used during the first initialization
PHPBB_SMTP_PORT_NUMBER="${PHPBB_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
PHPBB_SMTP_PORT_NUMBER="${PHPBB_SMTP_PORT_NUMBER:-"${PHPBB_SMTP_PORT:-}"}"
export PHPBB_SMTP_PORT_NUMBER="${PHPBB_SMTP_PORT_NUMBER:-}" # only used during the first initialization
PHPBB_SMTP_USER="${PHPBB_SMTP_USER:-"${SMTP_USER:-}"}"
export PHPBB_SMTP_USER="${PHPBB_SMTP_USER:-}" # only used during the first initialization
PHPBB_SMTP_PASSWORD="${PHPBB_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export PHPBB_SMTP_PASSWORD="${PHPBB_SMTP_PASSWORD:-}" # only used during the first initialization
PHPBB_SMTP_PROTOCOL="${PHPBB_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
export PHPBB_SMTP_PROTOCOL="${PHPBB_SMTP_PROTOCOL:-plain}" # only used during the first initialization

# Database configuration
export PHPBB_DEFAULT_DATABASE_HOST="mariadb" # only used at build time
export PHPBB_DATABASE_HOST="${PHPBB_DATABASE_HOST:-$PHPBB_DEFAULT_DATABASE_HOST}" # only used during the first initialization
export PHPBB_DATABASE_PORT_NUMBER="${PHPBB_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
export PHPBB_DATABASE_NAME="${PHPBB_DATABASE_NAME:-bitnami_phpbb}" # only used during the first initialization
export PHPBB_DATABASE_USER="${PHPBB_DATABASE_USER:-bn_phpbb}" # only used during the first initialization
export PHPBB_DATABASE_PASSWORD="${PHPBB_DATABASE_PASSWORD:-}" # only used during the first initialization

# PHP configuration
export PHP_DEFAULT_MEMORY_LIMIT="256M" # only used at build time

# Custom environment variables may be defined below
