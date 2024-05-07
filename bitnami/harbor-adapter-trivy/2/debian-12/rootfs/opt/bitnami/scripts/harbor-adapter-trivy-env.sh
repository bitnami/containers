#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for harbor-adapter-trivy

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
export MODULE="${MODULE:-harbor-adapter-trivy}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
harbor_adapter_trivy_env_vars=(
    SCANNER_TRIVY_VOLUME_DIR
    SCANNER_TRIVY_CACHE_DIR
    SCANNER_TRIVY_REPORTS_DIR
)
for env_var in "${harbor_adapter_trivy_env_vars[@]}"; do
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
unset harbor_adapter_trivy_env_vars

# Paths
export SCANNER_TRIVY_BASE_DIR="${BITNAMI_ROOT_DIR}/harbor-adapter-trivy"
export SCANNER_TRIVY_VOLUME_DIR="${SCANNER_TRIVY_VOLUME_DIR:-${BITNAMI_VOLUME_DIR}/harbor-adapter-trivy}"
export SCANNER_TRIVY_CACHE_DIR="${SCANNER_TRIVY_CACHE_DIR:-${SCANNER_TRIVY_VOLUME_DIR}/.cache/trivy}"
export SCANNER_TRIVY_REPORTS_DIR="${SCANNER_TRIVY_REPORTS_DIR:-${SCANNER_TRIVY_VOLUME_DIR}/.cache/reports}"

# System users
export SCANNER_TRIVY_DAEMON_USER="trivy-scanner"
export SCANNER_TRIVY_DAEMON_GROUP="trivy-scanner"

# Custom environment variables may be defined below
