#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for harbor-exporter

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
export MODULE="${MODULE:-harbor-exporter}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
harbor_exporter_env_vars=(
    HARBOR_EXPORTER_BASE_DIR
    HARBOR_DATABASE_HOST
    HARBOR_DATABASE_PORT
    HARBOR_DATABASE_USERNAME
    HARBOR_DATABASE_PASSWORD
    HARBOR_DATABASE_DBNAME
    HARBOR_DATABASE_SSLMODE
    HARBOR_SERVICE_SCHEME
    HARBOR_SERVICE_HOST
    HARBOR_SERVICE_PORT
    HARBOR_REDIS_URL
    HARBOR_REDIS_NAMESPACE
    HARBOR_REDIS_TIMEOUT
    HARBOR_EXPORTER_PORT
    HARBOR_EXPORTER_METRICS_PATH
)
for env_var in "${harbor_exporter_env_vars[@]}"; do
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
unset harbor_exporter_env_vars

# Paths
export HARBOR_EXPORTER_BASE_DIR="${HARBOR_EXPORTER_BASE_DIR:-${BITNAMI_ROOT_DIR}/harbor-exporter}"

# System users
export HARBOR_EXPORTER_DAEMON_USER="harbor"
export HARBOR_EXPORTER_DAEMON_GROUP="harbor"

# Core Database Config
export HARBOR_DATABASE_HOST="${HARBOR_DATABASE_HOST:-}"
export HARBOR_DATABASE_PORT="${HARBOR_DATABASE_PORT:-5432}"
export HARBOR_DATABASE_USERNAME="${HARBOR_DATABASE_USERNAME:-}"
export HARBOR_DATABASE_PASSWORD="${HARBOR_DATABASE_PASSWORD:-}"
export HARBOR_DATABASE_DBNAME="${HARBOR_DATABASE_DBNAME:-}"
export HARBOR_DATABASE_SSLMODE="${HARBOR_DATABASE_SSLMODE:-disable}"

# Core Service Config
export HARBOR_SERVICE_SCHEME="${HARBOR_SERVICE_SCHEME:-http}"
export HARBOR_SERVICE_HOST="${HARBOR_SERVICE_HOST:-core}"
export HARBOR_SERVICE_PORT="${HARBOR_SERVICE_PORT:-8080}"

# Job Service Redis Config
export HARBOR_REDIS_URL="${HARBOR_REDIS_URL:-}"
export HARBOR_REDIS_NAMESPACE="${HARBOR_REDIS_NAMESPACE:-harbor_job_service_namespace}"
export HARBOR_REDIS_TIMEOUT="${HARBOR_REDIS_TIMEOUT:-3600}"

# Exporter Config
export HARBOR_EXPORTER_PORT="${HARBOR_EXPORTER_PORT:-9090}"
export HARBOR_EXPORTER_METRICS_PATH="${HARBOR_EXPORTER_METRICS_PATH:-/metrics}"

# Custom environment variables may be defined below
