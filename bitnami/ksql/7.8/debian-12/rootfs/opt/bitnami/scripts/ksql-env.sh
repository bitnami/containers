#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for ksql

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
export MODULE="${MODULE:-ksql}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
ksql_env_vars=(
    KSQL_MOUNTED_CONF_DIR
    KSQL_LISTENERS
    KSQL_SSL_KEYSTORE_PASSWORD
    KSQL_SSL_TRUSTSTORE_PASSWORD
    KSQL_CLIENT_AUTHENTICATION
    KSQL_BOOTSTRAP_SERVERS
    KSQL_CONNECTION_ATTEMPT_TIMEOUT
)
for env_var in "${ksql_env_vars[@]}"; do
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
unset ksql_env_vars

# Paths
export KSQL_BASE_DIR="${BITNAMI_ROOT_DIR}/ksql"
export KSQL_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/ksql"
export KSQL_DATA_DIR="${KSQL_VOLUME_DIR}/data"
export KSQL_BIN_DIR="${KSQL_BASE_DIR}/bin"
export KSQL_CONF_DIR="${KSQL_BASE_DIR}/etc/ksqldb"
export KSQL_LOGS_DIR="${KSQL_BASE_DIR}/logs"
export KSQL_CONF_FILE="${KSQL_CONF_DIR}/ksql-server.properties"
export KSQL_MOUNTED_CONF_DIR="${KSQL_MOUNTED_CONF_DIR:-${KSQL_VOLUME_DIR}/etc}"
export KSQL_CERTS_DIR="${KSQL_BASE_DIR}/certs"

# System users (when running with a privileged user)
export KSQL_DAEMON_USER="ksql"
export KSQL_DAEMON_GROUP="ksql"
export KSQL_DEFAULT_LISTENERS="http://0.0.0.0:8088" # only used at build time
export KSQL_DEFAULT_BOOTSTRAP_SERVERS="localhost:9092" # only used at build time

# KSQL settings
export KSQL_LISTENERS="${KSQL_LISTENERS:-}"
export KSQL_SSL_KEYSTORE_PASSWORD="${KSQL_SSL_KEYSTORE_PASSWORD:-}"
export KSQL_SSL_TRUSTSTORE_PASSWORD="${KSQL_SSL_TRUSTSTORE_PASSWORD:-}"
export KSQL_CLIENT_AUTHENTICATION="${KSQL_CLIENT_AUTHENTICATION:-}"
export KSQL_BOOTSTRAP_SERVERS="${KSQL_BOOTSTRAP_SERVERS:-}"
export KSQL_CONNECTION_ATTEMPT_TIMEOUT="${KSQL_CONNECTION_ATTEMPT_TIMEOUT:10}"

# Custom environment variables may be defined below
