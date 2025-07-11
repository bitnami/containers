#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for rabbitmq

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
export MODULE="${MODULE:-rabbitmq}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
rabbitmq_env_vars=(
    RABBITMQ_CONF_FILE
    RABBITMQ_DEFINITIONS_FILE
    RABBITMQ_SECURE_PASSWORD
    RABBITMQ_UPDATE_PASSWORD
    RABBITMQ_CLUSTER_NODE_NAME
    RABBITMQ_CLUSTER_PARTITION_HANDLING
    RABBITMQ_DISK_FREE_RELATIVE_LIMIT
    RABBITMQ_DISK_FREE_ABSOLUTE_LIMIT
    RABBITMQ_ERL_COOKIE
    RABBITMQ_VM_MEMORY_HIGH_WATERMARK
    RABBITMQ_LOAD_DEFINITIONS
    RABBITMQ_MANAGEMENT_BIND_IP
    RABBITMQ_MANAGEMENT_PORT_NUMBER
    RABBITMQ_MANAGEMENT_ALLOW_WEB_ACCESS
    RABBITMQ_NODE_NAME
    RABBITMQ_NODE_DEFAULT_QUEUE_TYPE
    RABBITMQ_USE_LONGNAME
    RABBITMQ_NODE_PORT_NUMBER
    RABBITMQ_NODE_TYPE
    RABBITMQ_VHOST
    RABBITMQ_VHOSTS
    RABBITMQ_CLUSTER_REBALANCE
    RABBITMQ_CLUSTER_REBALANCE_ATTEMPTS
    RABBITMQ_USERNAME
    RABBITMQ_PASSWORD
    RABBITMQ_FORCE_BOOT
    RABBITMQ_ENABLE_LDAP
    RABBITMQ_LDAP_TLS
    RABBITMQ_LDAP_SERVERS
    RABBITMQ_LDAP_SERVERS_PORT
    RABBITMQ_LDAP_USER_DN_PATTERN
    RABBITMQ_NODE_SSL_PORT_NUMBER
    RABBITMQ_SSL_CACERTFILE
    RABBITMQ_SSL_CERTFILE
    RABBITMQ_SSL_KEYFILE
    RABBITMQ_SSL_PASSWORD
    RABBITMQ_SSL_DEPTH
    RABBITMQ_SSL_FAIL_IF_NO_PEER_CERT
    RABBITMQ_SSL_VERIFY
    RABBITMQ_MANAGEMENT_SSL_PORT_NUMBER
    RABBITMQ_MANAGEMENT_SSL_CACERTFILE
    RABBITMQ_MANAGEMENT_SSL_CERTFILE
    RABBITMQ_MANAGEMENT_SSL_KEYFILE
    RABBITMQ_MANAGEMENT_SSL_PASSWORD
    RABBITMQ_MANAGEMENT_SSL_DEPTH
    RABBITMQ_MANAGEMENT_SSL_FAIL_IF_NO_PEER_CERT
    RABBITMQ_MANAGEMENT_SSL_VERIFY
    RABBITMQ_CONFIG_FILE
    RABBITMQ_ERLANG_COOKIE
    RABBITMQ_MANAGER_BIND_IP
    RABBITMQ_MANAGER_PORT_NUMBER
    RABBITMQ_DEFAULT_VHOST
    RABBITMQ_DEFAULT_USER
    RABBITMQ_DEFAULT_PASS
    RABBITMQ_SSL_CACERT_FILE
    RABBITMQ_SSL_CERT_FILE
    RABBITMQ_SSL_KEY_FILE
)
for env_var in "${rabbitmq_env_vars[@]}"; do
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
unset rabbitmq_env_vars

# Paths
export RABBITMQ_VOLUME_DIR="/bitnami/rabbitmq"
export RABBITMQ_BASE_DIR="/opt/bitnami/rabbitmq"
export RABBITMQ_BIN_DIR="${RABBITMQ_BASE_DIR}/sbin"
export RABBITMQ_DATA_DIR="${RABBITMQ_VOLUME_DIR}/mnesia"
export RABBITMQ_CONF_DIR="${RABBITMQ_BASE_DIR}/etc/rabbitmq"
export RABBITMQ_DEFAULT_CONF_DIR="${RABBITMQ_BASE_DIR}/etc/rabbitmq.default"
RABBITMQ_CONF_FILE="${RABBITMQ_CONF_FILE:-"${RABBITMQ_CONFIG_FILE:-}"}"
export RABBITMQ_CONF_FILE="${RABBITMQ_CONF_FILE:-${RABBITMQ_CONF_DIR}/rabbitmq.conf}"
export RABBITMQ_CONF_ENV_FILE="${RABBITMQ_CONF_DIR}/rabbitmq-env.conf"
export RABBITMQ_HOME_DIR="${RABBITMQ_BASE_DIR}/.rabbitmq"
export RABBITMQ_LIB_DIR="${RABBITMQ_BASE_DIR}/var/lib/rabbitmq"
export RABBITMQ_INITSCRIPTS_DIR="/docker-entrypoint-initdb.d"
export RABBITMQ_LOGS_DIR="${RABBITMQ_BASE_DIR}/var/log/rabbitmq"
export RABBITMQ_DEFINITIONS_FILE="${RABBITMQ_DEFINITIONS_FILE:-/app/load_definition.json}"
export RABBITMQ_PLUGINS_DIR="${RABBITMQ_BASE_DIR}/plugins"
export RABBITMQ_MOUNTED_CONF_DIR="${RABBITMQ_VOLUME_DIR}/conf"
export PATH="${RABBITMQ_BIN_DIR}:${BITNAMI_ROOT_DIR}/common/bin:${BITNAMI_ROOT_DIR}/erlang/bin:${PATH}"

