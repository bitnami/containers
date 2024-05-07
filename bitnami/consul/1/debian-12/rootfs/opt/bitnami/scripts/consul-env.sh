#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for consul

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
export MODULE="${MODULE:-consul}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
consul_env_vars=(
    CONSUL_RPC_PORT_NUMBER
    CONSUL_HTTP_PORT_NUMBER
    CONSUL_DNS_PORT_NUMBER
    CONSUL_DNS_PORT_NUMBER
    CONSUL_AGENT_MODE
    CONSUL_DISABLE_KEYRING_FILE
    CONSUL_SERF_LAN_ADDRESS
    CONSUL_SERF_LAN_PORT_NUMBER
    CONSUL_CLIENT_LAN_ADDRESS
    CONSUL_RETRY_JOIN_ADDRESS
    CONSUL_RETRY_JOIN_WAN_ADDRESS
    CONSUL_BIND_INTERFACE
    CONSUL_BIND_ADDR
    CONSUL_ENABLE_UI
    CONSUL_BOOTSTRAP_EXPECT
    CONSUL_RAFT_MULTIPLIER
    CONSUL_LOCAL_CONFIG
    CONSUL_GOSSIP_ENCRYPTION
    CONSUL_GOSSIP_ENCRYPTION_KEY
    CONSUL_DATACENTER
    CONSUL_DOMAIN
    CONSUL_NODE_NAME
    CONSUL_DISABLE_HOST_NODE_ID
    CONSUL_SERVER_MODE
    CONSUL_RETRY_JOIN
    CONSUL_UI
)
for env_var in "${consul_env_vars[@]}"; do
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
unset consul_env_vars

# Paths
export PATH="${BITNAMI_ROOT_DIR}/common/bin:${PATH}"
export CONSUL_BASE_DIR="${BITNAMI_ROOT_DIR}/consul"
export CONSUL_CONF_DIR="${CONSUL_BASE_DIR}/conf"
export CONSUL_DEFAULT_CONF_DIR="${CONSUL_BASE_DIR}/conf.default"
export CONSUL_BIN_DIR="${CONSUL_BASE_DIR}/bin"
export CONSUL_CONF_FILE="${CONSUL_CONF_DIR}/consul.json"
export CONSUL_ENCRYPT_FILE="${CONSUL_CONF_DIR}/encrypt.json"
export CONSUL_LOCAL_FILE="${CONSUL_CONF_DIR}/local.json"
export CONSUL_LOG_DIR="${CONSUL_BASE_DIR}/logs"
export CONSUL_LOG_FILE="${CONSUL_LOG_DIR}/consul.log"
export CONSUL_VOLUME_DIR="/bitnami/consul"
export CONSUL_DATA_DIR="${CONSUL_VOLUME_DIR}"
export CONSUL_SSL_DIR="${CONSUL_BASE_DIR}/certificates"
export CONSUL_TMP_DIR="${CONSUL_BASE_DIR}/tmp"
export CONSUL_PID_FILE="${CONSUL_TMP_DIR}/consul.pid"
export CONSUL_TEMPLATES_DIR="${CONSUL_BASE_DIR}/templates"
export CONSUL_CONFIG_TEMPLATE_FILE="${CONSUL_TEMPLATES_DIR}/consul.json.tpl"
export CONSUL_ENCRYPT_TEMPLATE_FILE="${CONSUL_TEMPLATES_DIR}/encrypt.json.tpl"
export CONSUL_LOCAL_TEMPLATE_FILE="${CONSUL_TEMPLATES_DIR}/local.json.tpl"
export CONSUL_INITSCRIPTS_DIR="/docker-entrypoint-initdb.d"

# System users (when running with a privileged user)
export CONSUL_DAEMON_USER="consul"
export CONSUL_SYSTEM_USER="$CONSUL_DAEMON_USER"
export CONSUL_DAEMON_GROUP="consul"
export CONSUL_SYSTEM_GROUP="$CONSUL_DAEMON_GROUP"

# Consul runtime settings
export CONSUL_RPC_PORT_NUMBER="${CONSUL_RPC_PORT_NUMBER:-8300}"
export CONSUL_HTTP_PORT_NUMBER="${CONSUL_HTTP_PORT_NUMBER:-8500}"
export CONSUL_DNS_PORT_NUMBER="${CONSUL_DNS_PORT_NUMBER:-8600}"
export CONSUL_DNS_PORT_NUMBER="${CONSUL_DNS_PORT_NUMBER:-8600}"
CONSUL_AGENT_MODE="${CONSUL_AGENT_MODE:-"${CONSUL_SERVER_MODE:-}"}"
export CONSUL_AGENT_MODE="${CONSUL_AGENT_MODE:-server}"
export CONSUL_DISABLE_KEYRING_FILE="${CONSUL_DISABLE_KEYRING_FILE:-false}"
export CONSUL_SERF_LAN_ADDRESS="${CONSUL_SERF_LAN_ADDRESS:-0.0.0.0}"
export CONSUL_SERF_LAN_PORT_NUMBER="${CONSUL_SERF_LAN_PORT_NUMBER:-8301}"
export CONSUL_CLIENT_LAN_ADDRESS="${CONSUL_CLIENT_LAN_ADDRESS:-0.0.0.0}"
CONSUL_RETRY_JOIN_ADDRESS="${CONSUL_RETRY_JOIN_ADDRESS:-"${CONSUL_RETRY_JOIN:-}"}"
export CONSUL_RETRY_JOIN_ADDRESS="${CONSUL_RETRY_JOIN_ADDRESS:-127.0.0.1}"
export CONSUL_RETRY_JOIN_WAN_ADDRESS="${CONSUL_RETRY_JOIN_WAN_ADDRESS:-127.0.0.1}"
export CONSUL_BIND_INTERFACE="${CONSUL_BIND_INTERFACE:-}"
export CONSUL_BIND_ADDR="${CONSUL_BIND_ADDR:-}"
CONSUL_ENABLE_UI="${CONSUL_ENABLE_UI:-"${CONSUL_UI:-}"}"
export CONSUL_ENABLE_UI="${CONSUL_ENABLE_UI:-true}"
export CONSUL_BOOTSTRAP_EXPECT="${CONSUL_BOOTSTRAP_EXPECT:-1}"
export CONSUL_RAFT_MULTIPLIER="${CONSUL_RAFT_MULTIPLIER:-1}"
export CONSUL_LOCAL_CONFIG="${CONSUL_LOCAL_CONFIG:-}"
export CONSUL_GOSSIP_ENCRYPTION="${CONSUL_GOSSIP_ENCRYPTION:-no}"
export CONSUL_GOSSIP_ENCRYPTION_KEY="${CONSUL_GOSSIP_ENCRYPTION_KEY:-}"
export CONSUL_DATACENTER="${CONSUL_DATACENTER:-dc1}"
export CONSUL_DOMAIN="${CONSUL_DOMAIN:-consul}"
export CONSUL_NODE_NAME="${CONSUL_NODE_NAME:-}"
export CONSUL_DISABLE_HOST_NODE_ID="${CONSUL_DISABLE_HOST_NODE_ID:-true}"

# Custom environment variables may be defined below
