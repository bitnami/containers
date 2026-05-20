#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for valkey-cluster

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
export MODULE="${MODULE:-valkey-cluster}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
valkey_cluster_env_vars=(
    VALKEY_DATA_DIR
    VALKEY_OVERRIDES_FILE
    VALKEY_DISABLE_COMMANDS
    VALKEY_DATABASE
    VALKEY_AOF_ENABLED
    VALKEY_RDB_POLICY
    VALKEY_RDB_POLICY_DISABLED
    VALKEY_PRIMARY_HOST
    VALKEY_PRIMARY_PORT_NUMBER
    VALKEY_PORT_NUMBER
    VALKEY_ALLOW_REMOTE_CONNECTIONS
    VALKEY_REPLICATION_MODE
    VALKEY_REPLICA_IP
    VALKEY_REPLICA_PORT
    VALKEY_EXTRA_FLAGS
    ALLOW_EMPTY_PASSWORD
    VALKEY_PASSWORD
    VALKEY_PRIMARY_PASSWORD
    VALKEY_ACLFILE
    VALKEY_IO_THREADS_DO_READS
    VALKEY_IO_THREADS
    VALKEY_TLS_ENABLED
    VALKEY_TLS_PORT_NUMBER
    VALKEY_TLS_CERT_FILE
    VALKEY_TLS_CA_DIR
    VALKEY_TLS_KEY_FILE
    VALKEY_TLS_KEY_FILE_PASS
    VALKEY_TLS_CA_FILE
    VALKEY_TLS_DH_PARAMS_FILE
    VALKEY_TLS_AUTH_CLIENTS
    VALKEY_CLUSTER_CREATOR
    VALKEY_CLUSTER_REPLICAS
    VALKEY_CLUSTER_DYNAMIC_IPS
    VALKEY_CLUSTER_ANNOUNCE_IP
    VALKEY_CLUSTER_ANNOUNCE_PORT
    VALKEY_CLUSTER_ANNOUNCE_BUS_PORT
    VALKEY_DNS_RETRIES
    VALKEY_NODES
    VALKEY_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP
    VALKEY_CLUSTER_DNS_LOOKUP_RETRIES
    VALKEY_CLUSTER_DNS_LOOKUP_SLEEP
    VALKEY_CLUSTER_ANNOUNCE_HOSTNAME
    VALKEY_CLUSTER_PREFERRED_ENDPOINT_TYPE
    VALKEY_TLS_PORT
)
for env_var in "${valkey_cluster_env_vars[@]}"; do
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
unset valkey_cluster_env_vars

# Paths
export VALKEY_VOLUME_DIR="/bitnami/valkey"
export VALKEY_BASE_DIR="${BITNAMI_ROOT_DIR}/valkey"
export VALKEY_CONF_DIR="${VALKEY_BASE_DIR}/etc"
export VALKEY_DEFAULT_CONF_DIR="${VALKEY_BASE_DIR}/etc.default"
export VALKEY_DATA_DIR="${VALKEY_DATA_DIR:-${VALKEY_VOLUME_DIR}/data}"
export VALKEY_MOUNTED_CONF_DIR="${VALKEY_BASE_DIR}/mounted-etc"
export VALKEY_OVERRIDES_FILE="${VALKEY_OVERRIDES_FILE:-${VALKEY_MOUNTED_CONF_DIR}/overrides.conf}"
export VALKEY_CONF_FILE="${VALKEY_CONF_DIR}/valkey.conf"
export VALKEY_LOG_DIR="${VALKEY_BASE_DIR}/logs"
export VALKEY_LOG_FILE="${VALKEY_LOG_DIR}/valkey.log"
export VALKEY_TMP_DIR="${VALKEY_BASE_DIR}/tmp"
export VALKEY_PID_FILE="${VALKEY_TMP_DIR}/valkey.pid"
export VALKEY_BIN_DIR="${VALKEY_BASE_DIR}/bin"
export PATH="${VALKEY_BIN_DIR}:${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# System users (when running with a privileged user)
export VALKEY_DAEMON_USER="valkey"
export VALKEY_DAEMON_GROUP="valkey"

