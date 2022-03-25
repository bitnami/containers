#!/bin/bash
#
# Environment configuration for magento

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
export MODULE="${MODULE:-magento}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
magento_env_vars=(
    MAGENTO_DATA_TO_PERSIST
    MAGENTO_HOST
    MAGENTO_ENABLE_HTTPS
    MAGENTO_ENABLE_ADMIN_HTTPS
    MAGENTO_EXTERNAL_HTTP_PORT_NUMBER
    MAGENTO_EXTERNAL_HTTPS_PORT_NUMBER
    MAGENTO_FIRST_NAME
    MAGENTO_LAST_NAME
    MAGENTO_MODE
    MAGENTO_EXTRA_INSTALL_ARGS
    MAGENTO_ADMIN_URL_PREFIX
    MAGENTO_DEPLOY_STATIC_CONTENT
    MAGENTO_SKIP_REINDEX
    MAGENTO_SKIP_BOOTSTRAP
    MAGENTO_USERNAME
    MAGENTO_PASSWORD
    MAGENTO_EMAIL
    MAGENTO_ENABLE_HTTP_CACHE
    MAGENTO_HTTP_CACHE_BACKEND_HOST
    MAGENTO_HTTP_CACHE_BACKEND_PORT_NUMBER
    MAGENTO_HTTP_CACHE_SERVER_HOST
    MAGENTO_HTTP_CACHE_SERVER_PORT_NUMBER
    MAGENTO_DATABASE_HOST
    MAGENTO_DATABASE_PORT_NUMBER
    MAGENTO_DATABASE_NAME
    MAGENTO_DATABASE_USER
    MAGENTO_DATABASE_PASSWORD
    MAGENTO_ENABLE_DATABASE_SSL
    MAGENTO_VERIFY_DATABASE_SSL
    MAGENTO_DATABASE_SSL_CERT_FILE
    MAGENTO_DATABASE_SSL_KEY_FILE
    MAGENTO_DATABASE_SSL_CA_FILE
    MAGENTO_SEARCH_ENGINE
    MAGENTO_ELASTICSEARCH_HOST
    MAGENTO_ELASTICSEARCH_PORT_NUMBER
    MAGENTO_ELASTICSEARCH_USE_HTTPS
    MAGENTO_ELASTICSEARCH_ENABLE_AUTH
    MAGENTO_ELASTICSEARCH_USER
    MAGENTO_ELASTICSEARCH_PASSWORD
    MAGENTO_USE_SECURE_ADMIN
    MAGENTO_FIRSTNAME
    MAGENTO_LASTNAME
    MAGENTO_ADMINURI
    VARNISH_BACKEND_ADDRESS
    VARNISH_BACKEND_PORT_NUMBER
    VARNISH_HOST
    VARNISH_PORT_NUMBER
    MARIADB_HOST
    MARIADB_PORT_NUMBER
    ELASTICSEARCH_HOST
    ELASTICSEARCH_PORT_NUMBER
)
for env_var in "${magento_env_vars[@]}"; do
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
unset magento_env_vars

# Paths
export MAGENTO_BASE_DIR="${BITNAMI_ROOT_DIR}/magento"
export MAGENTO_BIN_DIR="${MAGENTO_BASE_DIR}/bin"
export MAGENTO_CONF_FILE="${MAGENTO_BASE_DIR}/app/etc/env.php"
export PATH="${MAGENTO_BIN_DIR}:${PATH}"

# Magento persistence configuration
export MAGENTO_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/magento"
export MAGENTO_DATA_TO_PERSIST="${MAGENTO_DATA_TO_PERSIST:-$MAGENTO_BASE_DIR}"

