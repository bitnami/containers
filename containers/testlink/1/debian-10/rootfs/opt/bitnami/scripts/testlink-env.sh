#!/bin/bash
#
# Environment configuration for testlink

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-testlink}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
testlink_env_vars=(
    TESTLINK_DATA_TO_PERSIST
    TESTLINK_LANGUAGE
    TESTLINK_SKIP_BOOTSTRAP
    TESTLINK_USERNAME
    TESTLINK_PASSWORD
    TESTLINK_EMAIL
    TESTLINK_SMTP_HOST
    TESTLINK_SMTP_PORT_NUMBER
    TESTLINK_SMTP_USER
    TESTLINK_SMTP_PASSWORD
    TESTLINK_SMTP_PROTOCOL
    TESTLINK_DATABASE_HOST
    TESTLINK_DATABASE_PORT_NUMBER
    TESTLINK_DATABASE_NAME
    TESTLINK_DATABASE_USER
    TESTLINK_DATABASE_PASSWORD
    SMTP_HOST
    SMTP_PORT
    TESTLINK_SMTP_PORT
    SMTP_USER
    SMTP_PASSWORD
    SMTP_PROTOCOL
    SMTP_CONNECTION_MODE
)
for env_var in "${testlink_env_vars[@]}"; do
    file_env_var="${env_var}_FILE"
    if [[ -n "${!file_env_var:-}" ]]; then
        export "${env_var}=$(< "${!file_env_var}")"
        unset "${file_env_var}"
    fi
done
unset testlink_env_vars

# Paths
export TESTLINK_BASE_DIR="${BITNAMI_ROOT_DIR}/testlink"
export TESTLINK_CONF_FILE="${TESTLINK_BASE_DIR}/config.inc.php"
export TESTLINK_CUSTOM_CONF_FILE="${TESTLINK_BASE_DIR}/custom_config.inc.php"
export TESTLINK_DATABASE_CONF_FILE="${TESTLINK_BASE_DIR}/config_db.inc.php"

# TestLink persistence configuration
export TESTLINK_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/testlink"
export TESTLINK_MOUNTED_CUSTOM_CONF_FILE="${TESTLINK_VOLUME_DIR}/custom_config.inc.php"
export TESTLINK_MOUNTED_DATABASE_CONF_FILE="${TESTLINK_VOLUME_DIR}/config_db.inc.php"
export TESTLINK_DATA_TO_PERSIST="${TESTLINK_DATA_TO_PERSIST:-upload_area}"

# TestLink configuration
export TESTLINK_LANGUAGE="${TESTLINK_LANGUAGE:-en_US}" # only used during the first initialization
export TESTLINK_SKIP_BOOTSTRAP="${TESTLINK_SKIP_BOOTSTRAP:-}" # only used during the first initialization

# TestLink credentials
export TESTLINK_USERNAME="${TESTLINK_USERNAME:-user}" # only used during the first initialization
export TESTLINK_PASSWORD="${TESTLINK_PASSWORD:-bitnami}" # only used during the first initialization
export TESTLINK_EMAIL="${TESTLINK_EMAIL:-user@example.com}" # only used during the first initialization

# TestLink SMTP credentials
TESTLINK_SMTP_HOST="${TESTLINK_SMTP_HOST:-"${SMTP_HOST:-}"}"
export TESTLINK_SMTP_HOST="${TESTLINK_SMTP_HOST:-}"
TESTLINK_SMTP_PORT_NUMBER="${TESTLINK_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
TESTLINK_SMTP_PORT_NUMBER="${TESTLINK_SMTP_PORT_NUMBER:-"${TESTLINK_SMTP_PORT:-}"}"
export TESTLINK_SMTP_PORT_NUMBER="${TESTLINK_SMTP_PORT_NUMBER:-}"
TESTLINK_SMTP_USER="${TESTLINK_SMTP_USER:-"${SMTP_USER:-}"}"
export TESTLINK_SMTP_USER="${TESTLINK_SMTP_USER:-}"
TESTLINK_SMTP_PASSWORD="${TESTLINK_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export TESTLINK_SMTP_PASSWORD="${TESTLINK_SMTP_PASSWORD:-}"
TESTLINK_SMTP_PROTOCOL="${TESTLINK_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
TESTLINK_SMTP_PROTOCOL="${TESTLINK_SMTP_PROTOCOL:-"${SMTP_CONNECTION_MODE:-}"}"
export TESTLINK_SMTP_PROTOCOL="${TESTLINK_SMTP_PROTOCOL:-}"

# Database configuration
export TESTLINK_DEFAULT_DATABASE_HOST="mariadb" # only used at build time
export TESTLINK_DATABASE_HOST="${TESTLINK_DATABASE_HOST:-$TESTLINK_DEFAULT_DATABASE_HOST}" # only used during the first initialization
export TESTLINK_DATABASE_PORT_NUMBER="${TESTLINK_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
export TESTLINK_DATABASE_NAME="${TESTLINK_DATABASE_NAME:-bitnami_testlink}" # only used during the first initialization
export TESTLINK_DATABASE_USER="${TESTLINK_DATABASE_USER:-bn_testlink}" # only used during the first initialization
export TESTLINK_DATABASE_PASSWORD="${TESTLINK_DATABASE_PASSWORD:-}" # only used during the first initialization

# PHP configuration
export PHP_DEFAULT_MEMORY_LIMIT="256M" # only used at build time

# Custom environment variables may be defined below
