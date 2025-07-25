#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for mastodon

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
export MODULE="${MODULE:-mastodon}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
mastodon_env_vars=(
    MASTODON_MODE
    ALLOW_EMPTY_PASSWORD
    MASTODON_CREATE_ADMIN
    MASTODON_ADMIN_USERNAME
    MASTODON_ADMIN_PASSWORD
    MASTODON_ADMIN_EMAIL
    MASTODON_ALLOW_ALL_DOMAINS
    MASTODON_SECRET_KEY_BASE
    MASTODON_OTP_SECRET
    MASTODON_HTTPS_ENABLED
    MASTODON_ASSETS_PRECOMPILE
    MASTODON_WEB_DOMAIN
    MASTODON_WEB_HOST
    MASTODON_WEB_PORT_NUMBER
    MASTODON_STREAMING_PORT_NUMBER
    MASTODON_AUTHORIZED_FETCH
    MASTODON_LIMITED_FEDERATION_MODE
    MASTODON_STREAMING_API_BASE_URL
    MASTODON_SMTP_LOGIN
    MASTODON_SMTP_PASSWORD
    RAILS_SERVE_STATIC_FILES
    MASTODON_BIND_ADDRESS
    MASTODON_DATA_TO_PERSIST
    MASTODON_USE_LIBVIPS
    MASTODON_MIGRATE_DATABASE
    MASTODON_DATABASE_HOST
    MASTODON_DATABASE_PORT_NUMBER
    MASTODON_DATABASE_NAME
    MASTODON_DATABASE_USERNAME
    MASTODON_DATABASE_PASSWORD
    MASTODON_DATABASE_POOL
    MASTODON_REDIS_HOST
    MASTODON_REDIS_PORT_NUMBER
    MASTODON_REDIS_PASSWORD
    MASTODON_ELASTICSEARCH_ENABLED
    MASTODON_MIGRATE_ELASTICSEARCH
    MASTODON_ELASTICSEARCH_HOST
    MASTODON_ELASTICSEARCH_PORT_NUMBER
    MASTODON_ELASTICSEARCH_USER
    MASTODON_ELASTICSEARCH_PASSWORD
    MASTODON_S3_ENABLED
    MASTODON_S3_BUCKET
    MASTODON_S3_HOSTNAME
    MASTODON_S3_PROTOCOL
    MASTODON_S3_PORT_NUMBER
    MASTODON_S3_ALIAS_HOST
    MASTODON_AWS_SECRET_ACCESS_KEY
    MASTODON_AWS_ACCESS_KEY_ID
    MASTODON_S3_REGION
    MASTODON_S3_ENDPOINT
    MASTODON_STARTUP_ATTEMPTS
    SECRET_KEY_BASE
    OTP_SECRET
    WEB_DOMAIN
    AUTHORIZED_FETCH
    LIMITED_FEDERATION_MODE
    STREAMING_API_BASE_URL
    SMTP_LOGIN
    SMTP_PASSWORD
    BIND
    DB_HOST
    DB_PORT
    DB_NAME
    DB_USER
    DB_PASS
    DB_POOL
    REDIS_HOST
    REDIS_PORT
    REDIS_PASSWORD
    ES_ENABLED
    ES_HOST
    ES_PORT
    ES_USER
    ES_PASS
    S3_ENABLED
    S3_BUCKET
    S3_HOSTNAME
    S3_PROTOCOL
    S3_ALIAS_HOST
    AWS_SECRET_ACCESS_KEY
    AWS_ACCESS_KEY_ID
    S3_ENDPOINT
)
for env_var in "${mastodon_env_vars[@]}"; do
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
unset mastodon_env_vars

# Paths
export MASTODON_BASE_DIR="${BITNAMI_ROOT_DIR}/mastodon"
export MASTODON_VOLUME_DIR="/bitnami/mastodon"
export MASTODON_ASSETS_DIR="${MASTODON_BASE_DIR}/public/assets"
export MASTODON_SYSTEM_DIR="${MASTODON_BASE_DIR}/public/system"
export MASTODON_TMP_DIR="${MASTODON_BASE_DIR}/tmp"
export MASTODON_LOGS_DIR="${MASTODON_BASE_DIR}/log"

