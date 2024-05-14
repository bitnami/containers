#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for redis-cluster

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
export MODULE="${MODULE:-redis-cluster}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
redis_cluster_env_vars=(
    REDIS_DATA_DIR
    REDIS_OVERRIDES_FILE
    REDIS_DISABLE_COMMANDS
    REDIS_DATABASE
    REDIS_AOF_ENABLED
    REDIS_RDB_POLICY
    REDIS_RDB_POLICY_DISABLED
    REDIS_MASTER_HOST
    REDIS_MASTER_PORT_NUMBER
    REDIS_PORT_NUMBER
    REDIS_ALLOW_REMOTE_CONNECTIONS
    REDIS_REPLICATION_MODE
    REDIS_REPLICA_IP
    REDIS_REPLICA_PORT
    REDIS_EXTRA_FLAGS
    ALLOW_EMPTY_PASSWORD
    REDIS_PASSWORD
    REDIS_MASTER_PASSWORD
    REDIS_ACLFILE
    REDIS_IO_THREADS_DO_READS
    REDIS_IO_THREADS
    REDIS_TLS_ENABLED
    REDIS_TLS_PORT_NUMBER
    REDIS_TLS_CERT_FILE
    REDIS_TLS_CA_DIR
    REDIS_TLS_KEY_FILE
    REDIS_TLS_KEY_FILE_PASS
    REDIS_TLS_CA_FILE
    REDIS_TLS_DH_PARAMS_FILE
    REDIS_TLS_AUTH_CLIENTS
    REDIS_CLUSTER_CREATOR
    REDIS_CLUSTER_REPLICAS
    REDIS_CLUSTER_DYNAMIC_IPS
    REDIS_CLUSTER_ANNOUNCE_IP
    REDIS_CLUSTER_ANNOUNCE_PORT
    REDIS_CLUSTER_ANNOUNCE_BUS_PORT
    REDIS_DNS_RETRIES
    REDIS_NODES
    REDIS_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP
    REDIS_CLUSTER_DNS_LOOKUP_RETRIES
    REDIS_CLUSTER_DNS_LOOKUP_SLEEP
    REDIS_CLUSTER_ANNOUNCE_HOSTNAME
    REDIS_CLUSTER_PREFERRED_ENDPOINT_TYPE
    REDIS_TLS_PORT
)
for env_var in "${redis_cluster_env_vars[@]}"; do
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
unset redis_cluster_env_vars

# Paths
export REDIS_VOLUME_DIR="/bitnami/redis"
export REDIS_BASE_DIR="${BITNAMI_ROOT_DIR}/redis"
export REDIS_CONF_DIR="${REDIS_BASE_DIR}/etc"
export REDIS_DEFAULT_CONF_DIR="${REDIS_BASE_DIR}/etc.default"
export REDIS_DATA_DIR="${REDIS_DATA_DIR:-${REDIS_VOLUME_DIR}/data}"
export REDIS_MOUNTED_CONF_DIR="${REDIS_BASE_DIR}/mounted-etc"
export REDIS_OVERRIDES_FILE="${REDIS_OVERRIDES_FILE:-${REDIS_MOUNTED_CONF_DIR}/overrides.conf}"
export REDIS_CONF_FILE="${REDIS_CONF_DIR}/redis.conf"
export REDIS_LOG_DIR="${REDIS_BASE_DIR}/logs"
export REDIS_LOG_FILE="${REDIS_LOG_DIR}/redis.log"
export REDIS_TMP_DIR="${REDIS_BASE_DIR}/tmp"
export REDIS_PID_FILE="${REDIS_TMP_DIR}/redis.pid"
export REDIS_BIN_DIR="${REDIS_BASE_DIR}/bin"
export PATH="${REDIS_BIN_DIR}:${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# System users (when running with a privileged user)
export REDIS_DAEMON_USER="redis"
export REDIS_DAEMON_GROUP="redis"

