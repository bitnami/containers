#!/bin/bash
#
# Environment configuration for spring-cloud-dataflow

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-spring-cloud-dataflow}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
spring_cloud_dataflow_env_vars=(
    SERVER_PORT
    SPRING_CLOUD_CONFIG_ENABLED
    SPRING_CLOUD_KUBERNETES_SECRETS_ENABLE_API
    SPRING_CLOUD_KUBERNETES_CONFIG_NAME
    SPRING_CLOUD_KUBERNETES_SECRETS_PATHS
    SPRING_CLOUD_DATAFLOW_FEATURES_STREAMS_ENABLED
    SPRING_CLOUD_DATAFLOW_FEATURES_TASKS_ENABLED
    SPRING_CLOUD_DATAFLOW_FEATURES_SCHEDULES_ENABLED
    SPRING_CLOUD_SKIPPER_CLIENT_SERVER_URI

)
for env_var in "${spring_cloud_dataflow_env_vars[@]}"; do
    file_env_var="${env_var}_FILE"
    if [[ -n "${!file_env_var:-}" ]]; then
        export "${env_var}=$(< "${!file_env_var}")"
        unset "${file_env_var}"
    fi
done
unset spring_cloud_dataflow_env_vars

# Paths
export SPRING_CLOUD_DATAFLOW_BASE_DIR="${BITNAMI_ROOT_DIR}/spring-cloud-dataflow"
export SPRING_CLOUD_DATAFLOW_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/spring-cloud-dataflow"
export SPRING_CLOUD_DATAFLOW_CONF_DIR="${SPRING_CLOUD_DATAFLOW_BASE_DIR}/conf"
export SPRING_CLOUD_DATAFLOW_CONF_FILE="${SPRING_CLOUD_DATAFLOW_CONF_DIR}/application.yml"
export SPRING_CLOUD_DATAFLOW_M2_DIR="/.m2"

# System users (when running with a privileged user)
export SPRING_CLOUD_DATAFLOW_DAEMON_USER="dataflow"
export SPRING_CLOUD_DATAFLOW_DAEMON_GROUP="dataflow"

# Java settings
export JAVA_OPTS="${JAVA_OPTS:-}"

# Dataflow settings
export SERVER_PORT="${SERVER_PORT:-}"
export SPRING_CLOUD_CONFIG_ENABLED="${SPRING_CLOUD_CONFIG_ENABLED:-false}"
export SPRING_CLOUD_KUBERNETES_SECRETS_ENABLE_API="${SPRING_CLOUD_KUBERNETES_SECRETS_ENABLE_API:-false}"
export SPRING_CLOUD_KUBERNETES_CONFIG_NAME="${SPRING_CLOUD_KUBERNETES_CONFIG_NAME:-}"
export SPRING_CLOUD_KUBERNETES_SECRETS_PATHS="${SPRING_CLOUD_KUBERNETES_SECRETS_PATHS:-}"
export SPRING_CLOUD_DATAFLOW_FEATURES_STREAMS_ENABLED="${SPRING_CLOUD_DATAFLOW_FEATURES_STREAMS_ENABLED:-false}"
export SPRING_CLOUD_DATAFLOW_FEATURES_TASKS_ENABLED="${SPRING_CLOUD_DATAFLOW_FEATURES_TASKS_ENABLED:-false}"
export SPRING_CLOUD_DATAFLOW_FEATURES_SCHEDULES_ENABLED="${SPRING_CLOUD_DATAFLOW_FEATURES_SCHEDULES_ENABLED:-false}"
export SPRING_CLOUD_SKIPPER_CLIENT_SERVER_URI="${SPRING_CLOUD_SKIPPER_CLIENT_SERVER_URI:-}"

# Custom environment variables may be defined below