# Valkey settings
export VALKEY_DISABLE_COMMANDS="${VALKEY_DISABLE_COMMANDS:-}"
export VALKEY_DATABASE="${VALKEY_DATABASE:-valkey}"
export VALKEY_AOF_ENABLED="${VALKEY_AOF_ENABLED:-yes}"
export VALKEY_RDB_POLICY="${VALKEY_RDB_POLICY:-}"
export VALKEY_RDB_POLICY_DISABLED="${VALKEY_RDB_POLICY_DISABLED:-no}"
export VALKEY_PRIMARY_HOST="${VALKEY_PRIMARY_HOST:-}"
export VALKEY_PRIMARY_PORT_NUMBER="${VALKEY_PRIMARY_PORT_NUMBER:-6379}"
export VALKEY_DEFAULT_PORT_NUMBER="6379" # only used at build time
export VALKEY_PORT_NUMBER="${VALKEY_PORT_NUMBER:-$VALKEY_DEFAULT_PORT_NUMBER}"
export VALKEY_ALLOW_REMOTE_CONNECTIONS="${VALKEY_ALLOW_REMOTE_CONNECTIONS:-yes}"
export VALKEY_REPLICATION_MODE="${VALKEY_REPLICATION_MODE:-}"
export VALKEY_REPLICA_IP="${VALKEY_REPLICA_IP:-}"
export VALKEY_REPLICA_PORT="${VALKEY_REPLICA_PORT:-}"
export VALKEY_EXTRA_FLAGS="${VALKEY_EXTRA_FLAGS:-}"
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"
export VALKEY_PASSWORD="${VALKEY_PASSWORD:-}"
export VALKEY_PRIMARY_PASSWORD="${VALKEY_PRIMARY_PASSWORD:-}"
export VALKEY_ACLFILE="${VALKEY_ACLFILE:-}"
export VALKEY_IO_THREADS_DO_READS="${VALKEY_IO_THREADS_DO_READS:-}"
export VALKEY_IO_THREADS="${VALKEY_IO_THREADS:-}"

# TLS settings
export VALKEY_TLS_ENABLED="${VALKEY_TLS_ENABLED:-no}"
VALKEY_TLS_PORT_NUMBER="${VALKEY_TLS_PORT_NUMBER:-"${VALKEY_TLS_PORT:-}"}"
export VALKEY_TLS_PORT_NUMBER="${VALKEY_TLS_PORT_NUMBER:-6379}"
export VALKEY_TLS_CERT_FILE="${VALKEY_TLS_CERT_FILE:-}"
export VALKEY_TLS_CA_DIR="${VALKEY_TLS_CA_DIR:-}"
export VALKEY_TLS_KEY_FILE="${VALKEY_TLS_KEY_FILE:-}"
export VALKEY_TLS_KEY_FILE_PASS="${VALKEY_TLS_KEY_FILE_PASS:-}"
export VALKEY_TLS_CA_FILE="${VALKEY_TLS_CA_FILE:-}"
export VALKEY_TLS_DH_PARAMS_FILE="${VALKEY_TLS_DH_PARAMS_FILE:-}"
export VALKEY_TLS_AUTH_CLIENTS="${VALKEY_TLS_AUTH_CLIENTS:-yes}"

# Valkey Cluster settings
export VALKEY_CLUSTER_CREATOR="${VALKEY_CLUSTER_CREATOR:-no}"
export VALKEY_CLUSTER_REPLICAS="${VALKEY_CLUSTER_REPLICAS:-1}"
export VALKEY_CLUSTER_DYNAMIC_IPS="${VALKEY_CLUSTER_DYNAMIC_IPS:-yes}"
export VALKEY_CLUSTER_ANNOUNCE_IP="${VALKEY_CLUSTER_ANNOUNCE_IP:-}"
export VALKEY_CLUSTER_ANNOUNCE_PORT="${VALKEY_CLUSTER_ANNOUNCE_PORT:-}"
export VALKEY_CLUSTER_ANNOUNCE_BUS_PORT="${VALKEY_CLUSTER_ANNOUNCE_BUS_PORT:-}"
export VALKEY_DNS_RETRIES="${VALKEY_DNS_RETRIES:-120}"
export VALKEY_NODES="${VALKEY_NODES:-}"
export VALKEY_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP="${VALKEY_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP:-0}"
export VALKEY_CLUSTER_DNS_LOOKUP_RETRIES="${VALKEY_CLUSTER_DNS_LOOKUP_RETRIES:-1}"
export VALKEY_CLUSTER_DNS_LOOKUP_SLEEP="${VALKEY_CLUSTER_DNS_LOOKUP_SLEEP:-1}"
export VALKEY_CLUSTER_ANNOUNCE_HOSTNAME="${VALKEY_CLUSTER_ANNOUNCE_HOSTNAME:-}"
export VALKEY_CLUSTER_PREFERRED_ENDPOINT_TYPE="${VALKEY_CLUSTER_PREFERRED_ENDPOINT_TYPE:-ip}"

# Custom environment variables may be defined below
