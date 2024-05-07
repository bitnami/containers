#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for kong

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
export MODULE="${MODULE:-kong}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
kong_env_vars=(
    KONG_MIGRATE
    KONG_EXIT_AFTER_MIGRATE
    KONG_PROXY_LISTEN_ADDRESS
    KONG_PROXY_HTTP_PORT_NUMBER
    KONG_PROXY_HTTPS_PORT_NUMBER
    KONG_ADMIN_LISTEN_ADDRESS
    KONG_ADMIN_HTTP_PORT_NUMBER
    KONG_ADMIN_HTTPS_PORT_NUMBER
    KONG_NGINX_DAEMON
    KONG_PROXY_LISTEN
    KONG_PROXY_LISTEN_OVERRIDE
    KONG_ADMIN_LISTEN
    KONG_ADMIN_LISTEN_OVERRIDE
    KONG_DATABASE
    KONG_PG_PASSWORD
)
for env_var in "${kong_env_vars[@]}"; do
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
unset kong_env_vars

# Paths
export KONG_BASE_DIR="${BITNAMI_ROOT_DIR}/kong"
export KONG_CONF_DIR="${KONG_BASE_DIR}/conf"
export KONG_DEFAULT_CONF_DIR="${KONG_BASE_DIR}/conf.default"
export KONG_CONF_FILE="${KONG_CONF_DIR}/kong.conf"
export KONG_DEFAULT_CONF_FILE="${KONG_CONF_DIR}/kong.conf.default"
export KONG_INITSCRIPTS_DIR="/docker-entrypoint-initdb.d"
export KONG_SERVER_DIR="${KONG_BASE_DIR}/server"
export KONG_PREFIX="${KONG_SERVER_DIR}"
export KONG_DEFAULT_SERVER_DIR="${KONG_BASE_DIR}/server.default"
export KONG_LOGS_DIR="${KONG_SERVER_DIR}/logs"
export PATH="${KONG_BASE_DIR}/bin:${KONG_BASE_DIR}/openresty/bin:${KONG_BASE_DIR}/openresty/nginx/sbin:${KONG_BASE_DIR}/luarocks/bin:${PATH}"

# System users (when running with a privileged user)
export KONG_DAEMON_USER="kong"
export KONG_DAEMON_GROUP="kong"

# Kong cluster creation settings
export KONG_MIGRATE="${KONG_MIGRATE:-no}"
export KONG_EXIT_AFTER_MIGRATE="${KONG_EXIT_AFTER_MIGRATE:-no}"

# Kong interface settings
export KONG_PROXY_LISTEN_ADDRESS="${KONG_PROXY_LISTEN_ADDRESS:-0.0.0.0}"
export KONG_PROXY_HTTP_PORT_NUMBER="${KONG_PROXY_HTTP_PORT_NUMBER:-8000}"
export KONG_PROXY_HTTPS_PORT_NUMBER="${KONG_PROXY_HTTPS_PORT_NUMBER:-8443}"
export KONG_ADMIN_LISTEN_ADDRESS="${KONG_ADMIN_LISTEN_ADDRESS:-0.0.0.0}"
export KONG_ADMIN_HTTP_PORT_NUMBER="${KONG_ADMIN_HTTP_PORT_NUMBER:-8001}"
export KONG_ADMIN_HTTPS_PORT_NUMBER="${KONG_ADMIN_HTTPS_PORT_NUMBER:-8444}"

# Kong native settings
export KONG_NGINX_DAEMON="${KONG_NGINX_DAEMON:-off}"
export KONG_PROXY_LISTEN="${KONG_PROXY_LISTEN:-${KONG_PROXY_LISTEN_ADDRESS}:${KONG_PROXY_HTTP_PORT_NUMBER}, ${KONG_PROXY_LISTEN_ADDRESS}:${KONG_PROXY_HTTPS_PORT_NUMBER} ssl}"
export KONG_PROXY_LISTEN_OVERRIDE="${KONG_PROXY_LISTEN_OVERRIDE:-no}"
export KONG_ADMIN_LISTEN="${KONG_ADMIN_LISTEN:-${KONG_ADMIN_LISTEN_ADDRESS}:${KONG_ADMIN_HTTP_PORT_NUMBER}, ${KONG_ADMIN_LISTEN_ADDRESS}:${KONG_ADMIN_HTTPS_PORT_NUMBER} ssl}"
export KONG_ADMIN_LISTEN_OVERRIDE="${KONG_ADMIN_LISTEN_OVERRIDE:-no}"
export KONG_DATABASE="${KONG_DATABASE:-postgres}"
export KONG_PG_PASSWORD="${KONG_PG_PASSWORD:-}"

# Custom environment variables may be defined below
