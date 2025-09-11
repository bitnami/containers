#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for logstash

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
export MODULE="${MODULE:-logstash}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
logstash_env_vars=(
    LOGSTASH_PIPELINE_CONF_FILENAME
    LOGSTASH_BIND_ADDRESS
    LOGSTASH_EXPOSE_API
    LOGSTASH_API_PORT_NUMBER
    LOGSTASH_PIPELINE_CONF_STRING
    LOGSTASH_PLUGINS
    LOGSTASH_EXTRA_FLAGS
    LOGSTASH_HEAP_SIZE
    LOGSTASH_MAX_ALLOWED_MEMORY_PERCENTAGE
    LOGSTASH_MAX_ALLOWED_MEMORY
    LOGSTASH_ENABLE_MULTIPLE_PIPELINES
    LOGSTASH_ENABLE_BEATS_INPUT
    LOGSTASH_BEATS_PORT_NUMBER
    LOGSTASH_ENABLE_GELF_INPUT
    LOGSTASH_GELF_PORT_NUMBER
    LOGSTASH_ENABLE_HTTP_INPUT
    LOGSTASH_HTTP_PORT_NUMBER
    LOGSTASH_ENABLE_TCP_INPUT
    LOGSTASH_TCP_PORT_NUMBER
    LOGSTASH_ENABLE_UDP_INPUT
    LOGSTASH_UDP_PORT_NUMBER
    LOGSTASH_ENABLE_STDOUT_OUTPUT
    LOGSTASH_ENABLE_ELASTICSEARCH_OUTPUT
    LOGSTASH_ELASTICSEARCH_HOST
    LOGSTASH_ELASTICSEARCH_PORT_NUMBER
    LOGSTASH_CONF_FILENAME
    LOGSTASH_CONF_STRING
    LOGSTASH_EXTRA_ARGS
)
for env_var in "${logstash_env_vars[@]}"; do
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
unset logstash_env_vars

# Paths
export LOGSTASH_BASE_DIR="/opt/bitnami/logstash"
export LOGSTASH_CONF_DIR="${LOGSTASH_BASE_DIR}/config"
export LOGSTASH_DEFAULT_CONF_DIR="${LOGSTASH_BASE_DIR}/config.default"
export LOGSTASH_PIPELINE_CONF_DIR="${LOGSTASH_BASE_DIR}/pipeline"
export LOGSTASH_DEFAULT_PIPELINE_CONF_DIR="${LOGSTASH_BASE_DIR}/pipeline.default"
export LOGSTASH_BIN_DIR="${LOGSTASH_BASE_DIR}/bin"
export LOGSTASH_CONF_FILE="${LOGSTASH_CONF_DIR}/logstash.yml"
LOGSTASH_PIPELINE_CONF_FILENAME="${LOGSTASH_PIPELINE_CONF_FILENAME:-"${LOGSTASH_CONF_FILENAME:-}"}"
export LOGSTASH_PIPELINE_CONF_FILENAME="${LOGSTASH_PIPELINE_CONF_FILENAME:-logstash.conf}"
export LOGSTASH_PIPELINE_CONF_FILE="${LOGSTASH_PIPELINE_CONF_DIR}/${LOGSTASH_PIPELINE_CONF_FILENAME}"
export LOGSTASH_VOLUME_DIR="/bitnami/logstash"
export LOGSTASH_DATA_DIR="${LOGSTASH_VOLUME_DIR}/data"
export LOGSTASH_MOUNTED_CONF_DIR="${LOGSTASH_VOLUME_DIR}/config"
export LOGSTASH_MOUNTED_PIPELINE_CONF_DIR="${LOGSTASH_VOLUME_DIR}/pipeline"

# System users (when running with a privileged user)
export LOGSTASH_DAEMON_USER="logstash"
export LOGSTASH_DAEMON_GROUP="logstash"

