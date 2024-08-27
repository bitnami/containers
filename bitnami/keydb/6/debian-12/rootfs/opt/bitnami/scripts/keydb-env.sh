#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for keydb

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
export MODULE="${MODULE:-keydb}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
keydb_env_vars=(
    KEYDB_DATA_DIR
    KEYDB_OVERRIDES_FILE
    KEYDB_DISABLE_COMMANDS
    KEYDB_DATABASE
    KEYDB_AOF_ENABLED
    KEYDB_RDB_POLICY
    KEYDB_RDB_POLICY_DISABLED
    KEYDB_PORT_NUMBER
    KEYDB_ALLOW_REMOTE_CONNECTIONS
    KEYDB_EXTRA_FLAGS
    ALLOW_EMPTY_PASSWORD
    KEYDB_PASSWORD
    KEYDB_ACL_FILE
    KEYDB_IO_THREADS_DO_READS
    KEYDB_IO_THREADS
    KEYDB_REPLICATION_MODE
    KEYDB_ACTIVE_REPLICA
    KEYDB_MASTER_HOSTS
    KEYDB_MASTER_PORT_NUMBER
    KEYDB_MASTER_PASSWORD
    KEYDB_REPLICA_IP
    KEYDB_REPLICA_PORT
    KEYDB_TLS_ENABLED
    KEYDB_TLS_PORT_NUMBER
    KEYDB_TLS_CERT_FILE
    KEYDB_TLS_CA_DIR
    KEYDB_TLS_KEY_FILE
    KEYDB_TLS_KEY_FILE_PASS
    KEYDB_TLS_CA_FILE
    KEYDB_TLS_DH_PARAMS_FILE
    KEYDB_TLS_AUTH_CLIENTS
)
for env_var in "${keydb_env_vars[@]}"; do
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
unset keydb_env_vars

# Paths
export KEYDB_VOLUME_DIR="/bitnami/keydb"
export KEYDB_BASE_DIR="${BITNAMI_ROOT_DIR}/keydb"
export KEYDB_CONF_DIR="${KEYDB_BASE_DIR}/etc"
export KEYDB_DEFAULT_CONF_DIR="${KEYDB_BASE_DIR}/etc.default"
export KEYDB_DATA_DIR="${KEYDB_DATA_DIR:-${KEYDB_VOLUME_DIR}/data}"
export KEYDB_MOUNTED_CONF_DIR="${KEYDB_BASE_DIR}/mounted-etc"
export KEYDB_OVERRIDES_FILE="${KEYDB_OVERRIDES_FILE:-${KEYDB_MOUNTED_CONF_DIR}/overrides.conf}"
export KEYDB_CONF_FILE="${KEYDB_CONF_DIR}/keydb.conf"
export KEYDB_TMP_DIR="${KEYDB_BASE_DIR}/tmp"
export KEYDB_PID_FILE="${KEYDB_TMP_DIR}/keydb.pid"
export KEYDB_BIN_DIR="${KEYDB_BASE_DIR}/bin"

# System users (when running with a privileged user)
export KEYDB_DAEMON_USER="keydb"
export KEYDB_DAEMON_GROUP="keydb"

# KeyDB settings.
export KEYDB_DISABLE_COMMANDS="${KEYDB_DISABLE_COMMANDS:-}"
export KEYDB_DATABASE="${KEYDB_DATABASE:-keydb}"
export KEYDB_AOF_ENABLED="${KEYDB_AOF_ENABLED:-yes}"
export KEYDB_RDB_POLICY="${KEYDB_RDB_POLICY:-}"
export KEYDB_RDB_POLICY_DISABLED="${KEYDB_RDB_POLICY_DISABLED:-no}"
export KEYDB_DEFAULT_PORT_NUMBER="6379" # only used at build time
export KEYDB_PORT_NUMBER="${KEYDB_PORT_NUMBER:-$KEYDB_DEFAULT_PORT_NUMBER}"
export KEYDB_ALLOW_REMOTE_CONNECTIONS="${KEYDB_ALLOW_REMOTE_CONNECTIONS:-yes}"
export KEYDB_EXTRA_FLAGS="${KEYDB_EXTRA_FLAGS:-}"
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"
export KEYDB_PASSWORD="${KEYDB_PASSWORD:-}"
export KEYDB_ACL_FILE="${KEYDB_ACL_FILE:-}"
export KEYDB_IO_THREADS_DO_READS="${KEYDB_IO_THREADS_DO_READS:-}"
export KEYDB_IO_THREADS="${KEYDB_IO_THREADS:-}"

# Replication settings.
export KEYDB_REPLICATION_MODE="${KEYDB_REPLICATION_MODE:-}"
export KEYDB_ACTIVE_REPLICA="${KEYDB_ACTIVE_REPLICA:-no}"
export KEYDB_MASTER_HOSTS="${KEYDB_MASTER_HOSTS:-}"
export KEYDB_MASTER_PORT_NUMBER="${KEYDB_MASTER_PORT_NUMBER:-6379}"
export KEYDB_MASTER_PASSWORD="${KEYDB_MASTER_PASSWORD:-}"
export KEYDB_REPLICA_IP="${KEYDB_REPLICA_IP:-}"
export KEYDB_REPLICA_PORT="${KEYDB_REPLICA_PORT:-}"

# TLS settings.
export KEYDB_TLS_ENABLED="${KEYDB_TLS_ENABLED:-no}"
export KEYDB_TLS_PORT_NUMBER="${KEYDB_TLS_PORT_NUMBER:-6379}"
export KEYDB_TLS_CERT_FILE="${KEYDB_TLS_CERT_FILE:-}"
export KEYDB_TLS_CA_DIR="${KEYDB_TLS_CA_DIR:-}"
export KEYDB_TLS_KEY_FILE="${KEYDB_TLS_KEY_FILE:-}"
export KEYDB_TLS_KEY_FILE_PASS="${KEYDB_TLS_KEY_FILE_PASS:-}"
export KEYDB_TLS_CA_FILE="${KEYDB_TLS_CA_FILE:-}"
export KEYDB_TLS_DH_PARAMS_FILE="${KEYDB_TLS_DH_PARAMS_FILE:-}"
export KEYDB_TLS_AUTH_CLIENTS="${KEYDB_TLS_AUTH_CLIENTS:-yes}"

# Custom environment variables may be defined below
