#!/bin/bash
#
# Environment configuration for kibana

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
export MODULE="${MODULE:-kibana}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
kibana_env_vars=(
    KIBANA_ELASTICSEARCH_URL
    KIBANA_ELASTICSEARCH_PORT_NUMBER
    KIBANA_HOST
    KIBANA_PORT_NUMBER
    KIBANA_WAIT_READY_MAX_RETRIES
    KIBANA_INITSCRIPTS_START_SERVER
    KIBANA_FORCE_INITSCRIPTS
    ELASTICSEARCH_URL
    KIBANA_ELASTICSEARCH_PORT
    ELASTICSEARCH_PORT_NUMBER
    KIBANA_INITSCRIPTS_MAX_RETRIES
)
for env_var in "${kibana_env_vars[@]}"; do
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
unset kibana_env_vars

# Paths
export BITNAMI_VOLUME_DIR="/bitnami"
export KIBANA_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/kibana"
export KIBANA_BASE_DIR="${BITNAMI_ROOT_DIR}/kibana"
export KIBANA_CONF_DIR="${KIBANA_BASE_DIR}/config"
export KIBANA_LOGS_DIR="${KIBANA_BASE_DIR}/logs"
export KIBANA_TMP_DIR="${KIBANA_BASE_DIR}/tmp"
export KIBANA_BIN_DIR="${KIBANA_BASE_DIR}/bin"
export KIBANA_PLUGINS_DIR="${KIBANA_BASE_DIR}/plugins"
export KIBANA_OPTIMIZE_DIR="${KIBANA_BASE_DIR}/optimize"
export KIBANA_DATA_DIR="${KIBANA_VOLUME_DIR}/data"
export KIBANA_MOUNTED_CONF_DIR="${KIBANA_VOLUME_DIR}/conf"
export KIBANA_CONF_FILE="${KIBANA_CONF_DIR}/kibana.yml"
export KIBANA_LOG_FILE="${KIBANA_LOGS_DIR}/kibana.log"
export KIBANA_PID_FILE="${KIBANA_TMP_DIR}/kibana.pid"
export KIBANA_INITSCRIPTS_DIR="/docker-entrypoint-initdb.d"

# System users (when running with a privileged user)
export KIBANA_DAEMON_USER="kibana"
export KIBANA_DAEMON_GROUP="kibana"

# Kibana configuration
KIBANA_ELASTICSEARCH_URL="${KIBANA_ELASTICSEARCH_URL:-"${ELASTICSEARCH_URL:-}"}"
export KIBANA_ELASTICSEARCH_URL="${KIBANA_ELASTICSEARCH_URL:-elasticsearch}"
KIBANA_ELASTICSEARCH_PORT_NUMBER="${KIBANA_ELASTICSEARCH_PORT_NUMBER:-"${KIBANA_ELASTICSEARCH_PORT:-}"}"
KIBANA_ELASTICSEARCH_PORT_NUMBER="${KIBANA_ELASTICSEARCH_PORT_NUMBER:-"${ELASTICSEARCH_PORT_NUMBER:-}"}"
export KIBANA_ELASTICSEARCH_PORT_NUMBER="${KIBANA_ELASTICSEARCH_PORT_NUMBER:-9200}"
export KIBANA_HOST="${KIBANA_HOST:-0.0.0.0}"
export KIBANA_PORT_NUMBER="${KIBANA_PORT_NUMBER:-5601}"
KIBANA_WAIT_READY_MAX_RETRIES="${KIBANA_WAIT_READY_MAX_RETRIES:-"${KIBANA_INITSCRIPTS_MAX_RETRIES:-}"}"
export KIBANA_WAIT_READY_MAX_RETRIES="${KIBANA_WAIT_READY_MAX_RETRIES:-30}"
export KIBANA_INITSCRIPTS_START_SERVER="${KIBANA_INITSCRIPTS_START_SERVER:-yes}"
export KIBANA_FORCE_INITSCRIPTS="${KIBANA_FORCE_INITSCRIPTS:-no}"

# Custom environment variables may be defined below
