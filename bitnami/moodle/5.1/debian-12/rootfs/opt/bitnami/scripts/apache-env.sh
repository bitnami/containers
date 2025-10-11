#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for apache

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
export MODULE="${MODULE:-apache}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
apache_env_vars=(
    APACHE_HTTP_PORT_NUMBER
    APACHE_HTTPS_PORT_NUMBER
    APACHE_SERVER_TOKENS
    APACHE_HTTP_PORT
    APACHE_HTTPS_PORT
)
for env_var in "${apache_env_vars[@]}"; do
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
unset apache_env_vars
export WEB_SERVER_TYPE="apache"

# Paths
export APACHE_BASE_DIR="${BITNAMI_ROOT_DIR}/apache"
export APACHE_BIN_DIR="${APACHE_BASE_DIR}/bin"
export APACHE_CONF_DIR="${APACHE_BASE_DIR}/conf"
export APACHE_DEFAULT_CONF_DIR="${APACHE_BASE_DIR}/conf.default"
export APACHE_HTDOCS_DIR="${APACHE_BASE_DIR}/htdocs"
export APACHE_TMP_DIR="${APACHE_BASE_DIR}/var/run"
export APACHE_LOGS_DIR="${APACHE_BASE_DIR}/logs"
export APACHE_VHOSTS_DIR="${APACHE_CONF_DIR}/vhosts"
export APACHE_HTACCESS_DIR="${APACHE_VHOSTS_DIR}/htaccess"
export APACHE_CONF_FILE="${APACHE_CONF_DIR}/httpd.conf"
export APACHE_PID_FILE="${APACHE_TMP_DIR}/httpd.pid"
export PATH="${APACHE_BIN_DIR}:${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# System users (when running with a privileged user)
export APACHE_DAEMON_USER="daemon"
export WEB_SERVER_DAEMON_USER="$APACHE_DAEMON_USER"
export APACHE_DAEMON_GROUP="daemon"
export WEB_SERVER_DAEMON_GROUP="$APACHE_DAEMON_GROUP"
export WEB_SERVER_GROUP="$APACHE_DAEMON_GROUP"

# Apache configuration
export APACHE_DEFAULT_HTTP_PORT_NUMBER="8080"
export WEB_SERVER_DEFAULT_HTTP_PORT_NUMBER="$APACHE_DEFAULT_HTTP_PORT_NUMBER" # only used at build time
export APACHE_DEFAULT_HTTPS_PORT_NUMBER="8443"
export WEB_SERVER_DEFAULT_HTTPS_PORT_NUMBER="$APACHE_DEFAULT_HTTPS_PORT_NUMBER" # only used at build time
APACHE_HTTP_PORT_NUMBER="${APACHE_HTTP_PORT_NUMBER:-"${APACHE_HTTP_PORT:-}"}"
export APACHE_HTTP_PORT_NUMBER="${APACHE_HTTP_PORT_NUMBER:-}"
export WEB_SERVER_HTTP_PORT_NUMBER="$APACHE_HTTP_PORT_NUMBER"
APACHE_HTTPS_PORT_NUMBER="${APACHE_HTTPS_PORT_NUMBER:-"${APACHE_HTTPS_PORT:-}"}"
export APACHE_HTTPS_PORT_NUMBER="${APACHE_HTTPS_PORT_NUMBER:-}"
export WEB_SERVER_HTTPS_PORT_NUMBER="$APACHE_HTTPS_PORT_NUMBER"
export APACHE_SERVER_TOKENS="${APACHE_SERVER_TOKENS:-Prod}"

# Custom environment variables may be defined below
