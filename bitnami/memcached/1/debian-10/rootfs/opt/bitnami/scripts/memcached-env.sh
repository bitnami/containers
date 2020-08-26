#!/bin/bash
#
# Environment configuration for memcached

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-memcached}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
memcached_env_vars=(
    MEMCACHED_LISTEN_ADDRESS
    MEMCACHED_PORT_NUMBER
    MEMCACHED_USERNAME
    MEMCACHED_PASSWORD
    MEMCACHED_EXTRA_FLAGS
    MEMCACHED_MAX_TIMEOUT
    MEMCACHED_CACHE_SIZE
    MEMCACHED_MAX_CONNECTIONS
    MEMCACHED_THREADS
)
for env_var in "${memcached_env_vars[@]}"; do
    file_env_var="${env_var}_FILE"
    if [[ -n "${!file_env_var:-}" ]]; then
        export "${env_var}=$(< "${!file_env_var}")"
        unset "${file_env_var}"
    fi
done
unset memcached_env_vars

# Paths
export MEMCACHED_BASE_DIR="${BITNAMI_ROOT_DIR}/memcached"
export MEMCACHED_CONF_DIR="${MEMCACHED_BASE_DIR}/conf"
export MEMCACHED_BIN_DIR="${MEMCACHED_BASE_DIR}/bin"
export PATH="${MEMCACHED_BIN_DIR}:${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# SASL
export SASL_CONF_PATH="${MEMCACHED_CONF_DIR}/sasl2"
export SASL_CONF_FILE="${SASL_CONF_PATH}/memcached.conf"
export SASL_DB_FILE="${SASL_CONF_PATH}/memcachedsasldb"

# System users (when running with a privileged user)
export MEMCACHED_DAEMON_USER="memcached"
export MEMCACHED_DAEMON_GROUP="memcached"

# Memcached configuration
export MEMCACHED_LISTEN_ADDRESS="${MEMCACHED_LISTEN_ADDRESS:-}"
export MEMCACHED_PORT_NUMBER="${MEMCACHED_PORT_NUMBER:-11211}"
export MEMCACHED_USERNAME="${MEMCACHED_USERNAME:-root}"
export MEMCACHED_PASSWORD="${MEMCACHED_PASSWORD:-}"
export MEMCACHED_EXTRA_FLAGS="${MEMCACHED_EXTRA_FLAGS:-}"

# Memcached optimizations
export MEMCACHED_MAX_TIMEOUT="${MEMCACHED_MAX_TIMEOUT:-5}"
export MEMCACHED_CACHE_SIZE="${MEMCACHED_CACHE_SIZE:-}"
export MEMCACHED_MAX_CONNECTIONS="${MEMCACHED_MAX_CONNECTIONS:-}"
export MEMCACHED_THREADS="${MEMCACHED_THREADS:-}"

# Custom environment variables may be defined below
