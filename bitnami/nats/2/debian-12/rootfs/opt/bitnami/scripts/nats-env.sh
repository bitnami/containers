#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for nats

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
export MODULE="${MODULE:-nats}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
nats_env_vars=(
    NATS_BIND_ADDRESS
    NATS_CLIENT_PORT_NUMBER
    NATS_HTTP_PORT_NUMBER
    NATS_HTTPS_PORT_NUMBER
    NATS_CLUSTER_PORT_NUMBER
    NATS_FILENAME
    NATS_CONF_FILE
    NATS_LOG_FILE
    NATS_PID_FILE
    NATS_ENABLE_AUTH
    NATS_USERNAME
    NATS_PASSWORD
    NATS_TOKEN
    NATS_ENABLE_TLS
    NATS_TLS_CRT_FILENAME
    NATS_TLS_KEY_FILENAME
    NATS_ENABLE_CLUSTER
    NATS_CLUSTER_USERNAME
    NATS_CLUSTER_PASSWORD
    NATS_CLUSTER_TOKEN
    NATS_CLUSTER_ROUTES
    NATS_CLUSTER_SEED_NODE
    NATS_EXTRA_ARGS
)
for env_var in "${nats_env_vars[@]}"; do
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
unset nats_env_vars

# Paths
export NATS_BASE_DIR="${BITNAMI_ROOT_DIR}/nats"
export NATS_BIN_DIR="${NATS_BASE_DIR}/bin"
export NATS_CONF_DIR="${NATS_BASE_DIR}/conf"
export NATS_DEFAULT_CONF_DIR="${NATS_BASE_DIR}/conf.default"
export NATS_LOGS_DIR="${NATS_BASE_DIR}/logs"
export NATS_TMP_DIR="${NATS_BASE_DIR}/tmp"
export NATS_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/nats"
export NATS_DATA_DIR="${NATS_VOLUME_DIR}/data"
export NATS_MOUNTED_CONF_DIR="${NATS_VOLUME_DIR}/conf"
export NATS_INITSCRIPTS_DIR="/docker-entrypoint-initdb.d"
export PATH="${NATS_BIN_DIR}:${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# System users (when running with a privileged user)
export NATS_DAEMON_USER="nats"
export NATS_DAEMON_GROUP="nats"

# Constants
export NATS_DEFAULT_BIND_ADDRESS="0.0.0.0"
export NATS_DEFAULT_CLIENT_PORT_NUMBER="4222" # only used at build time
export NATS_DEFAULT_HTTP_PORT_NUMBER="8222" # only used at build time
export NATS_DEFAULT_HTTPS_PORT_NUMBER="8443" # only used at build time
export NATS_DEFAULT_CLUSTER_PORT_NUMBER="6222" # only used at build time

# NATS configuration
export NATS_BIND_ADDRESS="${NATS_BIND_ADDRESS:-$NATS_DEFAULT_BIND_ADDRESS}"
export NATS_CLIENT_PORT_NUMBER="${NATS_CLIENT_PORT_NUMBER:-$NATS_DEFAULT_CLIENT_PORT_NUMBER}"
export NATS_HTTP_PORT_NUMBER="${NATS_HTTP_PORT_NUMBER:-$NATS_DEFAULT_HTTP_PORT_NUMBER}"
export NATS_HTTPS_PORT_NUMBER="${NATS_HTTPS_PORT_NUMBER:-$NATS_DEFAULT_HTTPS_PORT_NUMBER}"
export NATS_CLUSTER_PORT_NUMBER="${NATS_CLUSTER_PORT_NUMBER:-$NATS_DEFAULT_CLUSTER_PORT_NUMBER}"
export NATS_FILENAME="${NATS_FILENAME:-nats-server}"
export NATS_CONF_FILE="${NATS_CONF_FILE:-${NATS_CONF_DIR}/${NATS_FILENAME}.conf}"
export NATS_LOG_FILE="${NATS_LOG_FILE:-${NATS_LOGS_DIR}/${NATS_FILENAME}.log}"
export NATS_PID_FILE="${NATS_PID_FILE:-${NATS_TMP_DIR}/${NATS_FILENAME}.pid}"
export NATS_ENABLE_AUTH="${NATS_ENABLE_AUTH:-no}"
export NATS_USERNAME="${NATS_USERNAME:-nats}"
export NATS_PASSWORD="${NATS_PASSWORD:-}"
export NATS_TOKEN="${NATS_TOKEN:-}"
export NATS_ENABLE_TLS="${NATS_ENABLE_TLS:-no}"
export NATS_TLS_CRT_FILENAME="${NATS_TLS_CRT_FILENAME:-${NATS_FILENAME}.crt}"
export NATS_TLS_KEY_FILENAME="${NATS_TLS_KEY_FILENAME:-${NATS_FILENAME}.key}"

# NATS cluster configuration
export NATS_ENABLE_CLUSTER="${NATS_ENABLE_CLUSTER:-no}"
export NATS_CLUSTER_USERNAME="${NATS_CLUSTER_USERNAME:-nats}"
export NATS_CLUSTER_PASSWORD="${NATS_CLUSTER_PASSWORD:-}"
export NATS_CLUSTER_TOKEN="${NATS_CLUSTER_TOKEN:-}"
export NATS_CLUSTER_ROUTES="${NATS_CLUSTER_ROUTES:-}"
export NATS_CLUSTER_SEED_NODE="${NATS_CLUSTER_SEED_NODE:-}"
export NATS_EXTRA_ARGS="${NATS_EXTRA_ARGS:-}"

# Custom environment variables may be defined below
