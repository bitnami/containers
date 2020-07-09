#!/bin/bash
#
# Environment configuration for moodle

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-moodle}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
moodle_env_vars=(
    MOODLE_DATA_TO_PERSIST
    MOODLE_SKIP_BOOTSTRAP
    MOODLE_INSTALL_EXTRA_ARGS
    MOODLE_SITE_NAME
    MOODLE_USERNAME
    MOODLE_PASSWORD
    MOODLE_EMAIL
    MOODLE_SMTP_HOST
    MOODLE_SMTP_PORT_NUMBER
    MOODLE_SMTP_USER
    MOODLE_SMTP_PASSWORD
    MOODLE_SMTP_PROTOCOL
    MOODLE_DATABASE_TYPE
    MOODLE_DATABASE_HOST
    MOODLE_DATABASE_PORT_NUMBER
    MOODLE_DATABASE_NAME
    MOODLE_DATABASE_USER
    MOODLE_DATABASE_PASSWORD

)
for env_var in "${moodle_env_vars[@]}"; do
    file_env_var="${env_var}_FILE"
    if [[ -n "${!file_env_var:-}" ]]; then
        export "${env_var}=$(< "${!file_env_var}")"
        unset "${file_env_var}"
    fi
done
unset moodle_env_vars

# Paths
export MOODLE_BASE_DIR="${BITNAMI_ROOT_DIR}/moodle"
export MOODLE_CONF_FILE="${MOODLE_BASE_DIR}/config.php"

# Moodle persistence configuration
export MOODLE_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/moodle"
export MOODLE_DATA_DIR="${BITNAMI_VOLUME_DIR}/moodledata"
export MOODLE_DATA_TO_PERSIST="${MOODLE_DATA_TO_PERSIST:-$MOODLE_BASE_DIR}"

# Moodle configuration
 # only used during the first initialization
export MOODLE_SKIP_BOOTSTRAP="${MOODLE_SKIP_BOOTSTRAP:-"${MOODLE_SKIP_INSTALL:-}"}"
export MOODLE_SKIP_BOOTSTRAP="${MOODLE_SKIP_BOOTSTRAP:-}"
export MOODLE_INSTALL_EXTRA_ARGS="${MOODLE_INSTALL_EXTRA_ARGS:-}" # only used during the first initialization
export MOODLE_SITE_NAME="${MOODLE_SITE_NAME:-New Site}" # only used during the first initialization

# Moodle credentials
export MOODLE_USERNAME="${MOODLE_USERNAME:-user}" # only used during the first initialization
export MOODLE_PASSWORD="${MOODLE_PASSWORD:-bitnami}" # only used during the first initialization
export MOODLE_EMAIL="${MOODLE_EMAIL:-user@example.com}" # only used during the first initialization

# Moodle SMTP credentials
 # only used during the first initialization
export MOODLE_SMTP_HOST="${MOODLE_SMTP_HOST:-"${SMTP_HOST:-}"}"
export MOODLE_SMTP_HOST="${MOODLE_SMTP_HOST:-}"
 # only used during the first initialization
export MOODLE_SMTP_PORT_NUMBER="${MOODLE_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
export MOODLE_SMTP_PORT_NUMBER="${MOODLE_SMTP_PORT_NUMBER:-"${MOODLE_SMTP_PORT:-}"}"
export MOODLE_SMTP_PORT_NUMBER="${MOODLE_SMTP_PORT_NUMBER:-}"
 # only used during the first initialization
export MOODLE_SMTP_USER="${MOODLE_SMTP_USER:-"${SMTP_USER:-}"}"
export MOODLE_SMTP_USER="${MOODLE_SMTP_USER:-}"
 # only used during the first initialization
export MOODLE_SMTP_PASSWORD="${MOODLE_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export MOODLE_SMTP_PASSWORD="${MOODLE_SMTP_PASSWORD:-}"
 # only used during the first initialization
export MOODLE_SMTP_PROTOCOL="${MOODLE_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
export MOODLE_SMTP_PROTOCOL="${MOODLE_SMTP_PROTOCOL:-}"

# Database configuration
export MOODLE_DATABASE_TYPE="${MOODLE_DATABASE_TYPE:-mariadb}" # only used during the first initialization
 # only used during the first initialization
export MOODLE_DATABASE_HOST="${MOODLE_DATABASE_HOST:-"${MARIADB_HOST:-}"}"
export MOODLE_DATABASE_HOST="${MOODLE_DATABASE_HOST:-mariadb}"
 # only used during the first initialization
export MOODLE_DATABASE_PORT_NUMBER="${MOODLE_DATABASE_PORT_NUMBER:-"${MARIADB_PORT_NUMBER:-}"}"
export MOODLE_DATABASE_PORT_NUMBER="${MOODLE_DATABASE_PORT_NUMBER:-3306}"
export MOODLE_DATABASE_NAME="${MOODLE_DATABASE_NAME:-bitnami_moodle}" # only used during the first initialization
export MOODLE_DATABASE_USER="${MOODLE_DATABASE_USER:-bn_moodle}" # only used during the first initialization
export MOODLE_DATABASE_PASSWORD="${MOODLE_DATABASE_PASSWORD:-}" # only used during the first initialization

# PHP configuration
export PHP_DEFAULT_MEMORY_LIMIT="256M" # only used at build time

# Custom environment variables may be defined below
