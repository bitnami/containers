#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for couchdb

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
export MODULE="${MODULE:-couchdb}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
couchdb_env_vars=(
    COUCHDB_NODENAME
    COUCHDB_PORT_NUMBER
    COUCHDB_CLUSTER_PORT_NUMBER
    COUCHDB_BIND_ADDRESS
    COUCHDB_CREATE_DATABASES
    COUCHDB_USER
    COUCHDB_PASSWORD
    COUCHDB_SECRET
)
for env_var in "${couchdb_env_vars[@]}"; do
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
unset couchdb_env_vars

# Paths
export COUCHDB_BASE_DIR="${BITNAMI_ROOT_DIR}/couchdb"
export COUCHDB_VOLUME_DIR="/bitnami/couchdb"
export COUCHDB_BIN_DIR="${COUCHDB_BASE_DIR}/bin"
export COUCHDB_CONF_DIR="${COUCHDB_BASE_DIR}/etc"
export COUCHDB_CONF_FILE="${COUCHDB_CONF_DIR}/default.d/10-bitnami.ini"
export COUCHDB_DATA_DIR="${COUCHDB_VOLUME_DIR}/data"

# System users (when running with a privileged user)
export COUCHDB_DAEMON_USER="couchdb"
export COUCHDB_DAEMON_GROUP="couchdb"
export PATH="${COUCHDB_BIN_DIR}:${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# CouchDB settings
export COUCHDB_NODENAME="${COUCHDB_NODENAME:-}"
export COUCHDB_PORT_NUMBER="${COUCHDB_PORT_NUMBER:-}"
export COUCHDB_CLUSTER_PORT_NUMBER="${COUCHDB_CLUSTER_PORT_NUMBER:-}"
export COUCHDB_BIND_ADDRESS="${COUCHDB_BIND_ADDRESS:-}"
export COUCHDB_CREATE_DATABASES="${COUCHDB_CREATE_DATABASES:-yes}"
export COUCHDB_USER="${COUCHDB_USER:-admin}"
export COUCHDB_PASSWORD="${COUCHDB_PASSWORD:-couchdb}"
export COUCHDB_SECRET="${COUCHDB_SECRET:-bitnami}"

# Custom environment variables may be defined below
