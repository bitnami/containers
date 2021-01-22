#!/bin/bash
#
# Environment configuration for phpmyadmin

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-phpmyadmin}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
phpmyadmin_env_vars=(
    PHPMYADMIN_ALLOW_ARBITRARY_SERVER
    PHPMYADMIN_ALLOW_REMOTE_CONNECTIONS
    PHPMYADMIN_ABSOLUTE_URI
    DATABASE_HOST
    DATABASE_PORT_NUMBER
    DATABASE_ALLOW_NO_PASSWORD
    DATABASE_ENABLE_SSL
    DATABASE_SSL_KEY
    DATABASE_SSL_CERT
    DATABASE_SSL_CA
    DATABASE_SSL_CA_PATH
    DATABASE_SSL_CIPHERS
    DATABASE_SSL_VERIFY
    PMA_ABSOLUTE_URI
)
for env_var in "${phpmyadmin_env_vars[@]}"; do
    file_env_var="${env_var}_FILE"
    if [[ -n "${!file_env_var:-}" ]]; then
        export "${env_var}=$(< "${!file_env_var}")"
        unset "${file_env_var}"
    fi
done
unset phpmyadmin_env_vars

# Paths
export PHPMYADMIN_BASE_DIR="${BITNAMI_ROOT_DIR}/phpmyadmin"
export PHPMYADMIN_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/phpmyadmin"
export PHPMYADMIN_TMP_DIR="${PHPMYADMIN_BASE_DIR}/tmp"
export PHPMYADMIN_CONF_FILE="${PHPMYADMIN_BASE_DIR}/config.inc.php"
export PHPMYADMIN_MOUNTED_CONF_FILE="${PHPMYADMIN_VOLUME_DIR}/config.inc.php"

# phpMyAdmin configuration
export PHPMYADMIN_DEFAULT_ALLOW_ARBITRARY_SERVER="no" # only used at build time
export PHPMYADMIN_ALLOW_ARBITRARY_SERVER="${PHPMYADMIN_ALLOW_ARBITRARY_SERVER:-}"
export PHPMYADMIN_DEFAULT_ALLOW_REMOTE_CONNECTIONS="yes" # only used at build time
export PHPMYADMIN_ALLOW_REMOTE_CONNECTIONS="${PHPMYADMIN_ALLOW_REMOTE_CONNECTIONS:-$PHPMYADMIN_DEFAULT_ALLOW_REMOTE_CONNECTIONS}"
PHPMYADMIN_ABSOLUTE_URI="${PHPMYADMIN_ABSOLUTE_URI:-"${PMA_ABSOLUTE_URI:-}"}"
export PHPMYADMIN_ABSOLUTE_URI="${PHPMYADMIN_ABSOLUTE_URI:-}"

# Database configuration
export DATABASE_DEFAULT_HOST="mariadb" # only used at build time
export DATABASE_HOST="${DATABASE_HOST:-}"
export DATABASE_DEFAULT_PORT_NUMBER="3306" # only used at build time
export DATABASE_PORT_NUMBER="${DATABASE_PORT_NUMBER:-}"
export DATABASE_DEFAULT_ALLOW_NO_PASSWORD="yes" # only used at build time
# PHPMYADMIN_ALLOW_NO_PASSWORD is deprecated in favor of DATABASE_ALLOW_NO_PASSWORD
DATABASE_ALLOW_NO_PASSWORD="${DATABASE_ALLOW_NO_PASSWORD:-"${PHPMYADMIN_ALLOW_NO_PASSWORD:-}"}"
export DATABASE_ALLOW_NO_PASSWORD="${DATABASE_ALLOW_NO_PASSWORD:-}"
export DATABASE_ENABLE_SSL="${DATABASE_ENABLE_SSL:-}"
export DATABASE_SSL_KEY="${DATABASE_SSL_KEY:-}"
export DATABASE_SSL_CERT="${DATABASE_SSL_CERT:-}"
export DATABASE_SSL_CA="${DATABASE_SSL_CA:-}"
export DATABASE_SSL_CA_PATH="${DATABASE_SSL_CA_PATH:-}"
export DATABASE_SSL_CIPHERS="${DATABASE_SSL_CIPHERS:-}"
export DATABASE_SSL_VERIFY="${DATABASE_SSL_VERIFY:-yes}"

# PHP configuration defaults
export PHP_DEFAULT_UPLOAD_MAX_FILESIZE="80M" # only used at build time
export PHP_DEFAULT_POST_MAX_SIZE="80M" # only used at build time
export PHP_DEFAULT_MEMORY_LIMIT="256M" # only used at build time

# Custom environment variables may be defined below
