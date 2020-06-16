#!/bin/bash
#
# Environment configuration for spring-cloud-skipper

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-spring-cloud-skipper}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
spring_cloud_skipper_env_vars=(
    SERVER_PORT
    SPRING_CLOUD_SKIPPER_CLOUD_CONFIG_ENABLED
    SPRING_CLOUD_KUBERNETES_SECRETS_ENABLE_API
    SPRING_CLOUD_KUBERNETES_CONFIG_NAME
    SPRING_CLOUD_KUBERNETES_SECRETS_PATHS
    SPRING_CLOUD_SKIPPER_CLIENT_SERVER_URI
    SPRING_CLOUD_SKIPPER_DATABASE_URL
    SPRING_CLOUD_SKIPPER_DATABASE_USERNAME
    SPRING_CLOUD_SKIPPER_DATABASE_PASSWORD
    SPRING_CLOUD_SKIPPER_DATABASE_DRIVER

)
for env_var in "${spring_cloud_skipper_env_vars[@]}"; do
    file_env_var="${env_var}_FILE"
    if [[ -n "${!file_env_var:-}" ]]; then
        export "${env_var}=$(< "${!file_env_var}")"
        unset "${file_env_var}"
    fi
done
unset spring_cloud_skipper_env_vars

# Paths
export SPRING_CLOUD_SKIPPER_BASE_DIR="${BITNAMI_ROOT_DIR}/spring-cloud-skipper"
export SPRING_CLOUD_SKIPPER_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/spring-cloud-skipper"
export SPRING_CLOUD_SKIPPER_CONF_DIR="${SPRING_CLOUD_SKIPPER_BASE_DIR}/conf"
export SPRING_CLOUD_SKIPPER_LOGS_DIR="${SPRING_CLOUD_SKIPPER_BASE_DIR}/logs"
export SPRING_CLOUD_SKIPPER_TMP_DIR="${SPRING_CLOUD_SKIPPER_BASE_DIR}/tmp"
export SPRING_CLOUD_SKIPPER_CONF_FILE="${SPRING_CLOUD_SKIPPER_CONF_DIR}/application.yml"

# System users (when running with a privileged user)
export SPRING_CLOUD_SKIPPER_DAEMON_USER="dataflow"
export SPRING_CLOUD_SKIPPER_DAEMON_GROUP="dataflow"

# SPRING CLOUD SKIPPER Build-time defaults conf, these variable are used to create default config file at build time.
export SPRING_CLOUD_CONFIG_ENABLED_DEFAULT="false"

# SPRING CLOUD SKIPPER authentication.

# Dataflow settings
export SERVER_PORT="${SERVER_PORT:-}"
export SPRING_CLOUD_SKIPPER_CLOUD_CONFIG_ENABLED="${SPRING_CLOUD_SKIPPER_CLOUD_CONFIG_ENABLED:-}"
export SPRING_CLOUD_KUBERNETES_SECRETS_ENABLE_API="${SPRING_CLOUD_KUBERNETES_SECRETS_ENABLE_API:-false}"
export SPRING_CLOUD_KUBERNETES_CONFIG_NAME="${SPRING_CLOUD_KUBERNETES_CONFIG_NAME:-}"
export SPRING_CLOUD_KUBERNETES_SECRETS_PATHS="${SPRING_CLOUD_KUBERNETES_SECRETS_PATHS:-}"
export SPRING_CLOUD_SKIPPER_CLIENT_SERVER_URI="${SPRING_CLOUD_SKIPPER_CLIENT_SERVER_URI:-}"

# Database settings
export SPRING_CLOUD_SKIPPER_DATABASE_URL="${SPRING_CLOUD_SKIPPER_DATABASE_URL:-}"
export SPRING_CLOUD_SKIPPER_DATABASE_USERNAME="${SPRING_CLOUD_SKIPPER_DATABASE_USERNAME:-}"
export SPRING_CLOUD_SKIPPER_DATABASE_PASSWORD="${SPRING_CLOUD_SKIPPER_DATABASE_PASSWORD:-}"
export SPRING_CLOUD_SKIPPER_DATABASE_DRIVER="${SPRING_CLOUD_SKIPPER_DATABASE_DRIVER:-}"

# Custom environment variables may be defined below
