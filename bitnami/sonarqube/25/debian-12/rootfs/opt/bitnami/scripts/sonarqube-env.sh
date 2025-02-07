#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for sonarqube

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
export MODULE="${MODULE:-sonarqube}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
sonarqube_env_vars=(
    SONARQUBE_MOUNTED_PROVISIONING_DIR
    SONARQUBE_DATA_TO_PERSIST
    SONARQUBE_PORT_NUMBER
    SONARQUBE_ELASTICSEARCH_PORT_NUMBER
    SONARQUBE_START_TIMEOUT
    SONARQUBE_SKIP_BOOTSTRAP
    SONARQUBE_WEB_CONTEXT
    SONARQUBE_MAX_HEAP_SIZE
    SONARQUBE_MIN_HEAP_SIZE
    SONARQUBE_CE_JAVA_ADD_OPTS
    SONARQUBE_ELASTICSEARCH_JAVA_ADD_OPTS
    SONARQUBE_WEB_JAVA_ADD_OPTS
    SONARQUBE_EXTRA_PROPERTIES
    SONARQUBE_USERNAME
    SONARQUBE_PASSWORD
    SONARQUBE_EMAIL
    SONARQUBE_SMTP_HOST
    SONARQUBE_SMTP_PORT_NUMBER
    SONARQUBE_SMTP_USER
    SONARQUBE_SMTP_PASSWORD
    SONARQUBE_SMTP_PROTOCOL
    SONARQUBE_DATABASE_HOST
    SONARQUBE_DATABASE_PORT_NUMBER
    SONARQUBE_DATABASE_NAME
    SONARQUBE_DATABASE_USER
    SONARQUBE_DATABASE_PASSWORD
    SONARQUBE_PROPERTIES
    SMTP_HOST
    SMTP_PORT
    SONARQUBE_SMTP_PORT
    SMTP_USER
    SMTP_PASSWORD
    SMTP_PROTOCOL
    POSTGRESQL_HOST
    POSTGRESQL_PORT_NUMBER
    POSTGRESQL_DATABASE_NAME
    POSTGRESQL_DATABASE_USER
    POSTGRESQL_DATABASE_USERNAME
    POSTGRESQL_DATABASE_PASSWORD
)
for env_var in "${sonarqube_env_vars[@]}"; do
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
unset sonarqube_env_vars

# Paths
export SONARQUBE_BASE_DIR="${BITNAMI_ROOT_DIR}/sonarqube"
export SONARQUBE_DATA_DIR="${SONARQUBE_BASE_DIR}/data"
export SONARQUBE_EXTENSIONS_DIR="${SONARQUBE_BASE_DIR}/extensions"
export SONARQUBE_MOUNTED_PROVISIONING_DIR="${SONARQUBE_MOUNTED_PROVISIONING_DIR:-/bitnami/sonarqube-provisioning}"
export SONARQUBE_CONF_DIR="${SONARQUBE_BASE_DIR}/conf"
export SONARQUBE_CONF_FILE="${SONARQUBE_CONF_DIR}/sonar.properties"
export SONARQUBE_LOGS_DIR="${SONARQUBE_BASE_DIR}/logs"
export SONARQUBE_LOG_FILE="${SONARQUBE_LOGS_DIR}/sonar.log"
export SONARQUBE_TMP_DIR="${SONARQUBE_BASE_DIR}/temp"
export SONARQUBE_PID_FILE="${SONARQUBE_BASE_DIR}/pids/SonarQube.pid"
export SONARQUBE_BIN_DIR="${SONARQUBE_BASE_DIR}/bin/linux-x86-64"
export PATH="${BITNAMI_ROOT_DIR}/java/bin:${PATH}"

# SonarQube persistence configuration
export SONARQUBE_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/sonarqube"
export SONARQUBE_DATA_TO_PERSIST="${SONARQUBE_DATA_TO_PERSIST:-${SONARQUBE_DATA_DIR} ${SONARQUBE_EXTENSIONS_DIR}}"

# System users (when running with a privileged user)
export SONARQUBE_DAEMON_USER="sonarqube"
export SONARQUBE_DAEMON_USER_ID="1001" # only used at build time
export SONARQUBE_DAEMON_GROUP="sonarqube"
export SONARQUBE_DAEMON_GROUP_ID="1001" # only used at build time