# Redis settings
export REDIS_DISABLE_COMMANDS="${REDIS_DISABLE_COMMANDS:-}"
export REDIS_DATABASE="${REDIS_DATABASE:-redis}"
export REDIS_AOF_ENABLED="${REDIS_AOF_ENABLED:-yes}"
export REDIS_RDB_POLICY="${REDIS_RDB_POLICY:-}"
export REDIS_RDB_POLICY_DISABLED="${REDIS_RDB_POLICY_DISABLED:-no}"
export REDIS_MASTER_HOST="${REDIS_MASTER_HOST:-}"
export REDIS_MASTER_PORT_NUMBER="${REDIS_MASTER_PORT_NUMBER:-6379}"
export REDIS_DEFAULT_PORT_NUMBER="6379" # only used at build time
export REDIS_PORT_NUMBER="${REDIS_PORT_NUMBER:-$REDIS_DEFAULT_PORT_NUMBER}"
export REDIS_ALLOW_REMOTE_CONNECTIONS="${REDIS_ALLOW_REMOTE_CONNECTIONS:-yes}"
export REDIS_REPLICATION_MODE="${REDIS_REPLICATION_MODE:-}"
export REDIS_REPLICA_IP="${REDIS_REPLICA_IP:-}"
export REDIS_REPLICA_PORT="${REDIS_REPLICA_PORT:-}"
export REDIS_EXTRA_FLAGS="${REDIS_EXTRA_FLAGS:-}"
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"
export REDIS_PASSWORD="${REDIS_PASSWORD:-}"
export REDIS_MASTER_PASSWORD="${REDIS_MASTER_PASSWORD:-}"
export REDIS_ACLFILE="${REDIS_ACLFILE:-}"
export REDIS_IO_THREADS_DO_READS="${REDIS_IO_THREADS_DO_READS:-}"
export REDIS_IO_THREADS="${REDIS_IO_THREADS:-}"

# TLS settings
export REDIS_TLS_ENABLED="${REDIS_TLS_ENABLED:-no}"
REDIS_TLS_PORT_NUMBER="${REDIS_TLS_PORT_NUMBER:-"${REDIS_TLS_PORT:-}"}"
export REDIS_TLS_PORT_NUMBER="${REDIS_TLS_PORT_NUMBER:-6379}"
export REDIS_TLS_CERT_FILE="${REDIS_TLS_CERT_FILE:-}"
export REDIS_TLS_CA_DIR="${REDIS_TLS_CA_DIR:-}"
export REDIS_TLS_KEY_FILE="${REDIS_TLS_KEY_FILE:-}"
export REDIS_TLS_KEY_FILE_PASS="${REDIS_TLS_KEY_FILE_PASS:-}"
export REDIS_TLS_CA_FILE="${REDIS_TLS_CA_FILE:-}"
export REDIS_TLS_DH_PARAMS_FILE="${REDIS_TLS_DH_PARAMS_FILE:-}"
export REDIS_TLS_AUTH_CLIENTS="${REDIS_TLS_AUTH_CLIENTS:-yes}"

# Redis Cluster settings
export REDIS_CLUSTER_CREATOR="${REDIS_CLUSTER_CREATOR:-no}"
export REDIS_CLUSTER_REPLICAS="${REDIS_CLUSTER_REPLICAS:-1}"
export REDIS_CLUSTER_DYNAMIC_IPS="${REDIS_CLUSTER_DYNAMIC_IPS:-yes}"
export REDIS_CLUSTER_ANNOUNCE_IP="${REDIS_CLUSTER_ANNOUNCE_IP:-}"
export REDIS_CLUSTER_ANNOUNCE_PORT="${REDIS_CLUSTER_ANNOUNCE_PORT:-}"
export REDIS_CLUSTER_ANNOUNCE_BUS_PORT="${REDIS_CLUSTER_ANNOUNCE_BUS_PORT:-}"
export REDIS_DNS_RETRIES="${REDIS_DNS_RETRIES:-120}"
export REDIS_NODES="${REDIS_NODES:-}"
export REDIS_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP="${REDIS_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP:-0}"
export REDIS_CLUSTER_DNS_LOOKUP_RETRIES="${REDIS_CLUSTER_DNS_LOOKUP_RETRIES:-1}"
export REDIS_CLUSTER_DNS_LOOKUP_SLEEP="${REDIS_CLUSTER_DNS_LOOKUP_SLEEP:-1}"
export REDIS_CLUSTER_ANNOUNCE_HOSTNAME="${REDIS_CLUSTER_ANNOUNCE_HOSTNAME:-}"
export REDIS_CLUSTER_PREFERRED_ENDPOINT_TYPE="${REDIS_CLUSTER_PREFERRED_ENDPOINT_TYPE:-ip}"

# Custom environment variables may be defined below
