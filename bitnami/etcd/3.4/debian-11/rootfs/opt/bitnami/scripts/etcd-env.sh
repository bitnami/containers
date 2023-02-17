#!/bin/bash
#
# Environment configuration for etcd

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
export MODULE="${MODULE:-etcd}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
etcd_env_vars=(
    ETCD_SNAPSHOTS_DIR
    ETCD_SNAPSHOT_HISTORY_LIMIT
    ETCD_INIT_SNAPSHOTS_DIR
    ALLOW_NONE_AUTHENTICATION
    ETCD_ROOT_PASSWORD
    ETCD_CLUSTER_DOMAIN
    ETCD_START_FROM_SNAPSHOT
    ETCD_DISASTER_RECOVERY
    ETCD_ON_K8S
    ETCD_INIT_SNAPSHOT_FILENAME
    ETCDCTL_API
    ETCD_DISABLE_STORE_MEMBER_ID
    ETCD_DISABLE_PRESTOP
    ETCD_NAME
    ETCD_LOG_LEVEL
    ETCD_LISTEN_CLIENT_URLS
    ETCD_ADVERTISE_CLIENT_URLS
    ETCD_INITIAL_CLUSTER
    ETCD_INITIAL_CLUSTER_STATE
    ETCD_LISTEN_PEER_URLS
    ETCD_INITIAL_ADVERTISE_PEER_URLS
    ETCD_INITIAL_CLUSTER_TOKEN
    ETCD_AUTO_TLS
    ETCD_CERT_FILE
    ETCD_KEY_FILE
    ETCD_TRUSTED_CA_FILE
    ETCD_CLIENT_CERT_AUTH
    ETCD_PEER_AUTO_TLS
)
for env_var in "${etcd_env_vars[@]}"; do
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
unset etcd_env_vars

# Paths
export ETCD_BASE_DIR="/opt/bitnami/etcd"
export ETCD_VOLUME_DIR="/bitnami/etcd"
export ETCD_BIN_DIR="${ETCD_BASE_DIR}/bin"
export ETCD_DATA_DIR="${ETCD_VOLUME_DIR}/data"
export ETCD_CONF_DIR="${ETCD_BASE_DIR}/conf"
export ETCD_TMP_DIR="${ETCD_BASE_DIR}/tmp"
export ETCD_CONF_FILE="${ETCD_CONF_DIR}/etcd.yaml"
export ETCD_SNAPSHOTS_DIR="${ETCD_SNAPSHOTS_DIR:-/snapshots}"
export ETCD_SNAPSHOT_HISTORY_LIMIT="${ETCD_SNAPSHOT_HISTORY_LIMIT:-1}"
export ETCD_INIT_SNAPSHOTS_DIR="${ETCD_INIT_SNAPSHOTS_DIR:-/init-snapshot}"
export ETCD_NEW_MEMBERS_ENV_FILE="${ETCD_DATA_DIR}/new_member_envs"
export PATH="${ETCD_BIN_DIR}:${PATH}"

# System users (when running with a privileged user)
export ETCD_DAEMON_USER="etcd"
export ETCD_DAEMON_GROUP="etcd"

# etcd settings
export ALLOW_NONE_AUTHENTICATION="${ALLOW_NONE_AUTHENTICATION:-no}"
export ETCD_ROOT_PASSWORD="${ETCD_ROOT_PASSWORD:-}"
export ETCD_CLUSTER_DOMAIN="${ETCD_CLUSTER_DOMAIN:-}"
export ETCD_START_FROM_SNAPSHOT="${ETCD_START_FROM_SNAPSHOT:-no}"
export ETCD_DISASTER_RECOVERY="${ETCD_DISASTER_RECOVERY:-no}"
export ETCD_ON_K8S="${ETCD_ON_K8S:-no}"
export ETCD_INIT_SNAPSHOT_FILENAME="${ETCD_INIT_SNAPSHOT_FILENAME:-}"
export ETCDCTL_API="${ETCDCTL_API:-3}"
export ETCD_DISABLE_STORE_MEMBER_ID="${ETCD_DISABLE_STORE_MEMBER_ID:-no}"
export ETCD_DISABLE_PRESTOP="${ETCD_DISABLE_PRESTOP:-no}"

# etcd native environment variables (see https://etcd.io/docs/current/op-guide/configuration)
export ETCD_NAME="${ETCD_NAME:-}"
export ETCD_LOG_LEVEL="${ETCD_LOG_LEVEL:-info}"
export ETCD_LISTEN_CLIENT_URLS="${ETCD_LISTEN_CLIENT_URLS:-http://0.0.0.0:2379}"
export ETCD_ADVERTISE_CLIENT_URLS="${ETCD_ADVERTISE_CLIENT_URLS:-http://127.0.0.1:2379}"
export ETCD_INITIAL_CLUSTER="${ETCD_INITIAL_CLUSTER:-}"
export ETCD_INITIAL_CLUSTER_STATE="${ETCD_INITIAL_CLUSTER_STATE:-}"
export ETCD_LISTEN_PEER_URLS="${ETCD_LISTEN_PEER_URLS:-}"
export ETCD_INITIAL_ADVERTISE_PEER_URLS="${ETCD_INITIAL_ADVERTISE_PEER_URLS:-}"
export ETCD_INITIAL_CLUSTER_TOKEN="${ETCD_INITIAL_CLUSTER_TOKEN:-}"
export ETCD_AUTO_TLS="${ETCD_AUTO_TLS:-false}"
export ETCD_CERT_FILE="${ETCD_CERT_FILE:-}"
export ETCD_KEY_FILE="${ETCD_KEY_FILE:-}"
export ETCD_TRUSTED_CA_FILE="${ETCD_TRUSTED_CA_FILE:-}"
export ETCD_CLIENT_CERT_AUTH="${ETCD_CLIENT_CERT_AUTH:-false}"
export ETCD_PEER_AUTO_TLS="${ETCD_PEER_AUTO_TLS:-false}"

# Custom environment variables may be defined below