# Mastodon configuration parameters
export MASTODON_MODE="${MASTODON_MODE:-web}"
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"
export MASTODON_CREATE_ADMIN="${MASTODON_CREATE_ADMIN:-true}"
export MASTODON_ADMIN_USERNAME="${MASTODON_ADMIN_USERNAME:-user}"
export MASTODON_ADMIN_PASSWORD="${MASTODON_ADMIN_PASSWORD:-bitnami1}"
export MASTODON_ADMIN_EMAIL="${MASTODON_ADMIN_EMAIL:-user@bitnami.org}"
export MASTODON_ALLOW_ALL_DOMAINS="${MASTODON_ALLOW_ALL_DOMAINS:-true}"
MASTODON_SECRET_KEY_BASE="${MASTODON_SECRET_KEY_BASE:-"${SECRET_KEY_BASE:-}"}"
export MASTODON_SECRET_KEY_BASE="${MASTODON_SECRET_KEY_BASE:-bitnami123}"
export SECRET_KEY_BASE="$MASTODON_SECRET_KEY_BASE"
export MASTODON_CFG_SECRET_KEY_BASE="$MASTODON_SECRET_KEY_BASE"
MASTODON_OTP_SECRET="${MASTODON_OTP_SECRET:-"${OTP_SECRET:-}"}"
export MASTODON_OTP_SECRET="${MASTODON_OTP_SECRET:-bitnami123}"
export OTP_SECRET="$MASTODON_OTP_SECRET"
export MASTODON_CFG_OTP_SECRET="$MASTODON_OTP_SECRET"
export MASTODON_HTTPS_ENABLED="${MASTODON_HTTPS_ENABLED:-false}"
export MASTODON_ASSETS_PRECOMPILE="${MASTODON_ASSETS_PRECOMPILE:-true}"
MASTODON_WEB_DOMAIN="${MASTODON_WEB_DOMAIN:-"${WEB_DOMAIN:-}"}"
export MASTODON_WEB_DOMAIN="${MASTODON_WEB_DOMAIN:-127.0.0.1}"
export WEB_DOMAIN="$MASTODON_WEB_DOMAIN"
export MASTODON_CFG_WEB_DOMAIN="$MASTODON_WEB_DOMAIN"
export MASTODON_WEB_HOST="${MASTODON_WEB_HOST:-mastodon}"
export MASTODON_WEB_PORT_NUMBER="${MASTODON_WEB_PORT_NUMBER:-3000}"
export MASTODON_STREAMING_PORT_NUMBER="${MASTODON_STREAMING_PORT_NUMBER:-4000}"
MASTODON_AUTHORIZED_FETCH="${MASTODON_AUTHORIZED_FETCH:-"${AUTHORIZED_FETCH:-}"}"
export MASTODON_AUTHORIZED_FETCH="${MASTODON_AUTHORIZED_FETCH:-false}"
export AUTHORIZED_FETCH="$MASTODON_AUTHORIZED_FETCH"
export MASTODON_CFG_AUTHORIZED_FETCH="$MASTODON_AUTHORIZED_FETCH"
MASTODON_LIMITED_FEDERATION_MODE="${MASTODON_LIMITED_FEDERATION_MODE:-"${LIMITED_FEDERATION_MODE:-}"}"
export MASTODON_LIMITED_FEDERATION_MODE="${MASTODON_LIMITED_FEDERATION_MODE:-false}"
export LIMITED_FEDERATION_MODE="$MASTODON_LIMITED_FEDERATION_MODE"
export MASTODON_CFG_LIMITED_FEDERATION_MODE="$MASTODON_LIMITED_FEDERATION_MODE"
MASTODON_STREAMING_API_BASE_URL="${MASTODON_STREAMING_API_BASE_URL:-"${STREAMING_API_BASE_URL:-}"}"
export MASTODON_STREAMING_API_BASE_URL="${MASTODON_STREAMING_API_BASE_URL:-ws://localhost:${MASTODON_STREAMING_PORT_NUMBER}}"
export STREAMING_API_BASE_URL="$MASTODON_STREAMING_API_BASE_URL"
export MASTODON_CFG_STREAMING_API_BASE_URL="$MASTODON_STREAMING_API_BASE_URL"
MASTODON_SMTP_LOGIN="${MASTODON_SMTP_LOGIN:-"${SMTP_LOGIN:-}"}"
export MASTODON_SMTP_LOGIN="${MASTODON_SMTP_LOGIN:-5432}"
export SMTP_LOGIN="$MASTODON_SMTP_LOGIN"
export MASTODON_CFG_SMTP_LOGIN="$MASTODON_SMTP_LOGIN"
MASTODON_SMTP_PASSWORD="${MASTODON_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export MASTODON_SMTP_PASSWORD="${MASTODON_SMTP_PASSWORD:-bitnami_mastodon}"
export SMTP_PASSWORD="$MASTODON_SMTP_PASSWORD"
export MASTODON_CFG_SMTP_PASSWORD="$MASTODON_SMTP_PASSWORD"
export RAILS_SERVE_STATIC_FILES="${RAILS_SERVE_STATIC_FILES:-true}"
MASTODON_BIND_ADDRESS="${MASTODON_BIND_ADDRESS:-"${BIND:-}"}"
export MASTODON_BIND_ADDRESS="${MASTODON_BIND_ADDRESS:-0.0.0.0}"
export BIND="$MASTODON_BIND_ADDRESS"
export MASTODON_CFG_BIND="$MASTODON_BIND_ADDRESS"
export MASTODON_DATA_TO_PERSIST="${MASTODON_DATA_TO_PERSIST:-$MASTODON_ASSETS_DIR $MASTODON_SYSTEM_DIR}"
export MASTODON_USE_LIBVIPS="${MASTODON_USE_LIBVIPS:-true}"

