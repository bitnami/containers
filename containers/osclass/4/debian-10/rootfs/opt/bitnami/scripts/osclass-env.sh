#!/bin/bash
#
# Environment configuration for osclass

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
export MODULE="${MODULE:-osclass}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
osclass_env_vars=(
    OSCLASS_DATA_TO_PERSIST
    OSCLASS_HOST
    OSCLASS_SKIP_BOOTSTRAP
    OSCLASS_USERNAME
    OSCLASS_PASSWORD
    OSCLASS_EMAIL
    OSCLASS_WEB_TITLE
    OSCLASS_SMTP_HOST
    OSCLASS_SMTP_PORT_NUMBER
    OSCLASS_SMTP_USER
    OSCLASS_SMTP_PASSWORD
    OSCLASS_SMTP_PROTOCOL
    OSCLASS_DATABASE_HOST
    OSCLASS_DATABASE_PORT_NUMBER
    OSCLASS_DATABASE_NAME
    OSCLASS_DATABASE_USER
    OSCLASS_DATABASE_PASSWORD
    SMTP_HOST
    SMTP_PORT
    OSCLASS_SMTP_PORT
    SMTP_USER
    SMTP_PASSWORD
    SMTP_PROTOCOL
    MARIADB_HOST
    MARIADB_PORT_NUMBER
    MARIADB_DATABASE_NAME
    MARIADB_DATABASE_USER
    MARIADB_DATABASE_PASSWORD
)
for env_var in "${osclass_env_vars[@]}"; do
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
unset osclass_env_vars

# Paths
export OSCLASS_BASE_DIR="${BITNAMI_ROOT_DIR}/osclass"
export OSCLASS_CONF_FILE="${OSCLASS_BASE_DIR}/config.php"

# Osclass persistence configuration
export OSCLASS_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/osclass"
export OSCLASS_DATA_TO_PERSIST="${OSCLASS_DATA_TO_PERSIST:-config.php oc-content/uploads oc-content/downloads oc-content/languages oc-content/plugins oc-content/themes}"

# Osclass configuration
export OSCLASS_HOST="${OSCLASS_HOST:-}" # only used during the first initialization
export OSCLASS_SKIP_BOOTSTRAP="${OSCLASS_SKIP_BOOTSTRAP:-}" # only used during the first initialization

# Osclass credentials
export OSCLASS_USERNAME="${OSCLASS_USERNAME:-user}" # only used during the first initialization
export OSCLASS_PASSWORD="${OSCLASS_PASSWORD:-bitnami}" # only used during the first initialization
export OSCLASS_EMAIL="${OSCLASS_EMAIL:-user@example.com}" # only used during the first initialization
export OSCLASS_WEB_TITLE="${OSCLASS_WEB_TITLE:-Sample Web Page}" # only used during the first initialization

# Osclass SMTP credentials
OSCLASS_SMTP_HOST="${OSCLASS_SMTP_HOST:-"${SMTP_HOST:-}"}"
export OSCLASS_SMTP_HOST="${OSCLASS_SMTP_HOST:-}" # only used during the first initialization
OSCLASS_SMTP_PORT_NUMBER="${OSCLASS_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
OSCLASS_SMTP_PORT_NUMBER="${OSCLASS_SMTP_PORT_NUMBER:-"${OSCLASS_SMTP_PORT:-}"}"
export OSCLASS_SMTP_PORT_NUMBER="${OSCLASS_SMTP_PORT_NUMBER:-}" # only used during the first initialization
OSCLASS_SMTP_USER="${OSCLASS_SMTP_USER:-"${SMTP_USER:-}"}"
export OSCLASS_SMTP_USER="${OSCLASS_SMTP_USER:-}" # only used during the first initialization
OSCLASS_SMTP_PASSWORD="${OSCLASS_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export OSCLASS_SMTP_PASSWORD="${OSCLASS_SMTP_PASSWORD:-}" # only used during the first initialization
OSCLASS_SMTP_PROTOCOL="${OSCLASS_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
export OSCLASS_SMTP_PROTOCOL="${OSCLASS_SMTP_PROTOCOL:-}" # only used during the first initialization

# Database configuration
export OSCLASS_DEFAULT_DATABASE_HOST="mariadb" # only used at build time
OSCLASS_DATABASE_HOST="${OSCLASS_DATABASE_HOST:-"${MARIADB_HOST:-}"}"
export OSCLASS_DATABASE_HOST="${OSCLASS_DATABASE_HOST:-$OSCLASS_DEFAULT_DATABASE_HOST}" # only used during the first initialization
OSCLASS_DATABASE_PORT_NUMBER="${OSCLASS_DATABASE_PORT_NUMBER:-"${MARIADB_PORT_NUMBER:-}"}"
export OSCLASS_DATABASE_PORT_NUMBER="${OSCLASS_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
OSCLASS_DATABASE_NAME="${OSCLASS_DATABASE_NAME:-"${MARIADB_DATABASE_NAME:-}"}"
export OSCLASS_DATABASE_NAME="${OSCLASS_DATABASE_NAME:-bitnami_osclass}" # only used during the first initialization
OSCLASS_DATABASE_USER="${OSCLASS_DATABASE_USER:-"${MARIADB_DATABASE_USER:-}"}"
export OSCLASS_DATABASE_USER="${OSCLASS_DATABASE_USER:-bn_osclass}" # only used during the first initialization
OSCLASS_DATABASE_PASSWORD="${OSCLASS_DATABASE_PASSWORD:-"${MARIADB_DATABASE_PASSWORD:-}"}"
export OSCLASS_DATABASE_PASSWORD="${OSCLASS_DATABASE_PASSWORD:-}" # only used during the first initialization

# PHP configuration
export PHP_DEFAULT_MEMORY_LIMIT="256M" # only used at build time

# Custom environment variables may be defined below
