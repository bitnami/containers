#!/bin/bash
#
# Environment configuration for laravel

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

# Load logging library
. /opt/bitnami/scripts/liblog.sh

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-laravel}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
laravel_env_vars=(
    LARAVEL_PORT_NUMBER
    LARAVEL_SKIP_COMPOSER_UPDATE
    LARAVEL_SKIP_DATABASE
    LARAVEL_DATABASE_TYPE
    LARAVEL_DATABASE_HOST
    LARAVEL_DATABASE_PORT_NUMBER
    LARAVEL_DATABASE_NAME
    LARAVEL_DATABASE_USER
    LARAVEL_DATABASE_PASSWORD
    SKIP_COMPOSER_UPDATE
    DB_CONNECTION
    DB_HOST
    DB_PORT
    DB_DATABASE
    DB_USERNAME
    DB_PASSWORD
)
for env_var in "${laravel_env_vars[@]}"; do
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
unset laravel_env_vars

# Paths
export LARAVEL_BASE_DIR="${BITNAMI_ROOT_DIR}/laravel"

# Laravel configuration
export LARAVEL_PORT_NUMBER="${LARAVEL_PORT_NUMBER:-8000}"
LARAVEL_SKIP_COMPOSER_UPDATE="${LARAVEL_SKIP_COMPOSER_UPDATE:-"${SKIP_COMPOSER_UPDATE:-}"}"
export LARAVEL_SKIP_COMPOSER_UPDATE="${LARAVEL_SKIP_COMPOSER_UPDATE:-no}"
export LARAVEL_SKIP_DATABASE="${LARAVEL_SKIP_DATABASE:-no}" # only used during the first initialization

# Database configuration
LARAVEL_DATABASE_TYPE="${LARAVEL_DATABASE_TYPE:-"${DB_CONNECTION:-}"}"
export LARAVEL_DATABASE_TYPE="${LARAVEL_DATABASE_TYPE:-mariadb}" # only used during the first initialization
LARAVEL_DATABASE_HOST="${LARAVEL_DATABASE_HOST:-"${DB_HOST:-}"}"
export LARAVEL_DATABASE_HOST="${LARAVEL_DATABASE_HOST:-mariadb}" # only used during the first initialization
LARAVEL_DATABASE_PORT_NUMBER="${LARAVEL_DATABASE_PORT_NUMBER:-"${DB_PORT:-}"}"
export LARAVEL_DATABASE_PORT_NUMBER="${LARAVEL_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
LARAVEL_DATABASE_NAME="${LARAVEL_DATABASE_NAME:-"${DB_DATABASE:-}"}"
export LARAVEL_DATABASE_NAME="${LARAVEL_DATABASE_NAME:-bitnami_myapp}" # only used during the first initialization
LARAVEL_DATABASE_USER="${LARAVEL_DATABASE_USER:-"${DB_USERNAME:-}"}"
export LARAVEL_DATABASE_USER="${LARAVEL_DATABASE_USER:-bn_myapp}" # only used during the first initialization
LARAVEL_DATABASE_PASSWORD="${LARAVEL_DATABASE_PASSWORD:-"${DB_PASSWORD:-}"}"
export LARAVEL_DATABASE_PASSWORD="${LARAVEL_DATABASE_PASSWORD:-}" # only used during the first initialization

# Custom environment variables may be defined below