# Database configuration
export MASTODON_MIGRATE_DATABASE="${MASTODON_MIGRATE_DATABASE:-true}"
MASTODON_DATABASE_HOST="${MASTODON_DATABASE_HOST:-"${DB_HOST:-}"}"
export MASTODON_DATABASE_HOST="${MASTODON_DATABASE_HOST:-postgresql}"
export DB_HOST="$MASTODON_DATABASE_HOST"
export MASTODON_CFG_DB_HOST="$MASTODON_DATABASE_HOST"
MASTODON_DATABASE_PORT_NUMBER="${MASTODON_DATABASE_PORT_NUMBER:-"${DB_PORT:-}"}"
export MASTODON_DATABASE_PORT_NUMBER="${MASTODON_DATABASE_PORT_NUMBER:-5432}"
export DB_PORT="$MASTODON_DATABASE_PORT_NUMBER"
export MASTODON_CFG_DB_PORT="$MASTODON_DATABASE_PORT_NUMBER"
MASTODON_DATABASE_NAME="${MASTODON_DATABASE_NAME:-"${DB_NAME:-}"}"
export MASTODON_DATABASE_NAME="${MASTODON_DATABASE_NAME:-bitnami_mastodon}"
export DB_NAME="$MASTODON_DATABASE_NAME"
export MASTODON_CFG_DB_NAME="$MASTODON_DATABASE_NAME"
MASTODON_DATABASE_USERNAME="${MASTODON_DATABASE_USERNAME:-"${DB_USER:-}"}"
export MASTODON_DATABASE_USERNAME="${MASTODON_DATABASE_USERNAME:-bn_mastodon}"
export DB_USER="$MASTODON_DATABASE_USERNAME"
export MASTODON_CFG_DB_USER="$MASTODON_DATABASE_USERNAME"
MASTODON_DATABASE_PASSWORD="${MASTODON_DATABASE_PASSWORD:-"${DB_PASS:-}"}"
export MASTODON_DATABASE_PASSWORD="${MASTODON_DATABASE_PASSWORD:-}"
export DB_PASS="$MASTODON_DATABASE_PASSWORD"
export MASTODON_CFG_DB_PASS="$MASTODON_DATABASE_PASSWORD"
MASTODON_DATABASE_POOL="${MASTODON_DATABASE_POOL:-"${DB_POOL:-}"}"
export MASTODON_DATABASE_POOL="${MASTODON_DATABASE_POOL:-5}"
export DB_POOL="$MASTODON_DATABASE_POOL"
export MASTODON_CFG_DB_POOL="$MASTODON_DATABASE_POOL"

