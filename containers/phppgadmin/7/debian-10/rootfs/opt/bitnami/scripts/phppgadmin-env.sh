#!/bin/bash
#
# Environment configuration for phppgadmin

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
export MODULE="${MODULE:-phppgadmin}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
phppgadmin_env_vars=(
    PHPPGADMIN_ENABLE_EXTRA_LOGIN_SECURITY
    PHPPGADMIN_ALLOW_REMOTE_CONNECTIONS
    PHPPGADMIN_URL_PREFIX
    DATABASE_HOST
    DATABASE_PORT_NUMBER
    DATABASE_SSL_MODE
)
for env_var in "${phppgadmin_env_vars[@]}"; do
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
unset phppgadmin_env_vars

# Paths
export PHPPGADMIN_BASE_DIR="${BITNAMI_ROOT_DIR}/phppgadmin"
export PHPPGADMIN_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/phppgadmin"
export PHPPGADMIN_CONF_FILE="${PHPPGADMIN_BASE_DIR}/conf/config.inc.php"
export PHPPGADMIN_MOUNTED_CONF_FILE="${PHPPGADMIN_VOLUME_DIR}/config.inc.php"

# phpPgAdmin configuration
export PHPPGADMIN_DEFAULT_ENABLE_EXTRA_LOGIN_SECURITY="no" # only used at build time
export PHPPGADMIN_ENABLE_EXTRA_LOGIN_SECURITY="${PHPPGADMIN_ENABLE_EXTRA_LOGIN_SECURITY:-}"
export PHPPGADMIN_DEFAULT_ALLOW_REMOTE_CONNECTIONS="yes" # only used at build time
export PHPPGADMIN_ALLOW_REMOTE_CONNECTIONS="${PHPPGADMIN_ALLOW_REMOTE_CONNECTIONS:-$PHPPGADMIN_DEFAULT_ALLOW_REMOTE_CONNECTIONS}"
export PHPPGADMIN_URL_PREFIX="${PHPPGADMIN_URL_PREFIX:-}"

# Database configuration
export DATABASE_DEFAULT_HOST="postgresql" # only used at build time
export DATABASE_HOST="${DATABASE_HOST:-}"
export DATABASE_DEFAULT_PORT_NUMBER="5432" # only used at build time
export DATABASE_PORT_NUMBER="${DATABASE_PORT_NUMBER:-}"
export DATABASE_SSL_MODE="${DATABASE_SSL_MODE:-}"

# PHP configuration
export PHP_DEFAULT_UPLOAD_MAX_FILESIZE="80M" # only used at build time
export PHP_DEFAULT_POST_MAX_SIZE="80M" # only used at build time
export PHP_DEFAULT_MEMORY_LIMIT="256M" # only used at build time

# Custom environment variables may be defined below
