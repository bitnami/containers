#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for jenkins-agent

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
export MODULE="${MODULE:-jenkins-agent}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
jenkins_agent_env_vars=(
    JENKINS_AGENT_TUNNEL
    JENKINS_AGENT_URL
    JENKINS_AGENT_PROTOCOLS
    JENKINS_AGENT_DIRECT_CONNECTION
    JENKINS_AGENT_INSTANCE_IDENTITY
    JENKINS_AGENT_WORKDIR
    JENKINS_AGENT_WEB_SOCKET
    JENKINS_AGENT_SECRET
    JENKINS_AGENT_NAME
    JAVA_HOME
    JAVA_OPTS
    JENKINS_TUNNEL
    JENKINS_URL
    JENKINS_PROTOCOLS
    JENKINS_DIRECT_CONNECTION
    JENKINS_INSTANCE_IDENTITY
    JENKINS_WORKDIR
    AGENT_WORKDIR
    JENKINS_WEB_SOCKET
    JENKINS_SECRET
    JENKINS_NAME
)
for env_var in "${jenkins_agent_env_vars[@]}"; do
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
unset jenkins_agent_env_vars

# Paths
export JENKINS_AGENT_BASE_DIR="${BITNAMI_ROOT_DIR}/jenkins-agent"
export JENKINS_AGENT_LOGS_DIR="${JENKINS_AGENT_BASE_DIR}/logs"
export JENKINS_AGENT_LOG_FILE="${JENKINS_AGENT_LOGS_DIR}/jenkins-agent.log"
export JENKINS_AGENT_TMP_DIR="${JENKINS_AGENT_BASE_DIR}/tmp"
export JENKINS_AGENT_PID_FILE="${JENKINS_AGENT_TMP_DIR}/jenkins-agent.pid"

# Jenkins Agent persistence configuration
export JENKINS_AGENT_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/jenkins"

# System users (when running with a privileged user)
export JENKINS_AGENT_DAEMON_USER="jenkins"
export JENKINS_AGENT_DAEMON_GROUP="jenkins"

# Jenkins Agent configuration
JENKINS_AGENT_TUNNEL="${JENKINS_AGENT_TUNNEL:-"${JENKINS_TUNNEL:-}"}"
export JENKINS_AGENT_TUNNEL="${JENKINS_AGENT_TUNNEL:-}"
JENKINS_AGENT_URL="${JENKINS_AGENT_URL:-"${JENKINS_URL:-}"}"
export JENKINS_AGENT_URL="${JENKINS_AGENT_URL:-}"
JENKINS_AGENT_PROTOCOLS="${JENKINS_AGENT_PROTOCOLS:-"${JENKINS_PROTOCOLS:-}"}"
export JENKINS_AGENT_PROTOCOLS="${JENKINS_AGENT_PROTOCOLS:-}"
JENKINS_AGENT_DIRECT_CONNECTION="${JENKINS_AGENT_DIRECT_CONNECTION:-"${JENKINS_DIRECT_CONNECTION:-}"}"
export JENKINS_AGENT_DIRECT_CONNECTION="${JENKINS_AGENT_DIRECT_CONNECTION:-}"
JENKINS_AGENT_INSTANCE_IDENTITY="${JENKINS_AGENT_INSTANCE_IDENTITY:-"${JENKINS_INSTANCE_IDENTITY:-}"}"
export JENKINS_AGENT_INSTANCE_IDENTITY="${JENKINS_AGENT_INSTANCE_IDENTITY:-}"
JENKINS_AGENT_WORKDIR="${JENKINS_AGENT_WORKDIR:-"${JENKINS_WORKDIR:-}"}"
JENKINS_AGENT_WORKDIR="${JENKINS_AGENT_WORKDIR:-"${AGENT_WORKDIR:-}"}"
export JENKINS_AGENT_WORKDIR="${JENKINS_AGENT_WORKDIR:-${JENKINS_AGENT_VOLUME_DIR}/home}"
JENKINS_AGENT_WEB_SOCKET="${JENKINS_AGENT_WEB_SOCKET:-"${JENKINS_WEB_SOCKET:-}"}"
export JENKINS_AGENT_WEB_SOCKET="${JENKINS_AGENT_WEB_SOCKET:-false}"
JENKINS_AGENT_SECRET="${JENKINS_AGENT_SECRET:-"${JENKINS_SECRET:-}"}"
export JENKINS_AGENT_SECRET="${JENKINS_AGENT_SECRET:-}"
JENKINS_AGENT_NAME="${JENKINS_AGENT_NAME:-"${JENKINS_NAME:-}"}"
export JENKINS_AGENT_NAME="${JENKINS_AGENT_NAME:-}"

# Java configuration
export JAVA_HOME="${JAVA_HOME:-${BITNAMI_ROOT_DIR}/java}"
export JAVA_OPTS="${JAVA_OPTS:-}"

# Custom environment variables may be defined below
