#!/bin/bash
#
# Environment configuration for pgbouncer

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
export MODULE="${MODULE:-pgbouncer}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
pgbouncer_env_vars=(
    PGBOUNCER_DATABASE
    PGBOUNCER_PORT
    PGBOUNCER_LISTEN_ADDRESS
    PGBOUNCER_AUTH_TYPE
    PGBOUNCER_INIT_SLEEP_TIME
    PGBOUNCER_INIT_MAX_RETRIES
    PGBOUNCER_EXTRA_FLAGS
    PGBOUNCER_CLIENT_TLS_SSLMODE
    PGBOUNCER_CLIENT_TLS_CA_FILE
    PGBOUNCER_CLIENT_TLS_CERT_FILE
    PGBOUNCER_CLIENT_TLS_KEY_FILE
    PGBOUNCER_CLIENT_TLS_CIPHERS
    POSTGRESQL_USERNAME
    POSTGRESQL_PASSWORD
    POSTGRESQL_DATABASE
    POSTGRESQL_HOST
    POSTGRESQL_PORT
    PGBOUNCER_DAEMON_USER
    PGBOUNCER_DAEMON_GROUP
)
for env_var in "${pgbouncer_env_vars[@]}"; do
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
unset pgbouncer_env_vars

# Paths
export PGBOUNCER_BASE_DIR="${BITNAMI_ROOT_DIR}/pgbouncer"
export PGBOUNCER_CONF_DIR="${PGBOUNCER_BASE_DIR}/conf"
export PGBOUNCER_LOG_DIR="${PGBOUNCER_BASE_DIR}/logs"
export PGBOUNCER_TMP_DIR="${PGBOUNCER_BASE_DIR}/tmp"
export PGBOUNCER_LOG_FILE="${PGBOUNCER_LOG_DIR}/pgbouncer.log"
export PGBOUNCER_PID_FILE="${PGBOUNCER_TMP_DIR}/pgbouncer.pid"
export PGBOUNCER_CONF_FILE="${PGBOUNCER_CONF_DIR}/pgbouncer.ini"
export PGBOUNCER_AUTH_FILE="${PGBOUNCER_CONF_DIR}/userlist.txt"
export PGBOUNCER_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/pgbouncer"
export PGBOUNCER_MOUNTED_CONF_DIR="${PGBOUNCER_VOLUME_DIR}/conf"
export PGBOUNCER_INITSCRIPTS_DIR="/docker-entrypoint-initdb.d"

# General PgBouncer settings
export PGBOUNCER_DATABASE="${PGBOUNCER_DATABASE:-postgres}"
export PGBOUNCER_PORT="${PGBOUNCER_PORT:-6432}"
export PGBOUNCER_LISTEN_ADDRESS="${PGBOUNCER_LISTEN_ADDRESS:-0.0.0.0}"
export PGBOUNCER_AUTH_TYPE="${PGBOUNCER_AUTH_TYPE:-md5}"
export PGBOUNCER_INIT_SLEEP_TIME="${PGBOUNCER_INIT_SLEEP_TIME:-10}"
export PGBOUNCER_INIT_MAX_RETRIES="${PGBOUNCER_INIT_MAX_RETRIES:-10}"
export PGBOUNCER_EXTRA_FLAGS="${PGBOUNCER_EXTRA_FLAGS:-}"

# TLS settings
export PGBOUNCER_CLIENT_TLS_SSLMODE="${PGBOUNCER_CLIENT_TLS_SSLMODE:-disable}"
export PGBOUNCER_CLIENT_TLS_CA_FILE="${PGBOUNCER_CLIENT_TLS_CA_FILE:-}"
export PGBOUNCER_CLIENT_TLS_CERT_FILE="${PGBOUNCER_CLIENT_TLS_CERT_FILE:-}"
export PGBOUNCER_CLIENT_TLS_KEY_FILE="${PGBOUNCER_CLIENT_TLS_KEY_FILE:-}"
export PGBOUNCER_CLIENT_TLS_CIPHERS="${PGBOUNCER_CLIENT_TLS_CIPHERS:-fast}"

# PostgreSQL backend settings
export POSTGRESQL_USERNAME="${POSTGRESQL_USERNAME:-postgres}"
export POSTGRESQL_PASSWORD="${POSTGRESQL_PASSWORD:-}"
export POSTGRESQL_DATABASE="${POSTGRESQL_DATABASE:-postgres}"
export POSTGRESQL_HOST="${POSTGRESQL_HOST:-postgresql}"
export POSTGRESQL_PORT="${POSTGRESQL_PORT:-5432}"

# System settings
export PGBOUNCER_DAEMON_USER="${PGBOUNCER_DAEMON_USER:-pgbouncer}"
export PGBOUNCER_DAEMON_GROUP="${PGBOUNCER_DAEMON_GROUP:-pgbouncer}"
export NSS_WRAPPER_LIB="/opt/bitnami/common/lib/libnss_wrapper.so"

# Custom environment variables may be defined below