# Logstash configuration
export LOGSTASH_BIND_ADDRESS="${LOGSTASH_BIND_ADDRESS:-0.0.0.0}"
export LOGSTASH_EXPOSE_API="${LOGSTASH_EXPOSE_API:-no}"
export LOGSTASH_API_PORT_NUMBER="${LOGSTASH_API_PORT_NUMBER:-9600}"
LOGSTASH_PIPELINE_CONF_STRING="${LOGSTASH_PIPELINE_CONF_STRING:-"${LOGSTASH_CONF_STRING:-}"}"
export LOGSTASH_PIPELINE_CONF_STRING="${LOGSTASH_PIPELINE_CONF_STRING:-}"
export LOGSTASH_PLUGINS="${LOGSTASH_PLUGINS:-}"
LOGSTASH_EXTRA_FLAGS="${LOGSTASH_EXTRA_FLAGS:-"${LOGSTASH_EXTRA_ARGS:-}"}"
export LOGSTASH_EXTRA_FLAGS="${LOGSTASH_EXTRA_FLAGS:-}"
export LOGSTASH_HEAP_SIZE="${LOGSTASH_HEAP_SIZE:-1024m}"
export LOGSTASH_MAX_ALLOWED_MEMORY_PERCENTAGE="${LOGSTASH_MAX_ALLOWED_MEMORY_PERCENTAGE:-100}"
export LOGSTASH_MAX_ALLOWED_MEMORY="${LOGSTASH_MAX_ALLOWED_MEMORY:-}"

# Logstash pipeline configuration
export LOGSTASH_ENABLE_MULTIPLE_PIPELINES="${LOGSTASH_ENABLE_MULTIPLE_PIPELINES:-no}"
export LOGSTASH_ENABLE_BEATS_INPUT="${LOGSTASH_ENABLE_BEATS_INPUT:-no}"
export LOGSTASH_BEATS_PORT_NUMBER="${LOGSTASH_BEATS_PORT_NUMBER:-5044}"
export LOGSTASH_ENABLE_GELF_INPUT="${LOGSTASH_ENABLE_GELF_INPUT:-no}"
export LOGSTASH_GELF_PORT_NUMBER="${LOGSTASH_GELF_PORT_NUMBER:-12201}"
export LOGSTASH_ENABLE_HTTP_INPUT="${LOGSTASH_ENABLE_HTTP_INPUT:-yes}"
export LOGSTASH_HTTP_PORT_NUMBER="${LOGSTASH_HTTP_PORT_NUMBER:-8080}"
export LOGSTASH_ENABLE_TCP_INPUT="${LOGSTASH_ENABLE_TCP_INPUT:-no}"
export LOGSTASH_TCP_PORT_NUMBER="${LOGSTASH_TCP_PORT_NUMBER:-5010}"
export LOGSTASH_ENABLE_UDP_INPUT="${LOGSTASH_ENABLE_UDP_INPUT:-no}"
export LOGSTASH_UDP_PORT_NUMBER="${LOGSTASH_UDP_PORT_NUMBER:-5000}"
export LOGSTASH_ENABLE_STDOUT_OUTPUT="${LOGSTASH_ENABLE_STDOUT_OUTPUT:-yes}"
export LOGSTASH_ENABLE_ELASTICSEARCH_OUTPUT="${LOGSTASH_ENABLE_ELASTICSEARCH_OUTPUT:-no}"
export LOGSTASH_ELASTICSEARCH_HOST="${LOGSTASH_ELASTICSEARCH_HOST:-elasticsearch}"
export LOGSTASH_ELASTICSEARCH_PORT_NUMBER="${LOGSTASH_ELASTICSEARCH_PORT_NUMBER:-9200}"

# Default JVM configuration
export JAVA_HOME="${BITNAMI_ROOT_DIR}/java"

# Other parameters
export PATH="${LOGSTASH_BIN_DIR}:${JAVA_HOME}/bin:${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# Custom environment variables may be defined below
