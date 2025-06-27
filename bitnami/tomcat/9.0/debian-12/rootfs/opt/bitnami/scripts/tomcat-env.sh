#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for tomcat

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
export MODULE="${MODULE:-tomcat}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
tomcat_env_vars=(
    TOMCAT_SHUTDOWN_PORT_NUMBER
    TOMCAT_HTTP_PORT_NUMBER
    TOMCAT_AJP_PORT_NUMBER
    TOMCAT_USERNAME
    TOMCAT_PASSWORD
    TOMCAT_ALLOW_REMOTE_MANAGEMENT
    TOMCAT_ENABLE_AUTH
    TOMCAT_ENABLE_AJP
    TOMCAT_START_RETRIES
    TOMCAT_EXTRA_JAVA_OPTS
    TOMCAT_INSTALL_DEFAULT_WEBAPPS
    JAVA_OPTS
)
for env_var in "${tomcat_env_vars[@]}"; do
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
unset tomcat_env_vars

# Paths
export TOMCAT_BASE_DIR="${BITNAMI_ROOT_DIR}/tomcat"
export TOMCAT_VOLUME_DIR="/bitnami/tomcat"
export TOMCAT_BIN_DIR="${TOMCAT_BASE_DIR}/bin"
export TOMCAT_LIB_DIR="${TOMCAT_BASE_DIR}/lib"
export TOMCAT_WORK_DIR="${TOMCAT_BASE_DIR}/work"
export TOMCAT_WEBAPPS_DIR="${TOMCAT_VOLUME_DIR}/webapps"
export TOMCAT_CONF_DIR="${TOMCAT_BASE_DIR}/conf"
export TOMCAT_DEFAULT_CONF_DIR="${TOMCAT_BASE_DIR}/conf.default"
export TOMCAT_CONF_FILE="${TOMCAT_CONF_DIR}/server.xml"
export TOMCAT_USERS_CONF_FILE="${TOMCAT_CONF_DIR}/tomcat-users.xml"
export TOMCAT_LOGS_DIR="${TOMCAT_BASE_DIR}/logs"
export TOMCAT_TMP_DIR="${TOMCAT_BASE_DIR}/temp"
export TOMCAT_LOG_FILE="${TOMCAT_LOGS_DIR}/catalina.out"
export TOMCAT_PID_FILE="${TOMCAT_TMP_DIR}/catalina.pid"
export TOMCAT_HOME="$TOMCAT_BASE_DIR"

# System users (when running with a privileged user)
export TOMCAT_DAEMON_USER="tomcat"
export TOMCAT_DAEMON_GROUP="tomcat"

# Tomcat configuration
export TOMCAT_SHUTDOWN_PORT_NUMBER="${TOMCAT_SHUTDOWN_PORT_NUMBER:-8005}"
export TOMCAT_HTTP_PORT_NUMBER="${TOMCAT_HTTP_PORT_NUMBER:-8080}"
export TOMCAT_AJP_PORT_NUMBER="${TOMCAT_AJP_PORT_NUMBER:-8009}"
export TOMCAT_USERNAME="${TOMCAT_USERNAME:-manager}"
export TOMCAT_PASSWORD="${TOMCAT_PASSWORD:-}"
export TOMCAT_ALLOW_REMOTE_MANAGEMENT="${TOMCAT_ALLOW_REMOTE_MANAGEMENT:-yes}" # only used during the first initialization
export TOMCAT_ENABLE_AUTH="${TOMCAT_ENABLE_AUTH:-yes}"
export TOMCAT_ENABLE_AJP="${TOMCAT_ENABLE_AJP:-no}"
export TOMCAT_START_RETRIES="${TOMCAT_START_RETRIES:-12}"
export TOMCAT_EXTRA_JAVA_OPTS="${TOMCAT_EXTRA_JAVA_OPTS:-}"
export TOMCAT_INSTALL_DEFAULT_WEBAPPS="${TOMCAT_INSTALL_DEFAULT_WEBAPPS:-yes}"

# Default JVM configuration
export JAVA_HOME="${BITNAMI_ROOT_DIR}/java"
export JAVA_OPTS="${JAVA_OPTS:--Djava.awt.headless=true -XX:+UseG1GC -Dfile.encoding=UTF-8 -Djava.net.preferIPv4Stack=true -Djava.net.preferIPv4Addresses=true -Duser.home=${TOMCAT_HOME}}"

# Other parameters
export PATH="${TOMCAT_BASE_DIR}/bin:${JAVA_HOME}/bin:${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# Custom environment variables may be defined below
