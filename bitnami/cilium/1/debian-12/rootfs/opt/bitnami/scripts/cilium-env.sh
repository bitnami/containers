#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for cilium

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
export MODULE="${MODULE:-cilium}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
cilium_env_vars=(
    HOST_CNI_BIN_DIR
    HOST_CNI_CONF_DIR
    HUBBLE_SERVER
)
for env_var in "${cilium_env_vars[@]}"; do
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
unset cilium_env_vars

# Paths
export CILIUM_BASE_DIR="${BITNAMI_ROOT_DIR}/cilium"
export CILIUM_BIN_DIR="${CILIUM_BASE_DIR}/bin"
export CILIUM_LIB_DIR="${CILIUM_BASE_DIR}/var/lib"
export CILIUM_RUN_DIR="${CILIUM_BASE_DIR}/var/run"
export CILIUM_CNI_BIN_DIR="${CILIUM_BASE_DIR}/cni/bin"

# System users (when running with a privileged user)
export CILIUM_DAEMON_USER="cilium"
export CILIUM_DAEMON_GROUP="cilium"

# Cilium settings
export HOST_CNI_BIN_DIR="${HOST_CNI_BIN_DIR:-/opt/cni/bin}"
export HOST_CNI_CONF_DIR="${HOST_CNI_CONF_DIR:-/etc/cni/net.d}"
export HUBBLE_SERVER="${HUBBLE_SERVER:-unix:///var/run/cilium/hubble.sock}"

# Custom environment variables may be defined below
