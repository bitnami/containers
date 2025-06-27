#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for zookeeper

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
export MODULE="${MODULE:-zookeeper}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
zookeeper_env_vars=(
    ZOO_DATA_LOG_DIR
    ZOO_PORT_NUMBER
    ZOO_SERVER_ID
    ZOO_SERVERS
    ZOO_ENABLE_ADMIN_SERVER
    ZOO_ADMIN_SERVER_PORT_NUMBER
    ZOO_PEER_TYPE
    ZOO_TICK_TIME
    ZOO_INIT_LIMIT
    ZOO_SYNC_LIMIT
    ZOO_MAX_CNXNS
    ZOO_MAX_CLIENT_CNXNS
    ZOO_AUTOPURGE_INTERVAL
    ZOO_AUTOPURGE_RETAIN_COUNT
    ZOO_LOG_LEVEL
    ZOO_4LW_COMMANDS_WHITELIST
    ZOO_RECONFIG_ENABLED
    ZOO_LISTEN_ALLIPS_ENABLED
    ZOO_ENABLE_PROMETHEUS_METRICS
    ZOO_PROMETHEUS_METRICS_PORT_NUMBER
    ZOO_MAX_SESSION_TIMEOUT
    ZOO_PRE_ALLOC_SIZE
    ZOO_SNAPCOUNT
    ZOO_HC_TIMEOUT
    ZOO_TLS_CLIENT_ENABLE
    ZOO_TLS_PORT_NUMBER
    ZOO_TLS_CLIENT_KEYSTORE_FILE
    ZOO_TLS_CLIENT_KEYSTORE_PASSWORD
    ZOO_TLS_CLIENT_TRUSTSTORE_FILE
    ZOO_TLS_CLIENT_TRUSTSTORE_PASSWORD
    ZOO_TLS_CLIENT_AUTH
    ZOO_TLS_QUORUM_ENABLE
    ZOO_TLS_QUORUM_KEYSTORE_FILE
    ZOO_TLS_QUORUM_KEYSTORE_PASSWORD
    ZOO_TLS_QUORUM_TRUSTSTORE_FILE
    ZOO_TLS_QUORUM_TRUSTSTORE_PASSWORD
    ZOO_TLS_QUORUM_CLIENT_AUTH
    JVMFLAGS
    ZOO_HEAP_SIZE
    ALLOW_ANONYMOUS_LOGIN
    ZOO_ENABLE_AUTH
    ZOO_CLIENT_USER
    ZOO_SERVER_USERS
    ZOO_CLIENT_PASSWORD
    ZOO_SERVER_PASSWORDS
    ZOO_ENABLE_QUORUM_AUTH
    ZOO_QUORUM_LEARNER_USER
    ZOO_QUORUM_LEARNER_PASSWORD
    ZOO_QUORUM_SERVER_USERS
    ZOO_QUORUM_SERVER_PASSWORDS
)
for env_var in "${zookeeper_env_vars[@]}"; do
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
unset zookeeper_env_vars

# Paths
export ZOO_BASE_DIR="${BITNAMI_ROOT_DIR}/zookeeper"
export ZOO_VOLUME_DIR="/bitnami/zookeeper"
export ZOO_DATA_DIR="${ZOO_VOLUME_DIR}/data"
export ZOO_DATA_LOG_DIR="${ZOO_DATA_LOG_DIR:-}"
export ZOO_CONF_DIR="${ZOO_BASE_DIR}/conf"
export ZOO_DEFAULT_CONF_DIR="${ZOO_BASE_DIR}/conf.default"
export ZOO_CONF_FILE="${ZOO_CONF_DIR}/zoo.cfg"
export ZOO_LOG_DIR="${ZOO_BASE_DIR}/logs"
export ZOO_LOG_FILE="${ZOO_LOG_DIR}/zookeeper.out"
export ZOO_BIN_DIR="${ZOO_BASE_DIR}/bin"
export PATH="${BITNAMI_ROOT_DIR}/common/bin:${BITNAMI_ROOT_DIR}/java/bin:${PATH}"

# System users (when running with a privileged user)
export ZOO_DAEMON_USER="zookeeper"
export ZOO_DAEMON_GROUP="zookeeper"

# ZooKeeper cluster configuration
export ZOO_PORT_NUMBER="${ZOO_PORT_NUMBER:-2181}"
export ZOO_SERVER_ID="${ZOO_SERVER_ID:-1}"
export ZOO_SERVERS="${ZOO_SERVERS:-}"
export ZOO_ENABLE_ADMIN_SERVER="${ZOO_ENABLE_ADMIN_SERVER:-yes}"
export ZOO_ADMIN_SERVER_PORT_NUMBER="${ZOO_ADMIN_SERVER_PORT_NUMBER:-8080}"
export ZOO_PEER_TYPE="${ZOO_PEER_TYPE:-}"