# Magento configuration
export MAGENTO_HOST="${MAGENTO_HOST:-localhost}"
export MAGENTO_ENABLE_HTTPS="${MAGENTO_ENABLE_HTTPS:-no}" # only used during the first initialization
MAGENTO_ENABLE_ADMIN_HTTPS="${MAGENTO_ENABLE_ADMIN_HTTPS:-"${MAGENTO_USE_SECURE_ADMIN:-}"}"
export MAGENTO_ENABLE_ADMIN_HTTPS="${MAGENTO_ENABLE_ADMIN_HTTPS:-no}" # only used during the first initialization
export MAGENTO_EXTERNAL_HTTP_PORT_NUMBER="${MAGENTO_EXTERNAL_HTTP_PORT_NUMBER:-80}"
export MAGENTO_EXTERNAL_HTTPS_PORT_NUMBER="${MAGENTO_EXTERNAL_HTTPS_PORT_NUMBER:-443}"
MAGENTO_FIRST_NAME="${MAGENTO_FIRST_NAME:-"${MAGENTO_FIRSTNAME:-}"}"
export MAGENTO_FIRST_NAME="${MAGENTO_FIRST_NAME:-FirstName}" # only used during the first initialization
MAGENTO_LAST_NAME="${MAGENTO_LAST_NAME:-"${MAGENTO_LASTNAME:-}"}"
export MAGENTO_LAST_NAME="${MAGENTO_LAST_NAME:-LastName}" # only used during the first initialization
export MAGENTO_MODE="${MAGENTO_MODE:-default}" # only used during the first initialization
export MAGENTO_EXTRA_INSTALL_ARGS="${MAGENTO_EXTRA_INSTALL_ARGS:-}" # only used during the first initialization
MAGENTO_ADMIN_URL_PREFIX="${MAGENTO_ADMIN_URL_PREFIX:-"${MAGENTO_ADMINURI:-}"}"
export MAGENTO_ADMIN_URL_PREFIX="${MAGENTO_ADMIN_URL_PREFIX:-admin}" # only used during the first initialization
export MAGENTO_DEPLOY_STATIC_CONTENT="${MAGENTO_DEPLOY_STATIC_CONTENT:-no}" # only used during the first initialization
export MAGENTO_SKIP_REINDEX="${MAGENTO_SKIP_REINDEX:-no}" # only used during the first initialization
export MAGENTO_SKIP_BOOTSTRAP="${MAGENTO_SKIP_BOOTSTRAP:-no}" # only used during the first initialization

# Magento credentials
export MAGENTO_USERNAME="${MAGENTO_USERNAME:-user}" # only used during the first initialization
export MAGENTO_PASSWORD="${MAGENTO_PASSWORD:-bitnami1}" # only used during the first initialization
export MAGENTO_EMAIL="${MAGENTO_EMAIL:-user@example.com}" # only used during the first initialization

# Magento HTTP cache server configuration (Varnish)
export MAGENTO_ENABLE_HTTP_CACHE="${MAGENTO_ENABLE_HTTP_CACHE:-no}" # only used during the first initialization
MAGENTO_HTTP_CACHE_BACKEND_HOST="${MAGENTO_HTTP_CACHE_BACKEND_HOST:-"${VARNISH_BACKEND_ADDRESS:-}"}"
export MAGENTO_HTTP_CACHE_BACKEND_HOST="${MAGENTO_HTTP_CACHE_BACKEND_HOST:-}" # only used during the first initialization
MAGENTO_HTTP_CACHE_BACKEND_PORT_NUMBER="${MAGENTO_HTTP_CACHE_BACKEND_PORT_NUMBER:-"${VARNISH_BACKEND_PORT_NUMBER:-}"}"
export MAGENTO_HTTP_CACHE_BACKEND_PORT_NUMBER="${MAGENTO_HTTP_CACHE_BACKEND_PORT_NUMBER:-}" # only used during the first initialization
MAGENTO_HTTP_CACHE_SERVER_HOST="${MAGENTO_HTTP_CACHE_SERVER_HOST:-"${VARNISH_HOST:-}"}"
export MAGENTO_HTTP_CACHE_SERVER_HOST="${MAGENTO_HTTP_CACHE_SERVER_HOST:-}" # only used during the first initialization
MAGENTO_HTTP_CACHE_SERVER_PORT_NUMBER="${MAGENTO_HTTP_CACHE_SERVER_PORT_NUMBER:-"${VARNISH_PORT_NUMBER:-}"}"
export MAGENTO_HTTP_CACHE_SERVER_PORT_NUMBER="${MAGENTO_HTTP_CACHE_SERVER_PORT_NUMBER:-}" # only used during the first initialization

