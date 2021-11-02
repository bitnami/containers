#!/bin/bash
#
# Environment configuration for symfony

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
export MODULE="${MODULE:-symfony}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
symfony_env_vars=(
    SYMFONY_PORT_NUMBER
    SYMFONY_PROJECT_SKELETON
    SYMFONY_SKIP_DATABASE
    SYMFONY_DATABASE_HOST
    SYMFONY_DATABASE_PORT_NUMBER
    SYMFONY_DATABASE_NAME
    SYMFONY_DATABASE_USER
    SYMFONY_DATABASE_PASSWORD
    MARIADB_HOST
    MARIADB_PORT_NUMBER
    MARIADB_DATABASE_NAME
    MARIADB_DATABASE_USER
    MARIADB_DATABASE_PASSWORD
)
for env_var in "${symfony_env_vars[@]}"; do
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
unset symfony_env_vars

# Paths
export SYMFONY_BASE_DIR="${BITNAMI_ROOT_DIR}/symfony"
export SYMFONY_SKELETON_DIR="${SYMFONY_BASE_DIR}/skeleton"
export SYMFONY_WEB_SKELETON_DIR="${SYMFONY_BASE_DIR}/website-skeleton"

# Symfony configuration
export SYMFONY_PORT_NUMBER="${SYMFONY_PORT_NUMBER:-8000}"
export SYMFONY_PROJECT_SKELETON="${SYMFONY_PROJECT_SKELETON:-symfony/website-skeleton}"
export SYMFONY_SKIP_DATABASE="${SYMFONY_SKIP_DATABASE:-no}" # only used during the first initialization

# Database configuration
SYMFONY_DATABASE_HOST="${SYMFONY_DATABASE_HOST:-"${MARIADB_HOST:-}"}"
export SYMFONY_DATABASE_HOST="${SYMFONY_DATABASE_HOST:-mariadb}" # only used during the first initialization
SYMFONY_DATABASE_PORT_NUMBER="${SYMFONY_DATABASE_PORT_NUMBER:-"${MARIADB_PORT_NUMBER:-}"}"
export SYMFONY_DATABASE_PORT_NUMBER="${SYMFONY_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
SYMFONY_DATABASE_NAME="${SYMFONY_DATABASE_NAME:-"${MARIADB_DATABASE_NAME:-}"}"
export SYMFONY_DATABASE_NAME="${SYMFONY_DATABASE_NAME:-bitnami_myapp}" # only used during the first initialization
SYMFONY_DATABASE_USER="${SYMFONY_DATABASE_USER:-"${MARIADB_DATABASE_USER:-}"}"
export SYMFONY_DATABASE_USER="${SYMFONY_DATABASE_USER:-bn_myapp}" # only used during the first initialization
SYMFONY_DATABASE_PASSWORD="${SYMFONY_DATABASE_PASSWORD:-"${MARIADB_DATABASE_PASSWORD:-}"}"
export SYMFONY_DATABASE_PASSWORD="${SYMFONY_DATABASE_PASSWORD:-}" # only used during the first initialization

# Custom environment variables may be defined below