# Redis configuration
MASTODON_REDIS_HOST="${MASTODON_REDIS_HOST:-"${REDIS_HOST:-}"}"
export MASTODON_REDIS_HOST="${MASTODON_REDIS_HOST:-redis}"
export REDIS_HOST="$MASTODON_REDIS_HOST"
export MASTODON_CFG_REDIS_HOST="$MASTODON_REDIS_HOST" # only used during the first initialization
MASTODON_REDIS_PORT_NUMBER="${MASTODON_REDIS_PORT_NUMBER:-"${REDIS_PORT:-}"}"
export MASTODON_REDIS_PORT_NUMBER="${MASTODON_REDIS_PORT_NUMBER:-6379}"
export REDIS_PORT="$MASTODON_REDIS_PORT_NUMBER"
export MASTODON_CFG_REDIS_PORT="$MASTODON_REDIS_PORT_NUMBER" # only used during the first initialization
MASTODON_REDIS_PASSWORD="${MASTODON_REDIS_PASSWORD:-"${REDIS_PASSWORD:-}"}"
export MASTODON_REDIS_PASSWORD="${MASTODON_REDIS_PASSWORD:-}"
export REDIS_PASSWORD="$MASTODON_REDIS_PASSWORD"
export MASTODON_CFG_REDIS_PASSWORD="$MASTODON_REDIS_PASSWORD" # only used during the first initialization

# Elasticsearch configuration
MASTODON_ELASTICSEARCH_ENABLED="${MASTODON_ELASTICSEARCH_ENABLED:-"${ES_ENABLED:-}"}"
export MASTODON_ELASTICSEARCH_ENABLED="${MASTODON_ELASTICSEARCH_ENABLED:-true}"
export ES_ENABLED="$MASTODON_ELASTICSEARCH_ENABLED"
export MASTODON_CFG_ES_ENABLED="$MASTODON_ELASTICSEARCH_ENABLED"
export MASTODON_MIGRATE_ELASTICSEARCH="${MASTODON_MIGRATE_ELASTICSEARCH:-true}"
MASTODON_ELASTICSEARCH_HOST="${MASTODON_ELASTICSEARCH_HOST:-"${ES_HOST:-}"}"
export MASTODON_ELASTICSEARCH_HOST="${MASTODON_ELASTICSEARCH_HOST:-elasticsearch}"
export ES_HOST="$MASTODON_ELASTICSEARCH_HOST"
export MASTODON_CFG_ES_HOST="$MASTODON_ELASTICSEARCH_HOST"
MASTODON_ELASTICSEARCH_PORT_NUMBER="${MASTODON_ELASTICSEARCH_PORT_NUMBER:-"${ES_PORT:-}"}"
export MASTODON_ELASTICSEARCH_PORT_NUMBER="${MASTODON_ELASTICSEARCH_PORT_NUMBER:-9200}"
export ES_PORT="$MASTODON_ELASTICSEARCH_PORT_NUMBER"
export MASTODON_CFG_ES_PORT="$MASTODON_ELASTICSEARCH_PORT_NUMBER"
MASTODON_ELASTICSEARCH_USER="${MASTODON_ELASTICSEARCH_USER:-"${ES_USER:-}"}"
export MASTODON_ELASTICSEARCH_USER="${MASTODON_ELASTICSEARCH_USER:-elastic}"
export ES_USER="$MASTODON_ELASTICSEARCH_USER"
export MASTODON_CFG_ES_USER="$MASTODON_ELASTICSEARCH_USER"
MASTODON_ELASTICSEARCH_PASSWORD="${MASTODON_ELASTICSEARCH_PASSWORD:-"${ES_PASS:-}"}"
export MASTODON_ELASTICSEARCH_PASSWORD="${MASTODON_ELASTICSEARCH_PASSWORD:-}"
export ES_PASS="$MASTODON_ELASTICSEARCH_PASSWORD"
export MASTODON_CFG_ES_PASS="$MASTODON_ELASTICSEARCH_PASSWORD"