# Database configuration
MAGENTO_DATABASE_HOST="${MAGENTO_DATABASE_HOST:-"${MARIADB_HOST:-}"}"
export MAGENTO_DATABASE_HOST="${MAGENTO_DATABASE_HOST:-mariadb}" # only used during the first initialization
MAGENTO_DATABASE_PORT_NUMBER="${MAGENTO_DATABASE_PORT_NUMBER:-"${MARIADB_PORT_NUMBER:-}"}"
export MAGENTO_DATABASE_PORT_NUMBER="${MAGENTO_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
export MAGENTO_DATABASE_NAME="${MAGENTO_DATABASE_NAME:-bitnami_magento}" # only used during the first initialization
export MAGENTO_DATABASE_USER="${MAGENTO_DATABASE_USER:-bn_magento}" # only used during the first initialization
export MAGENTO_DATABASE_PASSWORD="${MAGENTO_DATABASE_PASSWORD:-}" # only used during the first initialization
export MAGENTO_ENABLE_DATABASE_SSL="${MAGENTO_ENABLE_DATABASE_SSL:-no}" # only used during the first initialization
export MAGENTO_VERIFY_DATABASE_SSL="${MAGENTO_VERIFY_DATABASE_SSL:-yes}" # only used during the first initialization
export MAGENTO_DATABASE_SSL_CERT_FILE="${MAGENTO_DATABASE_SSL_CERT_FILE:-}" # only used during the first initialization
export MAGENTO_DATABASE_SSL_KEY_FILE="${MAGENTO_DATABASE_SSL_KEY_FILE:-}" # only used during the first initialization
export MAGENTO_DATABASE_SSL_CA_FILE="${MAGENTO_DATABASE_SSL_CA_FILE:-}" # only used during the first initialization

# Magento search engine configuration
export MAGENTO_SEARCH_ENGINE="${MAGENTO_SEARCH_ENGINE:-elasticsearch7}" # only used during the first initialization
MAGENTO_ELASTICSEARCH_HOST="${MAGENTO_ELASTICSEARCH_HOST:-"${ELASTICSEARCH_HOST:-}"}"
export MAGENTO_ELASTICSEARCH_HOST="${MAGENTO_ELASTICSEARCH_HOST:-elasticsearch}" # only used during the first initialization
MAGENTO_ELASTICSEARCH_PORT_NUMBER="${MAGENTO_ELASTICSEARCH_PORT_NUMBER:-"${ELASTICSEARCH_PORT_NUMBER:-}"}"
export MAGENTO_ELASTICSEARCH_PORT_NUMBER="${MAGENTO_ELASTICSEARCH_PORT_NUMBER:-9200}" # only used during the first initialization
export MAGENTO_ELASTICSEARCH_USE_HTTPS="${MAGENTO_ELASTICSEARCH_USE_HTTPS:-no}" # only used during the first initialization
export MAGENTO_ELASTICSEARCH_ENABLE_AUTH="${MAGENTO_ELASTICSEARCH_ENABLE_AUTH:-no}" # only used during the first initialization
export MAGENTO_ELASTICSEARCH_USER="${MAGENTO_ELASTICSEARCH_USER:-}" # only used during the first initialization
export MAGENTO_ELASTICSEARCH_PASSWORD="${MAGENTO_ELASTICSEARCH_PASSWORD:-}" # only used during the first initialization

# PHP configuration
export PHP_DEFAULT_MAX_EXECUTION_TIME="18000" # only used at build time
export PHP_DEFAULT_MEMORY_LIMIT="1G" # only used at build time

# Custom environment variables may be defined below
