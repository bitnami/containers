#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for tensorflowserving

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
export MODULE="${MODULE:-tensorflowserving}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
tensorflowserving_env_vars=(
    TENSORFLOW_SERVING_ENABLE_MONITORING
    TENSORFLOW_SERVING_MODEL_NAME
    TENSORFLOW_SERVING_MONITORING_PATH
    TENSORFLOW_SERVING_PORT_NUMBER
    TENSORFLOW_SERVING_REST_API_PORT_NUMBER
)
for env_var in "${tensorflowserving_env_vars[@]}"; do
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
unset tensorflowserving_env_vars

# Paths
export BITNAMI_VOLUME_DIR="/bitnami"
export TENSORFLOW_SERVING_BASE_DIR="${BITNAMI_ROOT_DIR}/tensorflow-serving"
export TENSORFLOW_SERVING_BIN_DIR="${TENSORFLOW_SERVING_BASE_DIR}/bin"
export TENSORFLOW_SERVING_TMP_DIR="${TENSORFLOW_SERVING_BASE_DIR}/tmp"
export TENSORFLOW_SERVING_PID_FILE="${TENSORFLOW_SERVING_TMP_DIR}/tensorflow-serving.pid"
export TENSORFLOW_SERVING_CONF_DIR="${TENSORFLOW_SERVING_BASE_DIR}/conf"
export TENSORFLOW_SERVING_CONF_FILE="${TENSORFLOW_SERVING_CONF_DIR}/tensorflow-serving.conf"
export TENSORFLOW_SERVING_MONITORING_CONF_FILE="${TENSORFLOW_SERVING_CONF_DIR}/monitoring.conf"
export TENSORFLOW_SERVING_LOGS_DIR="${TENSORFLOW_SERVING_BASE_DIR}/logs"
export TENSORFLOW_SERVING_LOGS_FILE="${TENSORFLOW_SERVING_LOGS_DIR}/tensorflow-serving.log"
export PATH="${TENSORFLOW_SERVING_BASE_DIR}/serving/bazel-bin/tensorflow_serving/model_servers/:${PATH}"

# Persistence
export TENSORFLOW_SERVING_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/tensorflow-serving"
export TENSORFLOW_SERVING_MODEL_DATA="${BITNAMI_VOLUME_DIR}/model-data"

# Tensorflow parameters
export TENSORFLOW_SERVING_ENABLE_MONITORING="${TENSORFLOW_SERVING_ENABLE_MONITORING:-no}"
export TENSORFLOW_SERVING_MODEL_NAME="${TENSORFLOW_SERVING_MODEL_NAME:-resnet}"
export TENSORFLOW_SERVING_MONITORING_PATH="${TENSORFLOW_SERVING_MONITORING_PATH:-/monitoring/prometheus/metrics}"
export TENSORFLOW_SERVING_PORT_NUMBER="${TENSORFLOW_SERVING_PORT_NUMBER:-8500}"
export TENSORFLOW_SERVING_REST_API_PORT_NUMBER="${TENSORFLOW_SERVING_REST_API_PORT_NUMBER:-8501}"

# System users (when running with a privileged user)
export TENSORFLOW_SERVING_DAEMON_USER="tensorflow"
export TENSORFLOW_SERVING_DAEMON_GROUP="tensorflow"

# Custom environment variables may be defined below