# S3 configuration
MASTODON_S3_ENABLED="${MASTODON_S3_ENABLED:-"${S3_ENABLED:-}"}"
export MASTODON_S3_ENABLED="${MASTODON_S3_ENABLED:-false}"
export S3_ENABLED="$MASTODON_S3_ENABLED"
export MASTODON_CFG_S3_ENABLED="$MASTODON_S3_ENABLED"
MASTODON_S3_BUCKET="${MASTODON_S3_BUCKET:-"${S3_BUCKET:-}"}"
export MASTODON_S3_BUCKET="${MASTODON_S3_BUCKET:-bitnami_mastodon}"
export S3_BUCKET="$MASTODON_S3_BUCKET"
export MASTODON_CFG_S3_BUCKET="$MASTODON_S3_BUCKET"
MASTODON_S3_HOSTNAME="${MASTODON_S3_HOSTNAME:-"${S3_HOSTNAME:-}"}"
export MASTODON_S3_HOSTNAME="${MASTODON_S3_HOSTNAME:-minio}"
export S3_HOSTNAME="$MASTODON_S3_HOSTNAME"
export MASTODON_CFG_S3_HOSTNAME="$MASTODON_S3_HOSTNAME"
MASTODON_S3_PROTOCOL="${MASTODON_S3_PROTOCOL:-"${S3_PROTOCOL:-}"}"
export MASTODON_S3_PROTOCOL="${MASTODON_S3_PROTOCOL:-http}"
export S3_PROTOCOL="$MASTODON_S3_PROTOCOL"
export MASTODON_CFG_S3_PROTOCOL="$MASTODON_S3_PROTOCOL"
export MASTODON_S3_PORT_NUMBER="${MASTODON_S3_PORT_NUMBER:-9000}"
MASTODON_S3_ALIAS_HOST="${MASTODON_S3_ALIAS_HOST:-"${S3_ALIAS_HOST:-}"}"
export MASTODON_S3_ALIAS_HOST="${MASTODON_S3_ALIAS_HOST:-localhost:${MASTODON_S3_PORT_NUMBER}}"
export S3_ALIAS_HOST="$MASTODON_S3_ALIAS_HOST"
export MASTODON_CFG_S3_ALIAS_HOST="$MASTODON_S3_ALIAS_HOST"
MASTODON_AWS_SECRET_ACCESS_KEY="${MASTODON_AWS_SECRET_ACCESS_KEY:-"${AWS_SECRET_ACCESS_KEY:-}"}"
export MASTODON_AWS_SECRET_ACCESS_KEY="${MASTODON_AWS_SECRET_ACCESS_KEY:-}"
export AWS_SECRET_ACCESS_KEY="$MASTODON_AWS_SECRET_ACCESS_KEY"
export MASTODON_CFG_AWS_SECRET_ACCESS_KEY="$MASTODON_AWS_SECRET_ACCESS_KEY"
MASTODON_AWS_ACCESS_KEY_ID="${MASTODON_AWS_ACCESS_KEY_ID:-"${AWS_ACCESS_KEY_ID:-}"}"
export MASTODON_AWS_ACCESS_KEY_ID="${MASTODON_AWS_ACCESS_KEY_ID:-}"
export AWS_ACCESS_KEY_ID="$MASTODON_AWS_ACCESS_KEY_ID"
export MASTODON_CFG_AWS_ACCESS_KEY_ID="$MASTODON_AWS_ACCESS_KEY_ID"
export MASTODON_S3_REGION="${MASTODON_S3_REGION:-us-east-1}"
MASTODON_S3_ENDPOINT="${MASTODON_S3_ENDPOINT:-"${S3_ENDPOINT:-}"}"
export MASTODON_S3_ENDPOINT="${MASTODON_S3_ENDPOINT:-${MASTODON_S3_PROTOCOL}://${MASTODON_S3_HOSTNAME}:${MASTODON_S3_PORT_NUMBER}}"
export S3_ENDPOINT="$MASTODON_S3_ENDPOINT"
export MASTODON_CFG_S3_ENDPOINT="$MASTODON_S3_ENDPOINT"
export MASTODON_STARTUP_ATTEMPTS="${MASTODON_STARTUP_ATTEMPTS:-40}"

# Rails and node variables
export NODE_ENV="production"
export RAILS_ENV="production"

# Mastodon system parameters
export MASTODON_DAEMON_USER="mastodon"
export MASTODON_DAEMON_GROUP="mastodon"

# Custom environment variables may be defined below
