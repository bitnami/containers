#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for drupal

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
export MODULE="${MODULE:-drupal}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
drupal_env_vars=(
    DRUPAL_DATA_TO_PERSIST
    DRUPAL_PROFILE
    DRUPAL_SITE_NAME
    DRUPAL_SKIP_BOOTSTRAP
    DRUPAL_ENABLE_MODULES
    DRUPAL_CONFIG_SYNC_DIR
    DRUPAL_HASH_SALT
    DRUPAL_USERNAME
    DRUPAL_PASSWORD
    DRUPAL_EMAIL
    DRUPAL_SMTP_HOST
    DRUPAL_SMTP_PORT_NUMBER
    DRUPAL_SMTP_USER
    DRUPAL_SMTP_PASSWORD
    DRUPAL_SMTP_PROTOCOL
    DRUPAL_DATABASE_HOST
    DRUPAL_DATABASE_PORT_NUMBER
    DRUPAL_DATABASE_NAME
    DRUPAL_DATABASE_USER
    DRUPAL_DATABASE_PASSWORD
    DRUPAL_DATABASE_TLS_CA_FILE
    SMTP_HOST
    SMTP_PORT
    DRUPAL_SMTP_PORT
    SMTP_USER
    SMTP_PASSWORD
    SMTP_PROTOCOL
    MARIADB_HOST
    MARIADB_PORT_NUMBER
)
for env_var in "${drupal_env_vars[@]}"; do
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
unset drupal_env_vars

# Paths
export DRUPAL_BASE_DIR="${BITNAMI_ROOT_DIR}/drupal"
export DRUPAL_CONF_FILE="${DRUPAL_BASE_DIR}/sites/default/settings.php"
export DRUPAL_MODULES_DIR="${DRUPAL_BASE_DIR}/modules"

# Drupal persistence configuration
export DRUPAL_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/drupal"
export DRUPAL_MOUNTED_CONF_FILE="${DRUPAL_VOLUME_DIR}/settings.php"
export DRUPAL_DATA_TO_PERSIST="${DRUPAL_DATA_TO_PERSIST:-sites/ themes/ modules/ profiles/}"

# Drupal configuration
export DRUPAL_PROFILE="${DRUPAL_PROFILE:-standard}" # only used during the first initialization
export DRUPAL_SITE_NAME="${DRUPAL_SITE_NAME:-My blog}" # only used during the first initialization
export DRUPAL_SKIP_BOOTSTRAP="${DRUPAL_SKIP_BOOTSTRAP:-}" # only used during the first initialization
export DRUPAL_ENABLE_MODULES="${DRUPAL_ENABLE_MODULES:-}" # only used during the first initialization
export DRUPAL_CONFIG_SYNC_DIR="${DRUPAL_CONFIG_SYNC_DIR:-}" # only used during the first initialization
export DRUPAL_HASH_SALT="${DRUPAL_HASH_SALT:-}" # only used during the first initialization

# Drupal credentials
export DRUPAL_USERNAME="${DRUPAL_USERNAME:-user}" # only used during the first initialization
export DRUPAL_PASSWORD="${DRUPAL_PASSWORD:-bitnami}" # only used during the first initialization
export DRUPAL_EMAIL="${DRUPAL_EMAIL:-user@example.com}" # only used during the first initialization

# Drupal SMTP credentials
DRUPAL_SMTP_HOST="${DRUPAL_SMTP_HOST:-"${SMTP_HOST:-}"}"
export DRUPAL_SMTP_HOST="${DRUPAL_SMTP_HOST:-}" # only used during the first initialization
DRUPAL_SMTP_PORT_NUMBER="${DRUPAL_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
DRUPAL_SMTP_PORT_NUMBER="${DRUPAL_SMTP_PORT_NUMBER:-"${DRUPAL_SMTP_PORT:-}"}"
export DRUPAL_SMTP_PORT_NUMBER="${DRUPAL_SMTP_PORT_NUMBER:-25}" # only used during the first initialization
DRUPAL_SMTP_USER="${DRUPAL_SMTP_USER:-"${SMTP_USER:-}"}"
export DRUPAL_SMTP_USER="${DRUPAL_SMTP_USER:-}" # only used during the first initialization
DRUPAL_SMTP_PASSWORD="${DRUPAL_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export DRUPAL_SMTP_PASSWORD="${DRUPAL_SMTP_PASSWORD:-}" # only used during the first initialization
DRUPAL_SMTP_PROTOCOL="${DRUPAL_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
export DRUPAL_SMTP_PROTOCOL="${DRUPAL_SMTP_PROTOCOL:-standard}" # only used during the first initialization

# Database configuration
export DRUPAL_DEFAULT_DATABASE_HOST="mariadb" # only used at build time
DRUPAL_DATABASE_HOST="${DRUPAL_DATABASE_HOST:-"${MARIADB_HOST:-}"}"
export DRUPAL_DATABASE_HOST="${DRUPAL_DATABASE_HOST:-$DRUPAL_DEFAULT_DATABASE_HOST}" # only used during the first initialization
DRUPAL_DATABASE_PORT_NUMBER="${DRUPAL_DATABASE_PORT_NUMBER:-"${MARIADB_PORT_NUMBER:-}"}"
export DRUPAL_DATABASE_PORT_NUMBER="${DRUPAL_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
export DRUPAL_DATABASE_NAME="${DRUPAL_DATABASE_NAME:-bitnami_drupal}" # only used during the first initialization
export DRUPAL_DATABASE_USER="${DRUPAL_DATABASE_USER:-bn_drupal}" # only used during the first initialization
export DRUPAL_DATABASE_PASSWORD="${DRUPAL_DATABASE_PASSWORD:-}" # only used during the first initialization
export DRUPAL_DATABASE_TLS_CA_FILE="${DRUPAL_DATABASE_TLS_CA_FILE:-}" # only used during the first initialization

# PHP configuration
export PHP_DEFAULT_MEMORY_LIMIT="256M" # only used at build time

# Custom environment variables may be defined below
