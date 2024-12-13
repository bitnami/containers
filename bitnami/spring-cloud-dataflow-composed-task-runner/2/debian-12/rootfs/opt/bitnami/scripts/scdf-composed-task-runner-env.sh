#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for scdf-composed-task-runner

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
export MODULE="${MODULE:-scdf-composed-task-runner}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
scdf_composed_task_runner_env_vars=(
    JAVA_OPTS
    JAVA_TOOL_OPTIONS
)
for env_var in "${scdf_composed_task_runner_env_vars[@]}"; do
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
unset scdf_composed_task_runner_env_vars

# Paths
export SCDF_COMPOSED_TASK_RUNNER_BASE_DIR="${BITNAMI_ROOT_DIR}/spring-cloud-dataflow-composed-task-runner"
export SCDF_COMPOSED_TASK_RUNNER_M2_DIR="/.m2"

# System users (when running with a privileged user)
export SCDF_COMPOSED_TASK_RUNNER_DAEMON_USER="dataflow"
export SCDF_COMPOSED_TASK_RUNNER_DAEMON_GROUP="dataflow"

# Java settings
export JAVA_OPTS="${JAVA_OPTS:-}"
export JAVA_TOOL_OPTIONS="${JAVA_TOOL_OPTIONS:-}"

# Custom environment variables may be defined below
