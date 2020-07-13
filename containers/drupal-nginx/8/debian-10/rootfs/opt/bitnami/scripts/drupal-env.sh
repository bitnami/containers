#!/bin/bash
#
# Environment configuration for drupal

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-drupal}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
drupal_env_vars=(
    DRUPAL_DATA_TO_PERSIST
    DRUPAL_PROFILE
    DRUPAL_SITE_NAME
    DRUPAL_SKIP_BOOTSTRAP
    DRUPAL_ENABLE_MODULES
    DRUPAL_USERNAME
    DRUPAL_PASSWORD
    DRUPAL_EMAIL
    DRUPAL_DATABASE_HOST
    DRUPAL_DATABASE_PORT_NUMBER
    DRUPAL_DATABASE_NAME
    DRUPAL_DATABASE_USER
    DRUPAL_DATABASE_PASSWORD
    DRUPAL_DATABASE_TLS_CA_FILE
    DRUPAL_DATABASE_MIN_VERSION

)
for env_var in "${drupal_env_vars[@]}"; do
    file_env_var="${env_var}_FILE"
    if [[ -n "${!file_env_var:-}" ]]; then
        export "${env_var}=$(< "${!file_env_var}")"
        unset "${file_env_var}"
    fi
done
unset drupal_env_vars

# Paths
export DRUPAL_BASE_DIR="${BITNAMI_ROOT_DIR}/drupal"
export DRUPAL_CONF_FILE="${DRUPAL_BASE_DIR}/sites/default/settings.php"
export DRUPAL_MODULES_DIR="${DRUPAL_BASE_DIR}/modules"

# Drupal persistence configuration
export DRUPAL_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/drupal"
export DRUPAL_MOUNTED_CONF_FILE="${DRUPAL_VOLUME_DIR}/settings.php"
export DRUPAL_DATA_TO_PERSIST="${DRUPAL_DATA_TO_PERSIST:-sites/ themes/ modules/ profiles/}"

# Drupal configuration
export DRUPAL_PROFILE="${DRUPAL_PROFILE:-standard}"
export DRUPAL_SITE_NAME="${DRUPAL_SITE_NAME:-My blog}"
export DRUPAL_SKIP_BOOTSTRAP="${DRUPAL_SKIP_BOOTSTRAP:-}"
export DRUPAL_ENABLE_MODULES="${DRUPAL_ENABLE_MODULES:-}"

# Drupal credentials
export DRUPAL_USERNAME="${DRUPAL_USERNAME:-user}"
export DRUPAL_PASSWORD="${DRUPAL_PASSWORD:-bitnami}"
export DRUPAL_EMAIL="${DRUPAL_EMAIL:-user@example.com}"

# Database configuration
export DRUPAL_DEFAULT_DATABASE_HOST="mariadb" # only used at build time

export DRUPAL_DATABASE_HOST="${DRUPAL_DATABASE_HOST:-"${MARIADB_HOST:-}"}"
export DRUPAL_DATABASE_HOST="${DRUPAL_DATABASE_HOST:-$DRUPAL_DEFAULT_DATABASE_HOST}"

export DRUPAL_DATABASE_PORT_NUMBER="${DRUPAL_DATABASE_PORT_NUMBER:-"${MARIADB_PORT_NUMBER:-}"}"
export DRUPAL_DATABASE_PORT_NUMBER="${DRUPAL_DATABASE_PORT_NUMBER:-3306}"
export DRUPAL_DATABASE_NAME="${DRUPAL_DATABASE_NAME:-bitnami_drupal}"
export DRUPAL_DATABASE_USER="${DRUPAL_DATABASE_USER:-bn_drupal}"
export DRUPAL_DATABASE_PASSWORD="${DRUPAL_DATABASE_PASSWORD:-}"
export DRUPAL_DATABASE_TLS_CA_FILE="${DRUPAL_DATABASE_TLS_CA_FILE:-}"
export DRUPAL_DATABASE_MIN_VERSION="${DRUPAL_DATABASE_MIN_VERSION:-}"

# PHP configuration
export PHP_DEFAULT_MEMORY_LIMIT="256M" # only used at build time

# Custom environment variables may be defined below
