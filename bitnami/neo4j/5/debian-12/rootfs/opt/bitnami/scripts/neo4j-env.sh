#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for neo4j

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
export MODULE="${MODULE:-neo4j}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
neo4j_env_vars=(
    NEO4J_HOST
    NEO4J_BIND_ADDRESS
    NEO4J_ALLOW_UPGRADE
    NEO4J_PASSWORD
    NEO4J_APOC_IMPORT_FILE_ENABLED
    NEO4J_APOC_IMPORT_FILE_USE_NEO4J_CONFIG
    NEO4J_BOLT_PORT_NUMBER
    NEO4J_HTTP_PORT_NUMBER
    NEO4J_HTTPS_PORT_NUMBER
    NEO4J_BOLT_ADVERTISED_PORT_NUMBER
    NEO4J_HTTP_ADVERTISED_PORT_NUMBER
    NEO4J_HTTPS_ADVERTISED_PORT_NUMBER
    NEO4J_HTTPS_ENABLED
    NEO4J_BOLT_TLS_LEVEL
)
for env_var in "${neo4j_env_vars[@]}"; do
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
unset neo4j_env_vars

# Paths
export NEO4J_BASE_DIR="${BITNAMI_ROOT_DIR}/neo4j"
export NEO4J_VOLUME_DIR="/bitnami/neo4j"
export NEO4J_DATA_DIR="$NEO4J_VOLUME_DIR/data"
export NEO4J_RUN_DIR="${NEO4J_BASE_DIR}/run"
export NEO4J_LOGS_DIR="${NEO4J_BASE_DIR}/logs"
export NEO4J_LOG_FILE="${NEO4J_LOGS_DIR}/neo4j.log"
export NEO4J_PID_FILE="${NEO4J_RUN_DIR}/neo4j.pid"
export NEO4J_CONF_DIR="${NEO4J_BASE_DIR}/conf"
export NEO4J_DEFAULT_CONF_DIR="${NEO4J_BASE_DIR}/conf.default"
export NEO4J_PLUGINS_DIR="${NEO4J_BASE_DIR}/plugins"
export NEO4J_METRICS_DIR="${NEO4J_VOLUME_DIR}/metrics"
export NEO4J_CERTIFICATES_DIR="${NEO4J_VOLUME_DIR}/certificates"
export NEO4J_IMPORT_DIR="${NEO4J_VOLUME_DIR}/import"
export NEO4J_MOUNTED_CONF_DIR="${NEO4J_VOLUME_DIR}/conf/"
export NEO4J_MOUNTED_PLUGINS_DIR="${NEO4J_VOLUME_DIR}/plugins/"
export NEO4J_INITSCRIPTS_DIR="/docker-entrypoint-initdb.d"
export NEO4J_CONF_FILE="${NEO4J_CONF_DIR}/neo4j.conf"
export NEO4J_APOC_CONF_FILE="${NEO4J_CONF_DIR}/apoc.conf"

# Neo4j persistence configuration
export NEO4J_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/neo4j"
export NEO4J_DATA_TO_PERSIST="data"

# System users (when running with a privileged user)
export NEO4J_DAEMON_USER="neo4j"
export NEO4J_DAEMON_GROUP="neo4j"

# Neo4j configuration
export NEO4J_HOST="${NEO4J_HOST:-}"
export NEO4J_BIND_ADDRESS="${NEO4J_BIND_ADDRESS:-0.0.0.0}"
export NEO4J_ALLOW_UPGRADE="${NEO4J_ALLOW_UPGRADE:-true}"
export NEO4J_PASSWORD="${NEO4J_PASSWORD:-bitnami1}"
export NEO4J_APOC_IMPORT_FILE_ENABLED="${NEO4J_APOC_IMPORT_FILE_ENABLED:-true}"
export NEO4J_APOC_IMPORT_FILE_USE_NEO4J_CONFIG="${NEO4J_APOC_IMPORT_FILE_USE_NEO4J_CONFIG:-false}"
export NEO4J_BOLT_PORT_NUMBER="${NEO4J_BOLT_PORT_NUMBER:-7687}"
export NEO4J_HTTP_PORT_NUMBER="${NEO4J_HTTP_PORT_NUMBER:-7474}"
export NEO4J_HTTPS_PORT_NUMBER="${NEO4J_HTTPS_PORT_NUMBER:-7473}"
export NEO4J_BOLT_ADVERTISED_PORT_NUMBER="${NEO4J_BOLT_ADVERTISED_PORT_NUMBER:-$NEO4J_BOLT_PORT_NUMBER}"
export NEO4J_HTTP_ADVERTISED_PORT_NUMBER="${NEO4J_HTTP_ADVERTISED_PORT_NUMBER:-$NEO4J_HTTP_PORT_NUMBER}"
export NEO4J_HTTPS_ADVERTISED_PORT_NUMBER="${NEO4J_HTTPS_ADVERTISED_PORT_NUMBER:-$NEO4J_HTTPS_PORT_NUMBER}"
export NEO4J_HTTPS_ENABLED="${NEO4J_HTTPS_ENABLED:-false}"
export NEO4J_BOLT_TLS_LEVEL="${NEO4J_BOLT_TLS_LEVEL:-DISABLED}"

# Default JVM configuration
export JAVA_HOME="${BITNAMI_ROOT_DIR}/java"

# Other parameters
export PATH="${NEO4J_BASE_DIR}/bin:${JAVA_HOME}/bin:${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# Custom environment variables may be defined below
