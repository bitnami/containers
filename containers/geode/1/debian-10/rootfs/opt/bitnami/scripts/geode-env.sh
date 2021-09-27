#!/bin/bash
#
# Environment configuration for geode

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
export MODULE="${MODULE:-geode}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
geode_env_vars=(
    GEODE_HTTP_BIND_ADDRESS
    GEODE_HTTP_PORT_NUMBER
    GEODE_RMI_BIND_ADDRESS
    GEODE_RMI_PORT_NUMBER
    GEODE_ADVERTISED_HOSTNAME
    GEODE_NODE_NAME
    GEODE_NODE_TYPE
    GEODE_LOCATORS
    GEODE_GROUPS
    GEODE_LOG_LEVEL
    GEODE_INITIAL_HEAP_SIZE
    GEODE_MAX_HEAP_SIZE
    GEODE_ENABLE_SECURITY
    GEODE_SECURITY_MANAGER
    GEODE_SECURITY_USERNAME
    GEODE_SECURITY_PASSWORD
    GEODE_SECURITY_TLS_COMPONENTS
    GEODE_SECURITY_TLS_PROTOCOLS
    GEODE_SECURITY_TLS_REQUIRE_AUTHENTICATION
    GEODE_SECURITY_TLS_ENDPOINT_IDENTIFICATION_ENABLED
    GEODE_SECURITY_TLS_KEYSTORE_FILE
    GEODE_SECURITY_TLS_KEYSTORE_PASSWORD
    GEODE_SECURITY_TLS_TRUSTSTORE_FILE
    GEODE_SECURITY_TLS_TRUSTSTORE_PASSWORD
    GEODE_SERVER_BIND_ADDRESS
    GEODE_SERVER_PORT_NUMBER
    GEODE_LOCATOR_BIND_ADDRESS
    GEODE_LOCATOR_PORT_NUMBER
    GEODE_LOCATOR_START_COMMAND
    JAVA_HOME
    JAVA_OPTS
)
for env_var in "${geode_env_vars[@]}"; do
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
unset geode_env_vars

# Paths
export GEODE_BASE_DIR="${BITNAMI_ROOT_DIR}/geode"
export GEODE_BIN_DIR="${GEODE_BASE_DIR}/bin"
export GEODE_CONF_DIR="${GEODE_BASE_DIR}/config"
export GEODE_CERTS_DIR="${GEODE_CONF_DIR}/certs"
export GEODE_CONF_FILE="${GEODE_CONF_DIR}/gemfire.properties"
export GEODE_SEC_CONF_FILE="${GEODE_CONF_DIR}/gfsecurity.properties"
export GEODE_LOGS_DIR="${GEODE_BASE_DIR}/logs"
export GEODE_EXTENSIONS_DIR="${GEODE_BASE_DIR}/extensions"
export GEODE_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/geode"
export GEODE_DATA_DIR="${GEODE_VOLUME_DIR}/data"
export GEODE_MOUNTED_CONF_DIR="${GEODE_VOLUME_DIR}/config"
export GEODE_INITSCRIPTS_DIR="/docker-entrypoint-initdb.d"

# System users (when running with a privileged user)
export GEODE_DAEMON_USER="geode"
export GEODE_DAEMON_GROUP="geode"

# Apache Geode configuration
export GEODE_HTTP_BIND_ADDRESS="${GEODE_HTTP_BIND_ADDRESS:-}"
export GEODE_HTTP_PORT_NUMBER="${GEODE_HTTP_PORT_NUMBER:-7070}"
export GEODE_RMI_BIND_ADDRESS="${GEODE_RMI_BIND_ADDRESS:-}"
export GEODE_RMI_PORT_NUMBER="${GEODE_RMI_PORT_NUMBER:-1099}"
export GEODE_ADVERTISED_HOSTNAME="${GEODE_ADVERTISED_HOSTNAME:-}"
export GEODE_NODE_NAME="${GEODE_NODE_NAME:-}"
export GEODE_NODE_TYPE="${GEODE_NODE_TYPE:-server}"
export GEODE_LOCATORS="${GEODE_LOCATORS:-}"
export GEODE_GROUPS="${GEODE_GROUPS:-}"
export GEODE_LOG_LEVEL="${GEODE_LOG_LEVEL:-info}"
export GEODE_INITIAL_HEAP_SIZE="${GEODE_INITIAL_HEAP_SIZE:-}"
export GEODE_MAX_HEAP_SIZE="${GEODE_MAX_HEAP_SIZE:-}"

# Apache Geode security
export GEODE_ENABLE_SECURITY="${GEODE_ENABLE_SECURITY:-no}"
export GEODE_SECURITY_MANAGER="${GEODE_SECURITY_MANAGER:-org.apache.geode.examples.security.ExampleSecurityManager}"
export GEODE_SECURITY_USERNAME="${GEODE_SECURITY_USERNAME:-admin}"
export GEODE_SECURITY_PASSWORD="${GEODE_SECURITY_PASSWORD:-}"
export GEODE_SECURITY_TLS_COMPONENTS="${GEODE_SECURITY_TLS_COMPONENTS:-}"
export GEODE_SECURITY_TLS_PROTOCOLS="${GEODE_SECURITY_TLS_PROTOCOLS:-any}"
export GEODE_SECURITY_TLS_REQUIRE_AUTHENTICATION="${GEODE_SECURITY_TLS_REQUIRE_AUTHENTICATION:-no}"
export GEODE_SECURITY_TLS_ENDPOINT_IDENTIFICATION_ENABLED="${GEODE_SECURITY_TLS_ENDPOINT_IDENTIFICATION_ENABLED:-no}"
export GEODE_SECURITY_TLS_KEYSTORE_FILE="${GEODE_SECURITY_TLS_KEYSTORE_FILE:-${GEODE_MOUNTED_CONF_DIR}/certs/geode.keystore.jks}"
export GEODE_SECURITY_TLS_KEYSTORE_PASSWORD="${GEODE_SECURITY_TLS_KEYSTORE_PASSWORD:-}"
export GEODE_SECURITY_TLS_TRUSTSTORE_FILE="${GEODE_SECURITY_TLS_TRUSTSTORE_FILE:-${GEODE_MOUNTED_CONF_DIR}/certs/geode.truststore.jks}"
export GEODE_SECURITY_TLS_TRUSTSTORE_PASSWORD="${GEODE_SECURITY_TLS_TRUSTSTORE_PASSWORD:-}"

# Apache Geode Cache servers configuration
export GEODE_SERVER_BIND_ADDRESS="${GEODE_SERVER_BIND_ADDRESS:-}"
export GEODE_SERVER_PORT_NUMBER="${GEODE_SERVER_PORT_NUMBER:-40404}"

# Apache Geode locators configuration
export GEODE_LOCATOR_BIND_ADDRESS="${GEODE_LOCATOR_BIND_ADDRESS:-}"
export GEODE_LOCATOR_PORT_NUMBER="${GEODE_LOCATOR_PORT_NUMBER:-10334}"
export GEODE_LOCATOR_START_COMMAND="${GEODE_LOCATOR_START_COMMAND:-configure pdx --read-serialized --disk-store}"

# Java configuration
export JAVA_HOME="${JAVA_HOME:-${BITNAMI_ROOT_DIR}/java}"
export JAVA_OPTS="${JAVA_OPTS:-}"

# Custom environment variables may be defined below