# System users (when running with a privileged user)
export RABBITMQ_DAEMON_USER="rabbitmq"
export RABBITMQ_DAEMON_GROUP="rabbitmq"

# RabbitMQ settings
export RABBITMQ_SECURE_PASSWORD="${RABBITMQ_SECURE_PASSWORD:-no}"
export RABBITMQ_UPDATE_PASSWORD="${RABBITMQ_UPDATE_PASSWORD:-no}"
export RABBITMQ_CLUSTER_NODE_NAME="${RABBITMQ_CLUSTER_NODE_NAME:-}"
export RABBITMQ_CLUSTER_PARTITION_HANDLING="${RABBITMQ_CLUSTER_PARTITION_HANDLING:-ignore}"
export RABBITMQ_DISK_FREE_RELATIVE_LIMIT="${RABBITMQ_DISK_FREE_RELATIVE_LIMIT:-1.0}"
export RABBITMQ_DISK_FREE_ABSOLUTE_LIMIT="${RABBITMQ_DISK_FREE_ABSOLUTE_LIMIT:-}"
RABBITMQ_ERL_COOKIE="${RABBITMQ_ERL_COOKIE:-"${RABBITMQ_ERLANG_COOKIE:-}"}"
export RABBITMQ_ERL_COOKIE="${RABBITMQ_ERL_COOKIE:-}"
export RABBITMQ_VM_MEMORY_HIGH_WATERMARK="${RABBITMQ_VM_MEMORY_HIGH_WATERMARK:-}"
export RABBITMQ_LOAD_DEFINITIONS="${RABBITMQ_LOAD_DEFINITIONS:-no}"
RABBITMQ_MANAGEMENT_BIND_IP="${RABBITMQ_MANAGEMENT_BIND_IP:-"${RABBITMQ_MANAGER_BIND_IP:-}"}"
export RABBITMQ_MANAGEMENT_BIND_IP="${RABBITMQ_MANAGEMENT_BIND_IP:-0.0.0.0}"
RABBITMQ_MANAGEMENT_PORT_NUMBER="${RABBITMQ_MANAGEMENT_PORT_NUMBER:-"${RABBITMQ_MANAGER_PORT_NUMBER:-}"}"
export RABBITMQ_MANAGEMENT_PORT_NUMBER="${RABBITMQ_MANAGEMENT_PORT_NUMBER:-15672}"
export RABBITMQ_MANAGEMENT_ALLOW_WEB_ACCESS="${RABBITMQ_MANAGEMENT_ALLOW_WEB_ACCESS:-false}"
export RABBITMQ_NODE_NAME="${RABBITMQ_NODE_NAME:-rabbit@localhost}"
export RABBITMQ_NODE_DEFAULT_QUEUE_TYPE="${RABBITMQ_NODE_DEFAULT_QUEUE_TYPE:-}"
export RABBITMQ_USE_LONGNAME="${RABBITMQ_USE_LONGNAME:-false}"
export RABBITMQ_NODE_PORT_NUMBER="${RABBITMQ_NODE_PORT_NUMBER:-5672}"
export RABBITMQ_NODE_TYPE="${RABBITMQ_NODE_TYPE:-stats}"
RABBITMQ_VHOST="${RABBITMQ_VHOST:-"${RABBITMQ_DEFAULT_VHOST:-}"}"
export RABBITMQ_VHOST="${RABBITMQ_VHOST:-/}"
export RABBITMQ_VHOSTS="${RABBITMQ_VHOSTS:-}"
export RABBITMQ_CLUSTER_REBALANCE="${RABBITMQ_CLUSTER_REBALANCE:-false}"
export RABBITMQ_CLUSTER_REBALANCE_ATTEMPTS="${RABBITMQ_CLUSTER_REBALANCE_ATTEMPTS:-100}"

