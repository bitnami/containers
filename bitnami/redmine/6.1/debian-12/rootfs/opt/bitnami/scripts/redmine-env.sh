#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for redmine

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
export MODULE="${MODULE:-redmine}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
redmine_env_vars=(
    REDMINE_DATA_TO_PERSIST
    REDMINE_PORT_NUMBER
    REDMINE_ENV
    REDMINE_LANGUAGE
    REDMINE_REST_API_ENABLED
    REDMINE_LOAD_DEFAULT_DATA
    REDMINE_SKIP_BOOTSTRAP
    REDMINE_QUEUE_ADAPTER
    REDMINE_USERNAME
    REDMINE_PASSWORD
    REDMINE_EMAIL
    REDMINE_FIRST_NAME
    REDMINE_LAST_NAME
    REDMINE_SMTP_HOST
    REDMINE_SMTP_PORT_NUMBER
    REDMINE_SMTP_USER
    REDMINE_SMTP_DOMAIN
    REDMINE_SMTP_PASSWORD
    REDMINE_SMTP_PROTOCOL
    REDMINE_SMTP_AUTH
    REDMINE_SMTP_OPENSSL_VERIFY_MODE
    REDMINE_SMTP_CA_FILE
    REDMINE_DATABASE_TYPE
    REDMINE_DATABASE_HOST
    REDMINE_DATABASE_PORT_NUMBER
    REDMINE_DATABASE_NAME
    REDMINE_DATABASE_USER
    REDMINE_DATABASE_PASSWORD
    SMTP_HOST
    SMTP_PORT
    REDMINE_SMTP_PORT
    SMTP_USER
    SMTP_DOMAIN
    SMTP_PASSWORD
    SMTP_PROTOCOL
    SMTP_AUTHENTICATION
    SMTP_OPENSSL_VERIFY_MODE
    SMTP_CA_FILE
    REDMINE_DB_MYSQL
    REDMINE_DB_POSTGRES
    MARIADB_HOST
    REDMINE_DB_PORT_NUMBER
    MARIADB_PORT_NUMBER
    REDMINE_DB_NAME
    MARIADB_DATABASE_NAME
    REDMINE_DB_USERNAME
    MARIADB_DATABASE_USER
    REDMINE_DB_PASSWORD
    MARIADB_DATABASE_PASSWORD
)
for env_var in "${redmine_env_vars[@]}"; do
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
unset redmine_env_vars

# Paths
export REDMINE_BASE_DIR="${BITNAMI_ROOT_DIR}/redmine"
export REDMINE_CONF_DIR="${REDMINE_BASE_DIR}/config"

# Redmine persistence configuration
export REDMINE_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/redmine"
export REDMINE_DATA_TO_PERSIST="${REDMINE_DATA_TO_PERSIST:-${REDMINE_CONF_DIR}/configuration.yml ${REDMINE_CONF_DIR}/database.yml files plugins public/plugin_assets}"

# System users (when running with a privileged user)
export REDMINE_DAEMON_USER="redmine"
export REDMINE_DAEMON_GROUP="redmine"

# Redmine configuration
export REDMINE_PORT_NUMBER="${REDMINE_PORT_NUMBER:-3000}" # only used during the first initialization
export REDMINE_ENV="${REDMINE_ENV:-production}"
export REDMINE_LANGUAGE="${REDMINE_LANGUAGE:-en}" # only used during the first initialization
export REDMINE_REST_API_ENABLED="${REDMINE_REST_API_ENABLED:-0}" # only used during the first initialization
export REDMINE_LOAD_DEFAULT_DATA="${REDMINE_LOAD_DEFAULT_DATA:-yes}" # only used during the first initialization
export REDMINE_SKIP_BOOTSTRAP="${REDMINE_SKIP_BOOTSTRAP:-}" # only used during the first initialization
export REDMINE_QUEUE_ADAPTER="${REDMINE_QUEUE_ADAPTER:-inline}"

# Redmine credentials
export REDMINE_USERNAME="${REDMINE_USERNAME:-user}" # only used during the first initialization
export REDMINE_PASSWORD="${REDMINE_PASSWORD:-bitnami1}" # only used during the first initialization
export REDMINE_EMAIL="${REDMINE_EMAIL:-user@example.com}" # only used during the first initialization
export REDMINE_FIRST_NAME="${REDMINE_FIRST_NAME:-UserName}" # only used during the first initialization
export REDMINE_LAST_NAME="${REDMINE_LAST_NAME:-LastName}" # only used during the first initialization

