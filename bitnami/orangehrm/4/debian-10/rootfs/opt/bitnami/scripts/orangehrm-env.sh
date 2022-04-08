#!/bin/bash
#
# Environment configuration for orangehrm

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
export MODULE="${MODULE:-orangehrm}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
orangehrm_env_vars=(
    ORANGEHRM_DATA_TO_PERSIST
    ORANGEHRM_SKIP_BOOTSTRAP
    ORANGEHRM_USERNAME
    ORANGEHRM_PASSWORD
    ORANGEHRM_ENFORCE_PASSWORD_STRENGTH
    ORANGEHRM_SMTP_HOST
    ORANGEHRM_SMTP_PORT_NUMBER
    ORANGEHRM_SMTP_USER
    ORANGEHRM_SMTP_PASSWORD
    ORANGEHRM_SMTP_PROTOCOL
    ORANGEHRM_DATABASE_HOST
    ORANGEHRM_DATABASE_PORT_NUMBER
    ORANGEHRM_DATABASE_NAME
    ORANGEHRM_DATABASE_USER
    ORANGEHRM_DATABASE_PASSWORD
    SMTP_HOST
    SMTP_PORT
    ORANGEHRM_SMTP_PORT
    SMTP_USER
    SMTP_PASSWORD
    SMTP_PROTOCOL
)
for env_var in "${orangehrm_env_vars[@]}"; do
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
unset orangehrm_env_vars

# Paths
export ORANGEHRM_BASE_DIR="${BITNAMI_ROOT_DIR}/orangehrm"
export ORANGEHRM_CONF_FILE="${ORANGEHRM_BASE_DIR}/lib/confs/Conf.php"
export ORANGEHRM_DATABASE_CONF_FILE="${ORANGEHRM_BASE_DIR}/symfony/config/databases.yml"

# OrangeHRM persistence configuration
export ORANGEHRM_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/orangehrm"
export ORANGEHRM_DATA_TO_PERSIST="${ORANGEHRM_DATA_TO_PERSIST:-lib/confs/Conf.php symfony/config/databases.yml}"

# OrangeHRM configuration
export ORANGEHRM_SKIP_BOOTSTRAP="${ORANGEHRM_SKIP_BOOTSTRAP:-}" # only used during the first initialization

# OrangeHRM credentials
export ORANGEHRM_USERNAME="${ORANGEHRM_USERNAME:-admin}" # only used during the first initialization
export ORANGEHRM_PASSWORD="${ORANGEHRM_PASSWORD:-Bitnami.12345}" # only used during the first initialization
export ORANGEHRM_ENFORCE_PASSWORD_STRENGTH="${ORANGEHRM_ENFORCE_PASSWORD_STRENGTH:-yes}" # only used during the first initialization

# OrangeHRM SMTP credentials
ORANGEHRM_SMTP_HOST="${ORANGEHRM_SMTP_HOST:-"${SMTP_HOST:-}"}"
export ORANGEHRM_SMTP_HOST="${ORANGEHRM_SMTP_HOST:-}" # only used during the first initialization
ORANGEHRM_SMTP_PORT_NUMBER="${ORANGEHRM_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
ORANGEHRM_SMTP_PORT_NUMBER="${ORANGEHRM_SMTP_PORT_NUMBER:-"${ORANGEHRM_SMTP_PORT:-}"}"
export ORANGEHRM_SMTP_PORT_NUMBER="${ORANGEHRM_SMTP_PORT_NUMBER:-}" # only used during the first initialization
ORANGEHRM_SMTP_USER="${ORANGEHRM_SMTP_USER:-"${SMTP_USER:-}"}"
export ORANGEHRM_SMTP_USER="${ORANGEHRM_SMTP_USER:-}" # only used during the first initialization
ORANGEHRM_SMTP_PASSWORD="${ORANGEHRM_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export ORANGEHRM_SMTP_PASSWORD="${ORANGEHRM_SMTP_PASSWORD:-}" # only used during the first initialization
ORANGEHRM_SMTP_PROTOCOL="${ORANGEHRM_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
export ORANGEHRM_SMTP_PROTOCOL="${ORANGEHRM_SMTP_PROTOCOL:-}" # only used during the first initialization

# Database configuration
export ORANGEHRM_DEFAULT_DATABASE_HOST="mariadb" # only used at build time
export ORANGEHRM_DATABASE_HOST="${ORANGEHRM_DATABASE_HOST:-$ORANGEHRM_DEFAULT_DATABASE_HOST}" # only used during the first initialization
export ORANGEHRM_DATABASE_PORT_NUMBER="${ORANGEHRM_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
export ORANGEHRM_DATABASE_NAME="${ORANGEHRM_DATABASE_NAME:-bitnami_orangehrm}" # only used during the first initialization
export ORANGEHRM_DATABASE_USER="${ORANGEHRM_DATABASE_USER:-bn_orangehrm}" # only used during the first initialization
export ORANGEHRM_DATABASE_PASSWORD="${ORANGEHRM_DATABASE_PASSWORD:-}" # only used during the first initialization

# PHP configuration
export PHP_DEFAULT_MEMORY_LIMIT="256M" # only used at build time

# Custom environment variables may be defined below