# RabbitMQ authentication
RABBITMQ_USERNAME="${RABBITMQ_USERNAME:-"${RABBITMQ_DEFAULT_USER:-}"}"
export RABBITMQ_USERNAME="${RABBITMQ_USERNAME:-user}"
RABBITMQ_PASSWORD="${RABBITMQ_PASSWORD:-"${RABBITMQ_DEFAULT_PASS:-}"}"
export RABBITMQ_PASSWORD="${RABBITMQ_PASSWORD:-bitnami}"

# Force boot cluster
export RABBITMQ_FORCE_BOOT="${RABBITMQ_FORCE_BOOT:-no}"

# LDAP
export RABBITMQ_ENABLE_LDAP="${RABBITMQ_ENABLE_LDAP:-no}"
export RABBITMQ_LDAP_TLS="${RABBITMQ_LDAP_TLS:-no}"
export RABBITMQ_LDAP_SERVERS="${RABBITMQ_LDAP_SERVERS:-}"
export RABBITMQ_LDAP_SERVERS_PORT="${RABBITMQ_LDAP_SERVERS_PORT:-389}"
export RABBITMQ_LDAP_USER_DN_PATTERN="${RABBITMQ_LDAP_USER_DN_PATTERN:-}"

# RabbitMQ native environment variables (see https://www.rabbitmq.com/relocate.html)
export RABBITMQ_MNESIA_BASE="$RABBITMQ_DATA_DIR"

# Print all log messages to standard output

# SSL/TLS configuration
export RABBITMQ_NODE_SSL_PORT_NUMBER="${RABBITMQ_NODE_SSL_PORT_NUMBER:-5671}"
RABBITMQ_SSL_CACERTFILE="${RABBITMQ_SSL_CACERTFILE:-"${RABBITMQ_SSL_CACERT_FILE:-}"}"
export RABBITMQ_SSL_CACERTFILE="${RABBITMQ_SSL_CACERTFILE:-}"
RABBITMQ_SSL_CERTFILE="${RABBITMQ_SSL_CERTFILE:-"${RABBITMQ_SSL_CERT_FILE:-}"}"
export RABBITMQ_SSL_CERTFILE="${RABBITMQ_SSL_CERTFILE:-}"
RABBITMQ_SSL_KEYFILE="${RABBITMQ_SSL_KEYFILE:-"${RABBITMQ_SSL_KEY_FILE:-}"}"
export RABBITMQ_SSL_KEYFILE="${RABBITMQ_SSL_KEYFILE:-}"
export RABBITMQ_SSL_PASSWORD="${RABBITMQ_SSL_PASSWORD:-}"
export RABBITMQ_COMBINED_CERT_PATH="${RABBITMQ_COMBINED_CERT_PATH:-/tmp/rabbitmq_combined_keys.pem}"
export RABBITMQ_SSL_DEPTH="${RABBITMQ_SSL_DEPTH:-}"
export RABBITMQ_SSL_FAIL_IF_NO_PEER_CERT="${RABBITMQ_SSL_FAIL_IF_NO_PEER_CERT:-no}"
export RABBITMQ_SSL_VERIFY="${RABBITMQ_SSL_VERIFY:-verify_none}"

# Management SSL/TLS configuration
export RABBITMQ_MANAGEMENT_SSL_PORT_NUMBER="${RABBITMQ_MANAGEMENT_SSL_PORT_NUMBER:-15671}"
export RABBITMQ_MANAGEMENT_SSL_CACERTFILE="${RABBITMQ_MANAGEMENT_SSL_CACERTFILE:-$RABBITMQ_SSL_CACERTFILE}"
export RABBITMQ_MANAGEMENT_SSL_CERTFILE="${RABBITMQ_MANAGEMENT_SSL_CERTFILE:-$RABBITMQ_SSL_CERTFILE}"
export RABBITMQ_MANAGEMENT_SSL_KEYFILE="${RABBITMQ_MANAGEMENT_SSL_KEYFILE:-$RABBITMQ_SSL_KEYFILE}"
export RABBITMQ_MANAGEMENT_SSL_PASSWORD="${RABBITMQ_MANAGEMENT_SSL_PASSWORD:-$RABBITMQ_SSL_PASSWORD}"
export RABBITMQ_MANAGEMENT_SSL_DEPTH="${RABBITMQ_MANAGEMENT_SSL_DEPTH:-}"
export RABBITMQ_MANAGEMENT_SSL_FAIL_IF_NO_PEER_CERT="${RABBITMQ_MANAGEMENT_SSL_FAIL_IF_NO_PEER_CERT:-yes}"
export RABBITMQ_MANAGEMENT_SSL_VERIFY="${RABBITMQ_MANAGEMENT_SSL_VERIFY:-verify_peer}"

# Custom environment variables may be defined below
