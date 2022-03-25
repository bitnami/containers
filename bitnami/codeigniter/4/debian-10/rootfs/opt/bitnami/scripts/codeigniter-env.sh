#!/bin/bash
#
# Environment configuration for codeigniter

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
export MODULE="${MODULE:-codeigniter}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
codeigniter_env_vars=(
    CODEIGNITER_PORT_NUMBER
    CODEIGNITER_PROJECT_NAME
    CODEIGNITER_SKIP_DATABASE
    CODEIGNITER_DATABASE_HOST
    CODEIGNITER_DATABASE_PORT_NUMBER
    CODEIGNITER_DATABASE_NAME
    CODEIGNITER_DATABASE_USER
    CODEIGNITER_DATABASE_PASSWORD
    MARIADB_HOST
    MARIADB_PORT_NUMBER
    MARIADB_DATABASE_NAME
    MARIADB_DATABASE_USER
    MARIADB_DATABASE_PASSWORD
)
for env_var in "${codeigniter_env_vars[@]}"; do
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
unset codeigniter_env_vars

# Paths
export CODEIGNITER_BASE_DIR="${BITNAMI_ROOT_DIR}/codeigniter"

# CodeIgniter configuration
export CODEIGNITER_PORT_NUMBER="${CODEIGNITER_PORT_NUMBER:-8000}"
export CODEIGNITER_PROJECT_NAME="${CODEIGNITER_PROJECT_NAME:-myapp}"
export CODEIGNITER_SKIP_DATABASE="${CODEIGNITER_SKIP_DATABASE:-no}" # only used during the first initialization

# Database configuration
CODEIGNITER_DATABASE_HOST="${CODEIGNITER_DATABASE_HOST:-"${MARIADB_HOST:-}"}"
export CODEIGNITER_DATABASE_HOST="${CODEIGNITER_DATABASE_HOST:-mariadb}" # only used during the first initialization
CODEIGNITER_DATABASE_PORT_NUMBER="${CODEIGNITER_DATABASE_PORT_NUMBER:-"${MARIADB_PORT_NUMBER:-}"}"
export CODEIGNITER_DATABASE_PORT_NUMBER="${CODEIGNITER_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
CODEIGNITER_DATABASE_NAME="${CODEIGNITER_DATABASE_NAME:-"${MARIADB_DATABASE_NAME:-}"}"
export CODEIGNITER_DATABASE_NAME="${CODEIGNITER_DATABASE_NAME:-bitnami_myapp}" # only used during the first initialization
CODEIGNITER_DATABASE_USER="${CODEIGNITER_DATABASE_USER:-"${MARIADB_DATABASE_USER:-}"}"
export CODEIGNITER_DATABASE_USER="${CODEIGNITER_DATABASE_USER:-bn_myapp}" # only used during the first initialization
CODEIGNITER_DATABASE_PASSWORD="${CODEIGNITER_DATABASE_PASSWORD:-"${MARIADB_DATABASE_PASSWORD:-}"}"
export CODEIGNITER_DATABASE_PASSWORD="${CODEIGNITER_DATABASE_PASSWORD:-}" # only used during the first initialization

# Custom environment variables may be defined below
