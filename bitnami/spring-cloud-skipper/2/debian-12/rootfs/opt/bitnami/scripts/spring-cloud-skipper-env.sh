#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for spring-cloud-skipper

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
export MODULE="${MODULE:-spring-cloud-skipper}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
spring_cloud_skipper_env_vars=(
    SERVER_PORT
    SPRING_CLOUD_CONFIG_ENABLED
    SPRING_CLOUD_KUBERNETES_SECRETS_ENABLE_API
    SPRING_CLOUD_KUBERNETES_CONFIG_NAME
    SPRING_CLOUD_KUBERNETES_SECRETS_PATHS
    JAVA_OPTS
    JAVA_TOOL_OPTIONS
)
for env_var in "${spring_cloud_skipper_env_vars[@]}"; do
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
unset spring_cloud_skipper_env_vars

# Paths
export SPRING_CLOUD_SKIPPER_BASE_DIR="${BITNAMI_ROOT_DIR}/spring-cloud-skipper"
export SPRING_CLOUD_SKIPPER_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/spring-cloud-skipper"
export SPRING_CLOUD_SKIPPER_CONF_DIR="${SPRING_CLOUD_SKIPPER_BASE_DIR}/conf"
export SPRING_CLOUD_SKIPPER_CONF_FILE="${SPRING_CLOUD_SKIPPER_CONF_DIR}/application.yml"
export SPRING_CLOUD_SKIPPER_M2_DIR="/.m2"

# System users (when running with a privileged user)
export SPRING_CLOUD_SKIPPER_DAEMON_USER="dataflow"
export SPRING_CLOUD_SKIPPER_DAEMON_GROUP="dataflow"

# Dataflow settings
export SERVER_PORT="${SERVER_PORT:-}"
export SPRING_CLOUD_CONFIG_ENABLED="${SPRING_CLOUD_CONFIG_ENABLED:-false}"
export SPRING_CLOUD_KUBERNETES_SECRETS_ENABLE_API="${SPRING_CLOUD_KUBERNETES_SECRETS_ENABLE_API:-false}"
export SPRING_CLOUD_KUBERNETES_CONFIG_NAME="${SPRING_CLOUD_KUBERNETES_CONFIG_NAME:-}"
export SPRING_CLOUD_KUBERNETES_SECRETS_PATHS="${SPRING_CLOUD_KUBERNETES_SECRETS_PATHS:-}"

# Java settings
export JAVA_OPTS="${JAVA_OPTS:-}"
export JAVA_TOOL_OPTIONS="${JAVA_TOOL_OPTIONS:-}"

# Custom environment variables may be defined below