# SonarQube configuration
export SONARQUBE_PORT_NUMBER="${SONARQUBE_PORT_NUMBER:-9000}"
export SONARQUBE_ELASTICSEARCH_PORT_NUMBER="${SONARQUBE_ELASTICSEARCH_PORT_NUMBER:-9001}"
export SONARQUBE_START_TIMEOUT="${SONARQUBE_START_TIMEOUT:-300}" # only used during the first initialization
export SONARQUBE_SKIP_BOOTSTRAP="${SONARQUBE_SKIP_BOOTSTRAP:-no}" # only used during the first initialization
export SONARQUBE_WEB_CONTEXT="${SONARQUBE_WEB_CONTEXT:-/}"
export SONARQUBE_MAX_HEAP_SIZE="${SONARQUBE_MAX_HEAP_SIZE:-}"
export SONARQUBE_MIN_HEAP_SIZE="${SONARQUBE_MIN_HEAP_SIZE:-}"
export SONARQUBE_CE_JAVA_ADD_OPTS="${SONARQUBE_CE_JAVA_ADD_OPTS:-}"
export SONARQUBE_ELASTICSEARCH_JAVA_ADD_OPTS="${SONARQUBE_ELASTICSEARCH_JAVA_ADD_OPTS:-}"
export SONARQUBE_WEB_JAVA_ADD_OPTS="${SONARQUBE_WEB_JAVA_ADD_OPTS:-}"
SONARQUBE_EXTRA_PROPERTIES="${SONARQUBE_EXTRA_PROPERTIES:-"${SONARQUBE_PROPERTIES:-}"}"
export SONARQUBE_EXTRA_PROPERTIES="${SONARQUBE_EXTRA_PROPERTIES:-}"

# SonarQube credentials
export SONARQUBE_USERNAME="${SONARQUBE_USERNAME:-admin}" # only used during the first initialization
export SONARQUBE_PASSWORD="${SONARQUBE_PASSWORD:-bitnami}" # only used during the first initialization
export SONARQUBE_EMAIL="${SONARQUBE_EMAIL:-user@example.com}" # only used during the first initialization

# SonarQube SMTP credentials
SONARQUBE_SMTP_HOST="${SONARQUBE_SMTP_HOST:-"${SMTP_HOST:-}"}"
export SONARQUBE_SMTP_HOST="${SONARQUBE_SMTP_HOST:-}" # only used during the first initialization
SONARQUBE_SMTP_PORT_NUMBER="${SONARQUBE_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
SONARQUBE_SMTP_PORT_NUMBER="${SONARQUBE_SMTP_PORT_NUMBER:-"${SONARQUBE_SMTP_PORT:-}"}"
export SONARQUBE_SMTP_PORT_NUMBER="${SONARQUBE_SMTP_PORT_NUMBER:-}" # only used during the first initialization
SONARQUBE_SMTP_USER="${SONARQUBE_SMTP_USER:-"${SMTP_USER:-}"}"
export SONARQUBE_SMTP_USER="${SONARQUBE_SMTP_USER:-}" # only used during the first initialization
SONARQUBE_SMTP_PASSWORD="${SONARQUBE_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export SONARQUBE_SMTP_PASSWORD="${SONARQUBE_SMTP_PASSWORD:-}" # only used during the first initialization
SONARQUBE_SMTP_PROTOCOL="${SONARQUBE_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
export SONARQUBE_SMTP_PROTOCOL="${SONARQUBE_SMTP_PROTOCOL:-}" # only used during the first initialization

# Database configuration
export SONARQUBE_DEFAULT_DATABASE_HOST="postgresql" # only used at build time
SONARQUBE_DATABASE_HOST="${SONARQUBE_DATABASE_HOST:-"${POSTGRESQL_HOST:-}"}"
export SONARQUBE_DATABASE_HOST="${SONARQUBE_DATABASE_HOST:-$SONARQUBE_DEFAULT_DATABASE_HOST}" # only used during the first initialization
SONARQUBE_DATABASE_PORT_NUMBER="${SONARQUBE_DATABASE_PORT_NUMBER:-"${POSTGRESQL_PORT_NUMBER:-}"}"
export SONARQUBE_DATABASE_PORT_NUMBER="${SONARQUBE_DATABASE_PORT_NUMBER:-5432}" # only used during the first initialization
SONARQUBE_DATABASE_NAME="${SONARQUBE_DATABASE_NAME:-"${POSTGRESQL_DATABASE_NAME:-}"}"
export SONARQUBE_DATABASE_NAME="${SONARQUBE_DATABASE_NAME:-bitnami_sonarqube}" # only used during the first initialization
SONARQUBE_DATABASE_USER="${SONARQUBE_DATABASE_USER:-"${POSTGRESQL_DATABASE_USER:-}"}"
SONARQUBE_DATABASE_USER="${SONARQUBE_DATABASE_USER:-"${POSTGRESQL_DATABASE_USERNAME:-}"}"
export SONARQUBE_DATABASE_USER="${SONARQUBE_DATABASE_USER:-bn_sonarqube}" # only used during the first initialization
SONARQUBE_DATABASE_PASSWORD="${SONARQUBE_DATABASE_PASSWORD:-"${POSTGRESQL_DATABASE_PASSWORD:-}"}"
export SONARQUBE_DATABASE_PASSWORD="${SONARQUBE_DATABASE_PASSWORD:-}" # only used during the first initialization

# Custom environment variables may be defined below
