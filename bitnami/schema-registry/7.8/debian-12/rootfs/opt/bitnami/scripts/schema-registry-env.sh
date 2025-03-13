#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for schema-registry

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
export MODULE="${MODULE:-schema-registry}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
schema_registry_env_vars=(
    SCHEMA_REGISTRY_MOUNTED_CONF_DIR
    SCHEMA_REGISTRY_KAFKA_BROKERS
    SCHEMA_REGISTRY_ADVERTISED_HOSTNAME
    SCHEMA_REGISTRY_KAFKA_KEYSTORE_PASSWORD
    SCHEMA_REGISTRY_KAFKA_KEY_PASSWORD
    SCHEMA_REGISTRY_KAFKA_TRUSTSTORE_PASSWORD
    SCHEMA_REGISTRY_KAFKA_SASL_USER
    SCHEMA_REGISTRY_KAFKA_SASL_PASSWORD
    SCHEMA_REGISTRY_LISTENERS
    SCHEMA_REGISTRY_SSL_KEYSTORE_PASSWORD
    SCHEMA_REGISTRY_SSL_KEY_PASSWORD
    SCHEMA_REGISTRY_SSL_TRUSTSTORE_PASSWORD
    SCHEMA_REGISTRY_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM
    SCHEMA_REGISTRY_CLIENT_AUTHENTICATION
    SCHEMA_REGISTRY_AVRO_COMPATIBILY_LEVEL
    SCHEMA_REGISTRY_DEBUG
    SCHEMA_REGISTRY_CONNECTION_ATTEMPT_TIMEOUT
)
for env_var in "${schema_registry_env_vars[@]}"; do
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
unset schema_registry_env_vars

# Paths
export SCHEMA_REGISTRY_BASE_DIR="${BITNAMI_ROOT_DIR}/schema-registry"
export SCHEMA_REGISTRY_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/schema-registry"
export SCHEMA_REGISTRY_BIN_DIR="${SCHEMA_REGISTRY_BASE_DIR}/bin"
export SCHEMA_REGISTRY_CERTS_DIR="${SCHEMA_REGISTRY_BASE_DIR}/certs"
export SCHEMA_REGISTRY_CONF_DIR="${SCHEMA_REGISTRY_BASE_DIR}/etc"
export SCHEMA_REGISTRY_DEFAULT_CONF_DIR="${SCHEMA_REGISTRY_BASE_DIR}/etc.default"
export SCHEMA_REGISTRY_LOGS_DIR="${SCHEMA_REGISTRY_BASE_DIR}/logs"
export SCHEMA_REGISTRY_CONF_FILE="${SCHEMA_REGISTRY_CONF_DIR}/schema-registry/schema-registry.properties"
export SCHEMA_REGISTRY_MOUNTED_CONF_DIR="${SCHEMA_REGISTRY_MOUNTED_CONF_DIR:-${SCHEMA_REGISTRY_VOLUME_DIR}/etc}"

# System users (when running with a privileged user)
export SCHEMA_REGISTRY_DAEMON_USER="schema-registry"
export SCHEMA_REGISTRY_DAEMON_GROUP="schema-registry"
export SCHEMA_REGISTRY_DEFAULT_LISTENERS="http://0.0.0.0:8081" # only used at build time
export SCHEMA_REGISTRY_DEFAULT_KAFKA_BROKERS="PLAINTEXT://localhost:9092" # only used at build time

# Schema Registry settings
export SCHEMA_REGISTRY_KAFKA_BROKERS="${SCHEMA_REGISTRY_KAFKA_BROKERS:-}"
export SCHEMA_REGISTRY_ADVERTISED_HOSTNAME="${SCHEMA_REGISTRY_ADVERTISED_HOSTNAME:-}"
export SCHEMA_REGISTRY_KAFKA_KEYSTORE_PASSWORD="${SCHEMA_REGISTRY_KAFKA_KEYSTORE_PASSWORD:-}"
export SCHEMA_REGISTRY_KAFKA_KEY_PASSWORD="${SCHEMA_REGISTRY_KAFKA_KEY_PASSWORD:-}"
export SCHEMA_REGISTRY_KAFKA_TRUSTSTORE_PASSWORD="${SCHEMA_REGISTRY_KAFKA_TRUSTSTORE_PASSWORD:-}"
export SCHEMA_REGISTRY_KAFKA_SASL_USER="${SCHEMA_REGISTRY_KAFKA_SASL_USER:-}"
export SCHEMA_REGISTRY_KAFKA_SASL_PASSWORD="${SCHEMA_REGISTRY_KAFKA_SASL_PASSWORD:-}"
export SCHEMA_REGISTRY_LISTENERS="${SCHEMA_REGISTRY_LISTENERS:-}"
export SCHEMA_REGISTRY_SSL_KEYSTORE_PASSWORD="${SCHEMA_REGISTRY_SSL_KEYSTORE_PASSWORD:-}"
export SCHEMA_REGISTRY_SSL_KEY_PASSWORD="${SCHEMA_REGISTRY_SSL_KEY_PASSWORD:-}"
export SCHEMA_REGISTRY_SSL_TRUSTSTORE_PASSWORD="${SCHEMA_REGISTRY_SSL_TRUSTSTORE_PASSWORD:-}"
export SCHEMA_REGISTRY_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM="${SCHEMA_REGISTRY_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM:-}"
export SCHEMA_REGISTRY_CLIENT_AUTHENTICATION="${SCHEMA_REGISTRY_CLIENT_AUTHENTICATION:-}"
export SCHEMA_REGISTRY_AVRO_COMPATIBILY_LEVEL="${SCHEMA_REGISTRY_AVRO_COMPATIBILY_LEVEL:-}"
export SCHEMA_REGISTRY_DEBUG="${SCHEMA_REGISTRY_DEBUG:-}"
export SCHEMA_REGISTRY_CONNECTION_ATTEMPT_TIMEOUT="${SCHEMA_REGISTRY_CONNECTION_ATTEMPT_TIMEOUT:10}"

# Custom environment variables may be defined below
