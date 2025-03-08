#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for solr

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
export MODULE="${MODULE:-solr}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
solr_env_vars=(
    SOLR_ENABLE_CLOUD_MODE
    SOLR_NUMBER_OF_NODES
    SOLR_HOST
    SOLR_JETTY_HOST
    SOLR_HEAP
    SOLR_SECURITY_MANAGER_ENABLED
    SOLR_JAVA_MEM
    SOLR_PORT_NUMBER
    SOLR_CORES
    SOLR_COLLECTION
    SOLR_COLLECTION_REPLICAS
    SOLR_COLLECTION_SHARDS
    SOLR_ENABLE_AUTHENTICATION
    SOLR_ADMIN_USERNAME
    SOLR_ADMIN_PASSWORD
    SOLR_CLOUD_BOOTSTRAP
    SOLR_CORE_CONF_DIR
    SOLR_SSL_ENABLED
    SOLR_SSL_CHECK_PEER_NAME
    SOLR_ZK_MAX_RETRIES
    SOLR_ZK_SLEEP_TIME
    SOLR_ZK_CHROOT
    SOLR_ZK_HOSTS
    SOLR_COLLECTION
    SOLR_ZK_CONNECTION_ATTEMPT_TIMEOUT
)
for env_var in "${solr_env_vars[@]}"; do
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
unset solr_env_vars

# Paths
export PATH="$BITNAMI_ROOT_DIR/solr/bin:$BITNAMI_ROOT_DIR/java/bin:$BITNAMI_ROOT_DIR/common/bin:$PATH"
export BITNAMI_VOLUME_DIR="/bitnami"
export SOLR_BASE_DIR="${BITNAMI_ROOT_DIR}/solr"
export SOLR_JAVA_HOME="${BITNAMI_ROOT_DIR}/java"
export SOLR_BIN_DIR="${SOLR_BASE_DIR}/bin"
export SOLR_TMP_DIR="${SOLR_BASE_DIR}/tmp"
export SOLR_PID_DIR="${SOLR_BASE_DIR}/tmp"
export SOLR_LOGS_DIR="${SOLR_BASE_DIR}/logs"
export SOLR_SERVER_DIR="${SOLR_BASE_DIR}/server"

# Persistence
export SOLR_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/solr"
export SOLR_DATA_TO_PERSIST="server/solr"

# Solr parameters
export SOLR_ENABLE_CLOUD_MODE="${SOLR_ENABLE_CLOUD_MODE:-no}"
export SOLR_NUMBER_OF_NODES="${SOLR_NUMBER_OF_NODES:-1}"
export SOLR_HOST="${SOLR_HOST:-}"
export SOLR_JETTY_HOST="${SOLR_JETTY_HOST:-0.0.0.0}"
export SOLR_HEAP="${SOLR_HEAP:-}"
export SOLR_SECURITY_MANAGER_ENABLED="${SOLR_SECURITY_MANAGER_ENABLED:-false}"
export SOLR_JAVA_MEM="${SOLR_JAVA_MEM:--Xms512m -Xmx512m}"
export SOLR_PORT_NUMBER="${SOLR_PORT_NUMBER:-8983}"
export SOLR_PID_FILE="${SOLR_PID_DIR}/solr-${SOLR_PORT_NUMBER}.pid"
export SOLR_CORES="${SOLR_CORES:-}"
SOLR_COLLECTION="${SOLR_COLLECTION:-"${SOLR_COLLECTION:-}"}"
export SOLR_COLLECTION="${SOLR_COLLECTION:-}"
export SOLR_COLLECTION_REPLICAS="${SOLR_COLLECTION_REPLICAS:-1}"
export SOLR_COLLECTION_SHARDS="${SOLR_COLLECTION_SHARDS:-1}"
export SOLR_ENABLE_AUTHENTICATION="${SOLR_ENABLE_AUTHENTICATION:-no}"
export SOLR_ADMIN_USERNAME="${SOLR_ADMIN_USERNAME:-admin}"
export SOLR_ADMIN_PASSWORD="${SOLR_ADMIN_PASSWORD:-bitnami}"
export SOLR_CLOUD_BOOTSTRAP="${SOLR_CLOUD_BOOTSTRAP:-no}"
export SOLR_CORE_CONF_DIR="${SOLR_CORE_CONF_DIR:-${SOLR_SERVER_DIR}/solr/configsets/_default/conf}"
export SOLR_SSL_ENABLED="${SOLR_SSL_ENABLED:-no}"
export SOLR_SSL_CHECK_PEER_NAME="${SOLR_SSL_CHECK_PEER_NAME:-false}"

# System users (when running with a privileged user)
export SOLR_DAEMON_USER="solr"
export SOLR_DAEMON_GROUP="solr"

# Solr retries configuration
export SOLR_ZK_MAX_RETRIES="${SOLR_ZK_MAX_RETRIES:-5}"
export SOLR_ZK_SLEEP_TIME="${SOLR_ZK_SLEEP_TIME:-5}"
export SOLR_ZK_CHROOT="${SOLR_ZK_CHROOT:-/solr}"
export SOLR_ZK_HOSTS="${SOLR_ZK_HOSTS:-}"
export SOLR_ZK_CONNECTION_ATTEMPT_TIMEOUT="${SOLR_ZK_CONNECTION_ATTEMPT_TIMEOUT:-10}"

# Custom environment variables may be defined below
