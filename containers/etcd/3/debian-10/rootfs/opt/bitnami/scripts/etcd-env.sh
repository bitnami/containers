#!/bin/bash
#
# Environment configuration for etcd

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

# Load logging library
. /opt/bitnami/scripts/liblog.sh

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-etcd}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
etcd_env_vars=(
    ALLOW_NONE_AUTHENTICATION
    ETCD_ROOT_PASSWORD
    ETCDCTL_API
    ETCD_LISTEN_CLIENT_URLS
    ETCD_ADVERTISE_CLIENT_URLS
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
export ETCD_BIN_DIR="${ETCD_BASE_DIR}/sbin"
export ETCD_DATA_DIR="${ETCD_VOLUME_DIR}/data"
export PATH="${ETCD_BIN_DIR}:${PATH}"

# System users (when running with a privileged user)
export ETCD_DAEMON_USER="etcd"
export ETCD_DAEMON_GROUP="etcd"

# etcd settings
export ALLOW_NONE_AUTHENTICATION="${ALLOW_NONE_AUTHENTICATION:-no}"
export ETCD_ROOT_PASSWORD="${ETCD_ROOT_PASSWORD:-}"

# etcd native environment variables (see https://etcd.io/docs/current/op-guide/configuration)
export ETCDCTL_API="${ETCDCTL_API:-3}"
export ETCD_LISTEN_CLIENT_URLS="${ETCD_LISTEN_CLIENT_URLS:-http://0.0.0.0:2379}"
export ETCD_ADVERTISE_CLIENT_URLS="${ETCD_ADVERTISE_CLIENT_URLS:-http://127.0.0.1:2379}"

# Custom environment variables may be defined below
