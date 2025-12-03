#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for activemq

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
export MODULE="${MODULE:-activemq}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
activemq_env_vars=(
    ACTIVEMQ_MOUNTED_CONF_DIR
    ACTIVEMQ_MQTT_PORT_NUMBER
    ACTIVEMQ_AQMQ_PORT_NUMBER
    ACTIVEMQ_HTTP_PORT_NUMBER
    ACTIVEMQ_STOMP_PORT_NUMBER
    ACTIVEMQ_WEBSOCKET_PORT_NUMBER
    ACTIVEMQ_OPENWIRE_PORT_NUMBER
    ACTIVEMQ_USERNAME
    ACTIVEMQ_PASSWORD
    ACTIVEMQ_SECRET
)
for env_var in "${activemq_env_vars[@]}"; do
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
unset activemq_env_vars

# Paths
export ACTIVEMQ_BASE_DIR="${BITNAMI_ROOT_DIR}/activemq"
export ACTIVEMQ_BIN_DIR="${ACTIVEMQ_BASE_DIR}/bin"
export ACTIVEMQ_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/activemq"
export ACTIVEMQ_DATA_DIR="${ACTIVEMQ_VOLUME_DIR}/data"
export ACTIVEMQ_CONF_DIR="${ACTIVEMQ_BASE_DIR}/conf"
export ACTIVEMQ_DEFAULT_CONF_DIR="${ACTIVEMQ_BASE_DIR}/conf.default"
export ACTIVEMQ_MOUNTED_CONF_DIR="${ACTIVEMQ_MOUNTED_CONF_DIR:-${ACTIVEMQ_VOLUME_DIR}/conf}"
export ACTIVEMQ_LOGS_DIR="${ACTIVEMQ_BASE_DIR}/logs"
export ACTIVEMQ_TMP_DIR="${ACTIVEMQ_BASE_DIR}/tmp"
export ACTIVEMQ_CONF_FILE="${ACTIVEMQ_CONF_DIR}/activemq.xml"
export ACTIVEMQ_LOG_FILE="${ACTIVEMQ_LOGS_DIR}/activemq.log"
export ACTIVEMQ_PID_FILE="${ACTIVEMQ_TMP_DIR}/activemq.pid"
export ACTIVEMQ_HOME="$ACTIVEMQ_BASE_DIR"

# System users (when running with a privileged user)
export ACTIVEMQ_DAEMON_USER="activemq"
export ACTIVEMQ_DAEMON_GROUP="activemq"

# ActiveMQ configuration
export ACTIVEMQ_MQTT_PORT_NUMBER="${ACTIVEMQ_MQTT_PORT_NUMBER:-1883}"
export ACTIVEMQ_AQMQ_PORT_NUMBER="${ACTIVEMQ_AQMQ_PORT_NUMBER:-5672}"
export ACTIVEMQ_HTTP_PORT_NUMBER="${ACTIVEMQ_HTTP_PORT_NUMBER:-8161}"
export ACTIVEMQ_STOMP_PORT_NUMBER="${ACTIVEMQ_STOMP_PORT_NUMBER:-61613}"
export ACTIVEMQ_WEBSOCKET_PORT_NUMBER="${ACTIVEMQ_WEBSOCKET_PORT_NUMBER:-61614}"
export ACTIVEMQ_OPENWIRE_PORT_NUMBER="${ACTIVEMQ_OPENWIRE_PORT_NUMBER:-61616}"
export ACTIVEMQ_USERNAME="${ACTIVEMQ_USERNAME:-admin}"
export ACTIVEMQ_PASSWORD="${ACTIVEMQ_PASSWORD:-password}"
export ACTIVEMQ_SECRET="${ACTIVEMQ_SECRET:-bitnami}"

# Default JVM configuration
export JAVA_HOME="${BITNAMI_ROOT_DIR}/java"

# Other parameters
export ACTIVEMQ_PIDFILE="${ACTIVEMQ_PID_FILE}"
export ACTIVEMQ_OUT="${ACTIVEMQ_LOG_FILE}"
export PATH="${ACTIVEMQ_BASE_DIR}/bin:${JAVA_HOME}/bin:${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# Custom environment variables may be defined below
