#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for jenkins

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
export MODULE="${MODULE:-jenkins}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
jenkins_env_vars=(
    JENKINS_HOME
    JENKINS_PLUGINS
    JENKINS_PLUGINS_LATEST
    JENKINS_PLUGINS_LATEST_SPECIFIED
    JENKINS_SKIP_IMAGE_PLUGINS
    JENKINS_OVERRIDE_PLUGINS
    JENKINS_OVERRIDE_PATHS
    JENKINS_HTTP_LISTEN_ADDRESS
    JENKINS_HTTPS_LISTEN_ADDRESS
    JENKINS_HTTP_PORT_NUMBER
    JENKINS_HTTPS_PORT_NUMBER
    JENKINS_JNLP_PORT_NUMBER
    JENKINS_EXTERNAL_HTTP_PORT_NUMBER
    JENKINS_EXTERNAL_HTTPS_PORT_NUMBER
    JENKINS_HOST
    JENKINS_FORCE_HTTPS
    JENKINS_SKIP_BOOTSTRAP
    JENKINS_ENABLE_SWARM
    JENKINS_CERTS_DIR
    JENKINS_KEYSTORE_PASSWORD
    JENKINS_OPTS
    JENKINS_USERNAME
    JENKINS_PASSWORD
    JENKINS_EMAIL
    JENKINS_SWARM_USERNAME
    JENKINS_SWARM_PASSWORD
    JAVA_HOME
    JAVA_OPTS
    DISABLE_JENKINS_INITIALIZATION
)
for env_var in "${jenkins_env_vars[@]}"; do
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
unset jenkins_env_vars

# Paths
export JENKINS_BASE_DIR="${BITNAMI_ROOT_DIR}/jenkins"
export JENKINS_LOGS_DIR="${JENKINS_BASE_DIR}/logs"
export JENKINS_LOG_FILE="${JENKINS_LOGS_DIR}/jenkins.log"
export JENKINS_TMP_DIR="${JENKINS_BASE_DIR}/tmp"
export JENKINS_PID_FILE="${JENKINS_TMP_DIR}/jenkins.pid"
export JENKINS_TEMPLATES_DIR="${BITNAMI_ROOT_DIR}/scripts/jenkins/bitnami-templates"

# Jenkins persistence configuration
export JENKINS_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/jenkins"
export JENKINS_HOME="${JENKINS_HOME:-${JENKINS_VOLUME_DIR}/home}"
export JENKINS_MOUNTED_CONTENT_DIR="/usr/share/jenkins/ref"
export JENKINS_PLUGINS="${JENKINS_PLUGINS:-}"
export JENKINS_PLUGINS_LATEST="${JENKINS_PLUGINS_LATEST:-true}"
export JENKINS_PLUGINS_LATEST_SPECIFIED="${JENKINS_PLUGINS_LATEST_SPECIFIED:-false}"
export JENKINS_SKIP_IMAGE_PLUGINS="${JENKINS_SKIP_IMAGE_PLUGINS:-false}"
export JENKINS_OVERRIDE_PLUGINS="${JENKINS_OVERRIDE_PLUGINS:-false}"
export JENKINS_OVERRIDE_PATHS="${JENKINS_OVERRIDE_PATHS:-}"

# System users (when running with a privileged user)
export JENKINS_DAEMON_USER="jenkins"
export JENKINS_DAEMON_GROUP="jenkins"

# Jenkins configuration
export JENKINS_DEFAULT_HTTP_LISTEN_ADDRESS="0.0.0.0" # only used at build time
export JENKINS_DEFAULT_HTTPS_LISTEN_ADDRESS="0.0.0.0" # only used at build time
export JENKINS_DEFAULT_HTTP_PORT_NUMBER="8080" # only used at build time
export JENKINS_DEFAULT_HTTPS_PORT_NUMBER="8443" # only used at build time
export JENKINS_DEFAULT_JNLP_PORT_NUMBER="50000" # only used at build time
export JENKINS_HTTP_LISTEN_ADDRESS="${JENKINS_HTTP_LISTEN_ADDRESS:-}"
export JENKINS_HTTPS_LISTEN_ADDRESS="${JENKINS_HTTPS_LISTEN_ADDRESS:-}"
export JENKINS_HTTP_PORT_NUMBER="${JENKINS_HTTP_PORT_NUMBER:-}"
export JENKINS_HTTPS_PORT_NUMBER="${JENKINS_HTTPS_PORT_NUMBER:-}"
export JENKINS_JNLP_PORT_NUMBER="${JENKINS_JNLP_PORT_NUMBER:-}"
export JENKINS_EXTERNAL_HTTP_PORT_NUMBER="${JENKINS_EXTERNAL_HTTP_PORT_NUMBER:-80}"
export JENKINS_EXTERNAL_HTTPS_PORT_NUMBER="${JENKINS_EXTERNAL_HTTPS_PORT_NUMBER:-443}"
export JENKINS_HOST="${JENKINS_HOST:-}"
export JENKINS_FORCE_HTTPS="${JENKINS_FORCE_HTTPS:-no}"
JENKINS_SKIP_BOOTSTRAP="${JENKINS_SKIP_BOOTSTRAP:-"${DISABLE_JENKINS_INITIALIZATION:-}"}"
export JENKINS_SKIP_BOOTSTRAP="${JENKINS_SKIP_BOOTSTRAP:-no}" # only used during the first initialization
export JENKINS_ENABLE_SWARM="${JENKINS_ENABLE_SWARM:-no}"
export JENKINS_CERTS_DIR="${JENKINS_CERTS_DIR:-${JENKINS_HOME}}"
export JENKINS_KEYSTORE_PASSWORD="${JENKINS_KEYSTORE_PASSWORD:-bitnami}"
export JENKINS_OPTS="${JENKINS_OPTS:-}"

# Jenkins credentials
export JENKINS_USERNAME="${JENKINS_USERNAME:-user}" # only used during the first initialization
export JENKINS_PASSWORD="${JENKINS_PASSWORD:-bitnami}" # only used during the first initialization
export JENKINS_EMAIL="${JENKINS_EMAIL:-user@example.com}" # only used during the first initialization
export JENKINS_SWARM_USERNAME="${JENKINS_SWARM_USERNAME:-swarm}" # only used during the first initialization
export JENKINS_SWARM_PASSWORD="${JENKINS_SWARM_PASSWORD:-}" # only used during the first initialization

# Java configuration
export JAVA_HOME="${JAVA_HOME:-${BITNAMI_ROOT_DIR}/java}"
export JAVA_OPTS="${JAVA_OPTS:-}"

# Custom environment variables may be defined below