# ZooKeeper settings
export ZOO_TICK_TIME="${ZOO_TICK_TIME:-2000}"
export ZOO_INIT_LIMIT="${ZOO_INIT_LIMIT:-10}"
export ZOO_SYNC_LIMIT="${ZOO_SYNC_LIMIT:-5}"
export ZOO_MAX_CNXNS="${ZOO_MAX_CNXNS:-0}"
export ZOO_MAX_CLIENT_CNXNS="${ZOO_MAX_CLIENT_CNXNS:-60}"
export ZOO_AUTOPURGE_INTERVAL="${ZOO_AUTOPURGE_INTERVAL:-0}"
export ZOO_AUTOPURGE_RETAIN_COUNT="${ZOO_AUTOPURGE_RETAIN_COUNT:-3}"
export ZOO_LOG_LEVEL="${ZOO_LOG_LEVEL:-INFO}"
export ZOO_4LW_COMMANDS_WHITELIST="${ZOO_4LW_COMMANDS_WHITELIST:-srvr, mntr}"
export ZOO_RECONFIG_ENABLED="${ZOO_RECONFIG_ENABLED:-no}"
export ZOO_LISTEN_ALLIPS_ENABLED="${ZOO_LISTEN_ALLIPS_ENABLED:-no}"
export ZOO_ENABLE_PROMETHEUS_METRICS="${ZOO_ENABLE_PROMETHEUS_METRICS:-no}"
export ZOO_PROMETHEUS_METRICS_PORT_NUMBER="${ZOO_PROMETHEUS_METRICS_PORT_NUMBER:-7000}"
export ZOO_MAX_SESSION_TIMEOUT="${ZOO_MAX_SESSION_TIMEOUT:-40000}"
export ZOO_PRE_ALLOC_SIZE="${ZOO_PRE_ALLOC_SIZE:-65536}"
export ZOO_SNAPCOUNT="${ZOO_SNAPCOUNT:-100000}"
export ZOO_HC_TIMEOUT="${ZOO_HC_TIMEOUT:-5}"

# ZooKeeper TLS settings
export ZOO_TLS_CLIENT_ENABLE="${ZOO_TLS_CLIENT_ENABLE:-false}"
export ZOO_TLS_PORT_NUMBER="${ZOO_TLS_PORT_NUMBER:-3181}"
export ZOO_TLS_CLIENT_KEYSTORE_FILE="${ZOO_TLS_CLIENT_KEYSTORE_FILE:-}"
export ZOO_TLS_CLIENT_KEYSTORE_PASSWORD="${ZOO_TLS_CLIENT_KEYSTORE_PASSWORD:-}"
export ZOO_TLS_CLIENT_TRUSTSTORE_FILE="${ZOO_TLS_CLIENT_TRUSTSTORE_FILE:-}"
export ZOO_TLS_CLIENT_TRUSTSTORE_PASSWORD="${ZOO_TLS_CLIENT_TRUSTSTORE_PASSWORD:-}"
export ZOO_TLS_CLIENT_AUTH="${ZOO_TLS_CLIENT_AUTH:-need}"
export ZOO_TLS_QUORUM_ENABLE="${ZOO_TLS_QUORUM_ENABLE:-false}"
export ZOO_TLS_QUORUM_KEYSTORE_FILE="${ZOO_TLS_QUORUM_KEYSTORE_FILE:-}"
export ZOO_TLS_QUORUM_KEYSTORE_PASSWORD="${ZOO_TLS_QUORUM_KEYSTORE_PASSWORD:-}"
export ZOO_TLS_QUORUM_TRUSTSTORE_FILE="${ZOO_TLS_QUORUM_TRUSTSTORE_FILE:-}"
export ZOO_TLS_QUORUM_TRUSTSTORE_PASSWORD="${ZOO_TLS_QUORUM_TRUSTSTORE_PASSWORD:-}"
export ZOO_TLS_QUORUM_CLIENT_AUTH="${ZOO_TLS_QUORUM_CLIENT_AUTH:-need}"

# Java settings
export JVMFLAGS="${JVMFLAGS:-}"
export ZOO_HEAP_SIZE="${ZOO_HEAP_SIZE:-1024}"

# Client-server authentication
export ALLOW_ANONYMOUS_LOGIN="${ALLOW_ANONYMOUS_LOGIN:-no}"
export ZOO_ENABLE_AUTH="${ZOO_ENABLE_AUTH:-no}"
export ZOO_CLIENT_USER="${ZOO_CLIENT_USER:-}"
export ZOO_SERVER_USERS="${ZOO_SERVER_USERS:-}"
export ZOO_CLIENT_PASSWORD="${ZOO_CLIENT_PASSWORD:-}"
export ZOO_SERVER_PASSWORDS="${ZOO_SERVER_PASSWORDS:-}"

# Server-server authentication
export ZOO_ENABLE_QUORUM_AUTH="${ZOO_ENABLE_QUORUM_AUTH:-no}"
export ZOO_QUORUM_LEARNER_USER="${ZOO_QUORUM_LEARNER_USER:-}"
export ZOO_QUORUM_LEARNER_PASSWORD="${ZOO_QUORUM_LEARNER_PASSWORD:-}"
export ZOO_QUORUM_SERVER_USERS="${ZOO_QUORUM_SERVER_USERS:-}"
export ZOO_QUORUM_SERVER_PASSWORDS="${ZOO_QUORUM_SERVER_PASSWORDS:-}"

# Custom environment variables may be defined below
