#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for janusgraph

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
export MODULE="${MODULE:-janusgraph}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
janusgraph_env_vars=(
    JANUSGRAPH_MOUNTED_CONF_DIR
    JANUSGRAPH_GREMLIN_CONF_FILE
    JANUSGRAPH_PROPERTIES
    JANUSGRAPH_HOST
    JANUSGRAPH_PORT_NUMBER
    JANUSGRAPH_STORAGE_PASSWORD
    GREMLIN_REMOTE_HOSTS
    GREMLIN_REMOTE_PORT
    GREMLIN_AUTOCONFIGURE_POOL
    GREMLIN_THREAD_POOL_WORKER
    GREMLIN_POOL
    JANUSGRAPH_JMX_METRICS_ENABLED
    JAVA_OPTIONS
    JANUSGRAPH_YAML
)
for env_var in "${janusgraph_env_vars[@]}"; do
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
unset janusgraph_env_vars

# Paths
export JANUSGRAPH_BASE_DIR="${BITNAMI_ROOT_DIR}/janusgraph"
export JANUSGRAPH_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/janusgraph"
export JANUSGRAPH_DATA_DIR="${JANUSGRAPH_VOLUME_DIR}/data"
export JANUSGRAPH_BIN_DIR="${JANUSGRAPH_BASE_DIR}/bin"
export JANUSGRAPH_CONF_DIR="${JANUSGRAPH_BASE_DIR}/conf"
export JANUSGRAPH_DEFAULT_CONF_DIR="${JANUSGRAPH_BASE_DIR}/conf.default"
export JANUSGRAPH_LOGS_DIR="${JANUSGRAPH_BASE_DIR}/logs"
export JANUSGRAPH_MOUNTED_CONF_DIR="${JANUSGRAPH_MOUNTED_CONF_DIR:-${JANUSGRAPH_VOLUME_DIR}/conf}"
JANUSGRAPH_GREMLIN_CONF_FILE="${JANUSGRAPH_GREMLIN_CONF_FILE:-"${JANUSGRAPH_YAML:-}"}"
export JANUSGRAPH_GREMLIN_CONF_FILE="${JANUSGRAPH_GREMLIN_CONF_FILE:-${JANUSGRAPH_CONF_DIR}/gremlin-server.yaml}"
export JANUSGRAPH_YAML="$JANUSGRAPH_GREMLIN_CONF_FILE"
export JANUSGRAPH_PROPERTIES="${JANUSGRAPH_PROPERTIES:-${JANUSGRAPH_CONF_DIR}/janusgraph.properties}"

# System users (when running with a privileged user)
export JANUSGRAPH_DAEMON_USER="janusgraph"
export JANUSGRAPH_DAEMON_GROUP="janusgraph"

# JANUSGRAPH settings
export JANUSGRAPH_HOST="${JANUSGRAPH_HOST:-0.0.0.0}"
export JANUSGRAPH_PORT_NUMBER="${JANUSGRAPH_PORT_NUMBER:-8182}"
export JANUSGRAPH_STORAGE_PASSWORD="${JANUSGRAPH_STORAGE_PASSWORD:-}"
export GREMLIN_REMOTE_HOSTS="${GREMLIN_REMOTE_HOSTS:-localhost}"
export GREMLIN_REMOTE_PORT="${GREMLIN_REMOTE_PORT:-$JANUSGRAPH_PORT_NUMBER}"
export GREMLIN_AUTOCONFIGURE_POOL="${GREMLIN_AUTOCONFIGURE_POOL:-false}"
export GREMLIN_THREAD_POOL_WORKER="${GREMLIN_THREAD_POOL_WORKER:-1}"
export GREMLIN_POOL="${GREMLIN_POOL:-8}"
export JANUSGRAPH_JMX_METRICS_ENABLED="${JANUSGRAPH_JMX_METRICS_ENABLED:-false}"
export JAVA_OPTIONS="${JAVA_OPTIONS:-${JAVA_OPTIONS:-} -XX:+UseContainerSupport}"

# Custom environment variables may be defined below
