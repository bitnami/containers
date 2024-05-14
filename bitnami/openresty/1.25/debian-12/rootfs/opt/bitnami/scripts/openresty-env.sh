#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for openresty

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
export MODULE="${MODULE:-openresty}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
openresty_env_vars=(
    OPENRESTY_HTTP_PORT_NUMBER
    OPENRESTY_HTTPS_PORT_NUMBER
    OPENRESTY_FORCE_INITSCRIPTS
)
for env_var in "${openresty_env_vars[@]}"; do
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
unset openresty_env_vars

# Paths
export OPENRESTY_BASE_DIR="${BITNAMI_ROOT_DIR}/openresty"
export OPENRESTY_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/openresty"
export OPENRESTY_BIN_DIR="${OPENRESTY_BASE_DIR}/bin"
export OPENRESTY_CONF_DIR="${OPENRESTY_BASE_DIR}/nginx/conf"
export OPENRESTY_HTDOCS_DIR="${OPENRESTY_BASE_DIR}/nginx/html"
export OPENRESTY_TMP_DIR="${OPENRESTY_BASE_DIR}/nginx/tmp"
export OPENRESTY_LOGS_DIR="${OPENRESTY_BASE_DIR}/nginx/logs"
export OPENRESTY_SERVER_BLOCKS_DIR="${OPENRESTY_CONF_DIR}/nginx/server_blocks"
export OPENRESTY_SITE_DIR="${OPENRESTY_BASE_DIR}/site"
export OPENRESTY_INITSCRIPTS_DIR="/docker-entrypoint-initdb.d"
export OPM_BASE_DIR="/home/openresty"
export OPENRESTY_CONF_FILE="${OPENRESTY_CONF_DIR}/nginx.conf"
export OPENRESTY_PID_FILE="${OPENRESTY_TMP_DIR}/nginx.pid"
export PATH="${OPENRESTY_BIN_DIR}:${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# System users (when running with a privileged user)
export OPENRESTY_DAEMON_USER="daemon"
export OPENRESTY_DAEMON_GROUP="daemon"
export OPENRESTY_DEFAULT_HTTP_PORT_NUMBER="8080" # only used at build time
export OPENRESTY_DEFAULT_HTTPS_PORT_NUMBER="8443" # only used at build time

# OpenResty configuration
export OPENRESTY_HTTP_PORT_NUMBER="${OPENRESTY_HTTP_PORT_NUMBER:-}"
export OPENRESTY_HTTPS_PORT_NUMBER="${OPENRESTY_HTTPS_PORT_NUMBER:-}"
export OPENRESTY_FORCE_INITSCRIPTS="${OPENRESTY_FORCE_INITSCRIPTS:-false}"

# Custom environment variables may be defined below
