#!/bin/bash
#
# Environment configuration for spark

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
export MODULE="${MODULE:-spark}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
spark_env_vars=(
    SPARK_MODE
    SPARK_MASTER_URL
    SPARK_NO_DAEMONIZE
    SPARK_RPC_AUTHENTICATION_ENABLED
    SPARK_RPC_AUTHENTICATION_SECRET
    SPARK_RPC_ENCRYPTION_ENABLED
    SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED
    SPARK_SSL_ENABLED
    SPARK_SSL_KEY_PASSWORD
    SPARK_SSL_KEYSTORE_PASSWORD
    SPARK_SSL_KEYSTORE_FILE
    SPARK_SSL_TRUSTSTORE_PASSWORD
    SPARK_SSL_TRUSTSTORE_FILE
    SPARK_SSL_NEED_CLIENT_AUTH
    SPARK_SSL_PROTOCOL
    SPARK_WEBUI_SSL_PORT
    SPARK_METRICS_ENABLED
)
for env_var in "${spark_env_vars[@]}"; do
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
unset spark_env_vars

# Paths
export SPARK_BASE_DIR="${BITNAMI_ROOT_DIR}/spark"
export SPARK_CONF_DIR="${SPARK_BASE_DIR}/conf"
export SPARK_WORK_DIR="${SPARK_BASE_DIR}/work"
export SPARK_CONF_FILE="${SPARK_CONF_DIR}/spark-defaults.conf"
export SPARK_LOG_DIR="${SPARK_BASE_DIR}/logs"
export SPARK_TMP_DIR="${SPARK_BASE_DIR}/tmp"
export SPARK_JARS_DIR="${SPARK_BASE_DIR}/jars"
export SPARK_INITSCRIPTS_DIR="/docker-entrypoint-initdb.d"
export SPARK_USER="spark"

# Spark configuration
export SPARK_MODE="${SPARK_MODE:-master}"
export SPARK_MASTER_URL="${SPARK_MASTER_URL:-spark://spark-master:7077}"
export SPARK_NO_DAEMONIZE="${SPARK_NO_DAEMONIZE:-true}"

# RPC Authentication and Encryption
export SPARK_RPC_AUTHENTICATION_ENABLED="${SPARK_RPC_AUTHENTICATION_ENABLED:-no}"
export SPARK_RPC_AUTHENTICATION_SECRET="${SPARK_RPC_AUTHENTICATION_SECRET:-}"
export SPARK_RPC_ENCRYPTION_ENABLED="${SPARK_RPC_ENCRYPTION_ENABLED:-no}"

# Local Storage Encryption
export SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED="${SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED:-no}"

# SSL/TLS configuration
export SPARK_SSL_ENABLED="${SPARK_SSL_ENABLED:-no}"
export SPARK_SSL_KEY_PASSWORD="${SPARK_SSL_KEY_PASSWORD:-}"
export SPARK_SSL_KEYSTORE_PASSWORD="${SPARK_SSL_KEYSTORE_PASSWORD:-}"
export SPARK_SSL_KEYSTORE_FILE="${SPARK_SSL_KEYSTORE_FILE:-${SPARK_CONF_DIR}/certs/spark-keystore.jks}"
export SPARK_SSL_TRUSTSTORE_PASSWORD="${SPARK_SSL_TRUSTSTORE_PASSWORD:-}"
export SPARK_SSL_TRUSTSTORE_FILE="${SPARK_SSL_TRUSTSTORE_FILE:-${SPARK_CONF_DIR}/certs/spark-truststore.jks}"
export SPARK_SSL_NEED_CLIENT_AUTH="${SPARK_SSL_NEED_CLIENT_AUTH:-yes}"
export SPARK_SSL_PROTOCOL="${SPARK_SSL_PROTOCOL:-TLSv1.2}"
export SPARK_WEBUI_SSL_PORT="${SPARK_WEBUI_SSL_PORT:-}"
export SPARK_METRICS_ENABLED="${SPARK_METRICS_ENABLED:-false}"

# Spark system parameters
export SPARK_DAEMON_USER="spark"
export SPARK_DAEMON_GROUP="spark"

# Custom environment variables may be defined below