# Redmine SMTP credentials
REDMINE_SMTP_HOST="${REDMINE_SMTP_HOST:-"${SMTP_HOST:-}"}"
export REDMINE_SMTP_HOST="${REDMINE_SMTP_HOST:-}" # only used during the first initialization
REDMINE_SMTP_PORT_NUMBER="${REDMINE_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
REDMINE_SMTP_PORT_NUMBER="${REDMINE_SMTP_PORT_NUMBER:-"${REDMINE_SMTP_PORT:-}"}"
export REDMINE_SMTP_PORT_NUMBER="${REDMINE_SMTP_PORT_NUMBER:-}" # only used during the first initialization
REDMINE_SMTP_USER="${REDMINE_SMTP_USER:-"${SMTP_USER:-}"}"
export REDMINE_SMTP_USER="${REDMINE_SMTP_USER:-}" # only used during the first initialization
REDMINE_SMTP_DOMAIN="${REDMINE_SMTP_DOMAIN:-"${SMTP_DOMAIN:-}"}"
export REDMINE_SMTP_DOMAIN="${REDMINE_SMTP_DOMAIN:-}" # only used during the first initialization
REDMINE_SMTP_PASSWORD="${REDMINE_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export REDMINE_SMTP_PASSWORD="${REDMINE_SMTP_PASSWORD:-}" # only used during the first initialization
REDMINE_SMTP_PROTOCOL="${REDMINE_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
export REDMINE_SMTP_PROTOCOL="${REDMINE_SMTP_PROTOCOL:-}" # only used during the first initialization
REDMINE_SMTP_AUTH="${REDMINE_SMTP_AUTH:-"${SMTP_AUTHENTICATION:-}"}"
export REDMINE_SMTP_AUTH="${REDMINE_SMTP_AUTH:-login}" # only used during the first initialization
REDMINE_SMTP_OPENSSL_VERIFY_MODE="${REDMINE_SMTP_OPENSSL_VERIFY_MODE:-"${SMTP_OPENSSL_VERIFY_MODE:-}"}"
export REDMINE_SMTP_OPENSSL_VERIFY_MODE="${REDMINE_SMTP_OPENSSL_VERIFY_MODE:-peer}" # only used during the first initialization
REDMINE_SMTP_CA_FILE="${REDMINE_SMTP_CA_FILE:-"${SMTP_CA_FILE:-}"}"
export REDMINE_SMTP_CA_FILE="${REDMINE_SMTP_CA_FILE:-/etc/ssl/certs/ca-certificates.crt}" # only used during the first initialization

# Database configuration
export REDMINE_DATABASE_TYPE="${REDMINE_DATABASE_TYPE:-mariadb}" # only used during the first initialization
export REDMINE_DEFAULT_DATABASE_HOST="mariadb" # only used at build time
REDMINE_DATABASE_HOST="${REDMINE_DATABASE_HOST:-"${REDMINE_DB_MYSQL:-}"}"
REDMINE_DATABASE_HOST="${REDMINE_DATABASE_HOST:-"${REDMINE_DB_POSTGRES:-}"}"
REDMINE_DATABASE_HOST="${REDMINE_DATABASE_HOST:-"${MARIADB_HOST:-}"}"
export REDMINE_DATABASE_HOST="${REDMINE_DATABASE_HOST:-$REDMINE_DEFAULT_DATABASE_HOST}" # only used during the first initialization
REDMINE_DATABASE_PORT_NUMBER="${REDMINE_DATABASE_PORT_NUMBER:-"${REDMINE_DB_PORT_NUMBER:-}"}"
REDMINE_DATABASE_PORT_NUMBER="${REDMINE_DATABASE_PORT_NUMBER:-"${MARIADB_PORT_NUMBER:-}"}"
export REDMINE_DATABASE_PORT_NUMBER="${REDMINE_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
REDMINE_DATABASE_NAME="${REDMINE_DATABASE_NAME:-"${REDMINE_DB_NAME:-}"}"
REDMINE_DATABASE_NAME="${REDMINE_DATABASE_NAME:-"${MARIADB_DATABASE_NAME:-}"}"
export REDMINE_DATABASE_NAME="${REDMINE_DATABASE_NAME:-bitnami_redmine}" # only used during the first initialization
REDMINE_DATABASE_USER="${REDMINE_DATABASE_USER:-"${REDMINE_DB_USERNAME:-}"}"
REDMINE_DATABASE_USER="${REDMINE_DATABASE_USER:-"${MARIADB_DATABASE_USER:-}"}"
export REDMINE_DATABASE_USER="${REDMINE_DATABASE_USER:-bn_redmine}" # only used during the first initialization
REDMINE_DATABASE_PASSWORD="${REDMINE_DATABASE_PASSWORD:-"${REDMINE_DB_PASSWORD:-}"}"
REDMINE_DATABASE_PASSWORD="${REDMINE_DATABASE_PASSWORD:-"${MARIADB_DATABASE_PASSWORD:-}"}"
export REDMINE_DATABASE_PASSWORD="${REDMINE_DATABASE_PASSWORD:-}" # only used during the first initialization

# Custom environment variables may be defined below
