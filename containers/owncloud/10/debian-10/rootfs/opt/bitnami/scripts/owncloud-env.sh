#!/bin/bash
#
# Environment configuration for owncloud

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
export MODULE="${MODULE:-owncloud}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
owncloud_env_vars=(
    OWNCLOUD_DATA_DIR
    OWNCLOUD_DATA_TO_PERSIST
    OWNCLOUD_HOST
    OWNCLOUD_SKIP_BOOTSTRAP
    OWNCLOUD_EMAIL
    OWNCLOUD_USERNAME
    OWNCLOUD_PASSWORD
    OWNCLOUD_SMTP_HOST
    OWNCLOUD_SMTP_PORT_NUMBER
    OWNCLOUD_SMTP_USER
    OWNCLOUD_SMTP_PASSWORD
    OWNCLOUD_SMTP_PROTOCOL
    OWNCLOUD_DATABASE_TYPE
    OWNCLOUD_DATABASE_HOST
    OWNCLOUD_DATABASE_PORT_NUMBER
    OWNCLOUD_DATABASE_NAME
    OWNCLOUD_DATABASE_USER
    OWNCLOUD_DATABASE_PASSWORD
    SMTP_HOST
    SMTP_PORT
    OWNCLOUD_SMTP_PORT
    SMTP_USER
    SMTP_PASSWORD
    SMTP_PROTOCOL
    MARIADB_HOST
    MARIADB_PORT_NUMBER
    MARIADB_DATABASE_NAME
    MARIADB_DATABASE_USER
    MARIADB_DATABASE_PASSWORD
)
for env_var in "${owncloud_env_vars[@]}"; do
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
unset owncloud_env_vars

# Paths
export OWNCLOUD_BASE_DIR="${BITNAMI_ROOT_DIR}/owncloud"
export OWNCLOUD_CONF_FILE="${OWNCLOUD_BASE_DIR}/config/config.php"

# ownCloud persistence configuration
export OWNCLOUD_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/owncloud"
export OWNCLOUD_DATA_DIR="${OWNCLOUD_DATA_DIR:-${OWNCLOUD_VOLUME_DIR}/data}"
export OWNCLOUD_DATA_TO_PERSIST="${OWNCLOUD_DATA_TO_PERSIST:-config/config.php apps-external}"

# ownCloud configuration
export OWNCLOUD_HOST="${OWNCLOUD_HOST:-}"
export OWNCLOUD_SKIP_BOOTSTRAP="${OWNCLOUD_SKIP_BOOTSTRAP:-no}" # only used during the first initialization

# ownCloud credentials
export OWNCLOUD_EMAIL="${OWNCLOUD_EMAIL:-user@example.com}" # only used during the first initialization
export OWNCLOUD_USERNAME="${OWNCLOUD_USERNAME:-user}" # only used during the first initialization
export OWNCLOUD_PASSWORD="${OWNCLOUD_PASSWORD:-bitnami}" # only used during the first initialization

# ownCloud SMTP credentials
OWNCLOUD_SMTP_HOST="${OWNCLOUD_SMTP_HOST:-"${SMTP_HOST:-}"}"
export OWNCLOUD_SMTP_HOST="${OWNCLOUD_SMTP_HOST:-}" # only used during the first initialization
OWNCLOUD_SMTP_PORT_NUMBER="${OWNCLOUD_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
OWNCLOUD_SMTP_PORT_NUMBER="${OWNCLOUD_SMTP_PORT_NUMBER:-"${OWNCLOUD_SMTP_PORT:-}"}"
export OWNCLOUD_SMTP_PORT_NUMBER="${OWNCLOUD_SMTP_PORT_NUMBER:-}" # only used during the first initialization
OWNCLOUD_SMTP_USER="${OWNCLOUD_SMTP_USER:-"${SMTP_USER:-}"}"
export OWNCLOUD_SMTP_USER="${OWNCLOUD_SMTP_USER:-}" # only used during the first initialization
OWNCLOUD_SMTP_PASSWORD="${OWNCLOUD_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export OWNCLOUD_SMTP_PASSWORD="${OWNCLOUD_SMTP_PASSWORD:-}" # only used during the first initialization
OWNCLOUD_SMTP_PROTOCOL="${OWNCLOUD_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
export OWNCLOUD_SMTP_PROTOCOL="${OWNCLOUD_SMTP_PROTOCOL:-}" # only used during the first initialization

# Database configuration
export OWNCLOUD_DATABASE_TYPE="${OWNCLOUD_DATABASE_TYPE:-mysql}" # only used during the first initialization
export OWNCLOUD_DEFAULT_DATABASE_HOST="mariadb" # only used at build time
OWNCLOUD_DATABASE_HOST="${OWNCLOUD_DATABASE_HOST:-"${MARIADB_HOST:-}"}"
export OWNCLOUD_DATABASE_HOST="${OWNCLOUD_DATABASE_HOST:-$OWNCLOUD_DEFAULT_DATABASE_HOST}" # only used during the first initialization
OWNCLOUD_DATABASE_PORT_NUMBER="${OWNCLOUD_DATABASE_PORT_NUMBER:-"${MARIADB_PORT_NUMBER:-}"}"
export OWNCLOUD_DATABASE_PORT_NUMBER="${OWNCLOUD_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
OWNCLOUD_DATABASE_NAME="${OWNCLOUD_DATABASE_NAME:-"${MARIADB_DATABASE_NAME:-}"}"
export OWNCLOUD_DATABASE_NAME="${OWNCLOUD_DATABASE_NAME:-bitnami_owncloud}" # only used during the first initialization
OWNCLOUD_DATABASE_USER="${OWNCLOUD_DATABASE_USER:-"${MARIADB_DATABASE_USER:-}"}"
export OWNCLOUD_DATABASE_USER="${OWNCLOUD_DATABASE_USER:-bn_owncloud}" # only used during the first initialization
OWNCLOUD_DATABASE_PASSWORD="${OWNCLOUD_DATABASE_PASSWORD:-"${MARIADB_DATABASE_PASSWORD:-}"}"
export OWNCLOUD_DATABASE_PASSWORD="${OWNCLOUD_DATABASE_PASSWORD:-}" # only used during the first initialization

# PHP configuration
export PHP_DEFAULT_MEMORY_LIMIT="512M" # only used at build time
export PHP_DEFAULT_POST_MAX_SIZE="2G" # only used at build time
export PHP_DEFAULT_UPLOAD_MAX_FILESIZE="2G" # only used at build time

# Custom environment variables may be defined below
