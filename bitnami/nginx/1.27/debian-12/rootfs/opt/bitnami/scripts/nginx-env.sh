#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for nginx

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
export MODULE="${MODULE:-nginx}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
nginx_env_vars=(
    NGINX_HTTP_PORT_NUMBER
    NGINX_HTTPS_PORT_NUMBER
    NGINX_SKIP_SAMPLE_CERTS
    NGINX_ENABLE_STREAM
    NGINX_ENABLE_ABSOLUTE_REDIRECT
    NGINX_ENABLE_PORT_IN_REDIRECT
)
for env_var in "${nginx_env_vars[@]}"; do
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
unset nginx_env_vars
export WEB_SERVER_TYPE="nginx"

# Paths
export NGINX_BASE_DIR="${BITNAMI_ROOT_DIR}/nginx"
export NGINX_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/nginx"
export NGINX_SBIN_DIR="${NGINX_BASE_DIR}/sbin"
export NGINX_CONF_DIR="${NGINX_BASE_DIR}/conf"
export NGINX_DEFAULT_CONF_DIR="${NGINX_BASE_DIR}/conf.default"
export NGINX_HTDOCS_DIR="${NGINX_BASE_DIR}/html"
export NGINX_TMP_DIR="${NGINX_BASE_DIR}/tmp"
export NGINX_LOGS_DIR="${NGINX_BASE_DIR}/logs"
export NGINX_SERVER_BLOCKS_DIR="${NGINX_CONF_DIR}/server_blocks"
export NGINX_STREAM_SERVER_BLOCKS_DIR="${NGINX_CONF_DIR}/stream_server_blocks"
export NGINX_INITSCRIPTS_DIR="/docker-entrypoint-initdb.d"
export NGINX_CONF_FILE="${NGINX_CONF_DIR}/nginx.conf"
export NGINX_PID_FILE="${NGINX_TMP_DIR}/nginx.pid"
export PATH="${NGINX_SBIN_DIR}:${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# System users (when running with a privileged user)
export NGINX_DAEMON_USER="daemon"
export WEB_SERVER_DAEMON_USER="$NGINX_DAEMON_USER"
export NGINX_DAEMON_GROUP="daemon"
export WEB_SERVER_DAEMON_GROUP="$NGINX_DAEMON_GROUP"
export NGINX_DEFAULT_HTTP_PORT_NUMBER="8080"
export WEB_SERVER_DEFAULT_HTTP_PORT_NUMBER="$NGINX_DEFAULT_HTTP_PORT_NUMBER" # only used at build time
export NGINX_DEFAULT_HTTPS_PORT_NUMBER="8443"
export WEB_SERVER_DEFAULT_HTTPS_PORT_NUMBER="$NGINX_DEFAULT_HTTPS_PORT_NUMBER" # only used at build time

# NGINX configuration
export NGINX_HTTP_PORT_NUMBER="${NGINX_HTTP_PORT_NUMBER:-}"
export WEB_SERVER_HTTP_PORT_NUMBER="$NGINX_HTTP_PORT_NUMBER"
export NGINX_HTTPS_PORT_NUMBER="${NGINX_HTTPS_PORT_NUMBER:-}"
export WEB_SERVER_HTTPS_PORT_NUMBER="$NGINX_HTTPS_PORT_NUMBER"
export NGINX_SKIP_SAMPLE_CERTS="${NGINX_SKIP_SAMPLE_CERTS:-false}"
export NGINX_ENABLE_STREAM="${NGINX_ENABLE_STREAM:-no}"
export NGINX_ENABLE_ABSOLUTE_REDIRECT="${NGINX_ENABLE_ABSOLUTE_REDIRECT:-no}"
export NGINX_ENABLE_PORT_IN_REDIRECT="${NGINX_ENABLE_PORT_IN_REDIRECT:-no}"

# Custom environment variables may be defined below
