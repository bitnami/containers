#!/bin/bash
#
# Environment configuration for joomla

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-joomla}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
joomla_env_vars=(
    JOOMLA_DATA_TO_PERSIST
    JOOMLA_LOAD_SAMPLE_DATA
    JOOMLA_SKIP_BOOTSTRAP
    JOOMLA_USERNAME
    JOOMLA_PASSWORD
    JOOMLA_EMAIL
    JOOMLA_SITE_NAME
    JOOMLA_SECRET
    JOOMLA_SMTP_HOST
    JOOMLA_SMTP_PORT_NUMBER
    JOOMLA_SMTP_USER
    JOOMLA_SMTP_PASSWORD
    JOOMLA_SMTP_PROTOCOL
    JOOMLA_DEFAULT_DATABASE_PORT_NUMBER
    JOOMLA_DATABASE_HOST
    JOOMLA_DATABASE_PORT_NUMBER
    JOOMLA_DATABASE_NAME
    JOOMLA_DATABASE_USER
    JOOMLA_DATABASE_PASSWORD
    SMTP_HOST
    SMTP_PORT
    JOOMLA_SMTP_PORT
    SMTP_USER
    SMTP_PASSWORD
    SMTP_PROTOCOL
)
for env_var in "${joomla_env_vars[@]}"; do
    file_env_var="${env_var}_FILE"
    if [[ -n "${!file_env_var:-}" ]]; then
        export "${env_var}=$(< "${!file_env_var}")"
        unset "${file_env_var}"
    fi
done
unset joomla_env_vars

# Paths
export JOOMLA_BASE_DIR="${BITNAMI_ROOT_DIR}/joomla"
export JOOMLA_TMP_DIR="${JOOMLA_BASE_DIR}/tmp"
export JOOMLA_LOGS_DIR="${JOOMLA_BASE_DIR}/logs"
export JOOMLA_CONF_FILE="${JOOMLA_BASE_DIR}/configuration.php"

# Joomla! persistence configuration
export JOOMLA_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/joomla"
export JOOMLA_DATA_TO_PERSIST="${JOOMLA_DATA_TO_PERSIST:-$JOOMLA_BASE_DIR}"

# Joomla! configuration
export JOOMLA_LOAD_SAMPLE_DATA="${JOOMLA_LOAD_SAMPLE_DATA:-yes}" # only used during the first initialization
export JOOMLA_SKIP_BOOTSTRAP="${JOOMLA_SKIP_BOOTSTRAP:-}" # only used during the first initialization

# Joomla! credentials
export JOOMLA_USERNAME="${JOOMLA_USERNAME:-user}" # only used during the first initialization
export JOOMLA_PASSWORD="${JOOMLA_PASSWORD:-bitnami}" # only used during the first initialization
export JOOMLA_EMAIL="${JOOMLA_EMAIL:-user@example.com}" # only used during the first initialization
export JOOMLA_DEFAULT_SITE_NAME="My site" # only used during the first initialization
export JOOMLA_SITE_NAME="${JOOMLA_SITE_NAME:-$JOOMLA_DEFAULT_SITE_NAME}" # only used during the first initialization
export JOOMLA_SECRET="${JOOMLA_SECRET:-}" # only used during the first initialization

# Joomla! SMTP credentials
 # only used during the first initializationJOOMLA_SMTP_HOST="${JOOMLA_SMTP_HOST:-"${SMTP_HOST:-}"}"
export JOOMLA_SMTP_HOST="${JOOMLA_SMTP_HOST:-}"
 # only used during the first initializationJOOMLA_SMTP_PORT_NUMBER="${JOOMLA_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
JOOMLA_SMTP_PORT_NUMBER="${JOOMLA_SMTP_PORT_NUMBER:-"${JOOMLA_SMTP_PORT:-}"}"
export JOOMLA_SMTP_PORT_NUMBER="${JOOMLA_SMTP_PORT_NUMBER:-}"
 # only used during the first initializationJOOMLA_SMTP_USER="${JOOMLA_SMTP_USER:-"${SMTP_USER:-}"}"
export JOOMLA_SMTP_USER="${JOOMLA_SMTP_USER:-}"
 # only used during the first initializationJOOMLA_SMTP_PASSWORD="${JOOMLA_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export JOOMLA_SMTP_PASSWORD="${JOOMLA_SMTP_PASSWORD:-}"
 # only used during the first initializationJOOMLA_SMTP_PROTOCOL="${JOOMLA_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
export JOOMLA_SMTP_PROTOCOL="${JOOMLA_SMTP_PROTOCOL:-}"

# Database configuration
export JOOMLA_DEFAULT_DATABASE_HOST="mariadb" # only used at build time
export JOOMLA_DEFAULT_DATABASE_PORT_NUMBER="${JOOMLA_DEFAULT_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
export JOOMLA_DATABASE_HOST="${JOOMLA_DATABASE_HOST:-$JOOMLA_DEFAULT_DATABASE_HOST}" # only used during the first initialization
export JOOMLA_DATABASE_PORT_NUMBER="${JOOMLA_DATABASE_PORT_NUMBER:-$JOOMLA_DEFAULT_DATABASE_PORT_NUMBER}" # only used during the first initialization
export JOOMLA_DATABASE_NAME="${JOOMLA_DATABASE_NAME:-bitnami_joomla}" # only used during the first initialization
export JOOMLA_DATABASE_USER="${JOOMLA_DATABASE_USER:-bn_joomla}" # only used during the first initialization
export JOOMLA_DATABASE_PASSWORD="${JOOMLA_DATABASE_PASSWORD:-}" # only used during the first initialization

# PHP configuration
export PHP_DEFAULT_MEMORY_LIMIT="256M" # only used at build time

# Custom environment variables may be defined below
