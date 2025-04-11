#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for wildfly

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
export MODULE="${MODULE:-wildfly}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
wildfly_env_vars=(
    WILDFLY_CONF_FILE
    WILDFLY_MOUNTED_CONF_DIR
    WILDFLY_DATA_DIR
    WILDFLY_SERVER_LISTEN_ADDRESS
    WILDFLY_MANAGEMENT_LISTEN_ADDRESS
    WILDFLY_HTTP_PORT_NUMBER
    WILDFLY_HTTPS_PORT_NUMBER
    WILDFLY_AJP_PORT_NUMBER
    WILDFLY_MANAGEMENT_PORT_NUMBER
    WILDFLY_USERNAME
    WILDFLY_PASSWORD
    JAVA_HOME
    JAVA_OPTS
    JAVA_TOOL_OPTIONS
)
for env_var in "${wildfly_env_vars[@]}"; do
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
unset wildfly_env_vars

# Paths
export WILDFLY_BASE_DIR="${BITNAMI_ROOT_DIR}/wildfly"
export WILDFLY_HOME_DIR="/home/wildfly"
export WILDFLY_BIN_DIR="${WILDFLY_BASE_DIR}/bin"
export WILDFLY_CONF_DIR="${WILDFLY_BASE_DIR}/standalone/configuration"
export WILDFLY_LOGS_DIR="${WILDFLY_BASE_DIR}/standalone/log"
export WILDFLY_TMP_DIR="${WILDFLY_BASE_DIR}/standalone/tmp"
export WILDFLY_DOMAIN_DIR="${WILDFLY_BASE_DIR}/domain"
export WILDFLY_STANDALONE_DIR="${WILDFLY_BASE_DIR}/standalone"
export WILDFLY_DEFAULT_DOMAIN_DIR="${WILDFLY_BASE_DIR}/domain.default"
export WILDFLY_DEFAULT_STANDALONE_DIR="${WILDFLY_BASE_DIR}/standalone.default"
export WILDFLY_CONF_FILE="${WILDFLY_CONF_FILE:-${WILDFLY_CONF_DIR}/standalone.xml}"
export WILDFLY_PID_FILE="${WILDFLY_TMP_DIR}/wildfly.pid"

# WildFly persistence configuration
export WILDFLY_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/wildfly"
export WILDFLY_MOUNTED_CONF_DIR="${WILDFLY_MOUNTED_CONF_DIR:-${WILDFLY_VOLUME_DIR}/configuration}"
export WILDFLY_DATA_DIR="${WILDFLY_DATA_DIR:-${WILDFLY_VOLUME_DIR}/standalone/data}"
export PATH="${WILDFLY_BIN_DIR}:${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# System users (when running with a privileged user)
export WILDFLY_DAEMON_USER="wildfly"
export WILDFLY_DAEMON_GROUP="wildfly"
export WILDFLY_DEFAULT_SERVER_LISTEN_ADDRESS="0.0.0.0" # only used at build time
export WILDFLY_DEFAULT_MANAGEMENT_LISTEN_ADDRESS="127.0.0.1" # only used at build time
export WILDFLY_DEFAULT_HTTP_PORT_NUMBER="8080" # only used at build time
export WILDFLY_DEFAULT_HTTPS_PORT_NUMBER="8443" # only used at build time
export WILDFLY_DEFAULT_AJP_PORT_NUMBER="8009" # only used at build time
export WILDFLY_DEFAULT_MANAGEMENT_PORT_NUMBER="9990" # only used at build time

# WildFly configuration
export WILDFLY_SERVER_LISTEN_ADDRESS="${WILDFLY_SERVER_LISTEN_ADDRESS:-}" # only used during the first initialization
export WILDFLY_MANAGEMENT_LISTEN_ADDRESS="${WILDFLY_MANAGEMENT_LISTEN_ADDRESS:-}" # only used during the first initialization
export WILDFLY_HTTP_PORT_NUMBER="${WILDFLY_HTTP_PORT_NUMBER:-}" # only used during the first initialization
export WILDFLY_HTTPS_PORT_NUMBER="${WILDFLY_HTTPS_PORT_NUMBER:-}" # only used during the first initialization
export WILDFLY_AJP_PORT_NUMBER="${WILDFLY_AJP_PORT_NUMBER:-}" # only used during the first initialization
export WILDFLY_MANAGEMENT_PORT_NUMBER="${WILDFLY_MANAGEMENT_PORT_NUMBER:-}" # only used during the first initialization
export LAUNCH_JBOSS_IN_BACKGROUND="true"

# WildFly credentials
export WILDFLY_USERNAME="${WILDFLY_USERNAME:-user}" # only used during the first initialization
export WILDFLY_PASSWORD="${WILDFLY_PASSWORD:-}" # only used during the first initialization

# Java configuration
export JAVA_HOME="${JAVA_HOME:-${BITNAMI_ROOT_DIR}/java}"
export JAVA_OPTS="${JAVA_OPTS:-}"
export JAVA_TOOL_OPTIONS="${JAVA_TOOL_OPTIONS:-}"

# Custom environment variables may be defined below
