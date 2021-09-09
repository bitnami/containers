#!/bin/bash
#
# Environment configuration for php

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
export MODULE="${MODULE:-php}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
php_env_vars=(
    PHP_FPM_LISTEN_ADDRESS
    PHP_ENABLE_OPCACHE
    PHP_EXPOSE_PHP
    PHP_MAX_EXECUTION_TIME
    PHP_MAX_INPUT_TIME
    PHP_MAX_INPUT_VARS
    PHP_MEMORY_LIMIT
    PHP_POST_MAX_SIZE
    PHP_UPLOAD_MAX_FILESIZE
    PHP_OPCACHE_ENABLED
)
for env_var in "${php_env_vars[@]}"; do
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
unset php_env_vars

# Paths
export PHP_BASE_DIR="${BITNAMI_ROOT_DIR}/php"
export PHP_BIN_DIR="${PHP_BASE_DIR}/bin"
export PHP_CONF_DIR="${PHP_BASE_DIR}/etc"
export PHP_TMP_DIR="${PHP_BASE_DIR}/var/run"
export PHP_CONF_FILE="${PHP_CONF_DIR}/php.ini"

# PHP default build-time configuration
export PHP_DEFAULT_OPCACHE_INTERNED_STRINGS_BUFFER="16" # only used at build time
export PHP_DEFAULT_OPCACHE_MEMORY_CONSUMPTION="192" # only used at build time
export PHP_DEFAULT_OPCACHE_FILE_CACHE="${PHP_TMP_DIR}/opcache_file" # only used at build time

# PHP-FPM configuration
export PHP_FPM_SBIN_DIR="${PHP_BASE_DIR}/sbin"
export PHP_FPM_LOGS_DIR="${PHP_BASE_DIR}/logs"
export PHP_FPM_LOG_FILE="${PHP_FPM_LOGS_DIR}/php-fpm.log"
export PHP_FPM_CONF_FILE="${PHP_CONF_DIR}/php-fpm.conf"
export PHP_FPM_PID_FILE="${PHP_TMP_DIR}/php-fpm.pid"
export PHP_FPM_DEFAULT_LISTEN_ADDRESS="${PHP_TMP_DIR}/www.sock" # only used at build time
export PHP_FPM_LISTEN_ADDRESS="${PHP_FPM_LISTEN_ADDRESS:-}"
export PATH="${PHP_FPM_SBIN_DIR}:${PHP_BIN_DIR}:${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# System users (when running with a privileged user)
export PHP_FPM_DAEMON_USER="daemon"
export PHP_FPM_DAEMON_GROUP="daemon"

# PHP configuration
PHP_ENABLE_OPCACHE="${PHP_ENABLE_OPCACHE:-"${PHP_OPCACHE_ENABLED:-}"}"
export PHP_ENABLE_OPCACHE="${PHP_ENABLE_OPCACHE:-}"
export PHP_EXPOSE_PHP="${PHP_EXPOSE_PHP:-}"
export PHP_MAX_EXECUTION_TIME="${PHP_MAX_EXECUTION_TIME:-}"
export PHP_MAX_INPUT_TIME="${PHP_MAX_INPUT_TIME:-}"
export PHP_MAX_INPUT_VARS="${PHP_MAX_INPUT_VARS:-}"
export PHP_MEMORY_LIMIT="${PHP_MEMORY_LIMIT:-}"
export PHP_POST_MAX_SIZE="${PHP_POST_MAX_SIZE:-}"
export PHP_UPLOAD_MAX_FILESIZE="${PHP_UPLOAD_MAX_FILESIZE:-}"

# Custom environment variables may be defined below
