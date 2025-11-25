#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for mariadb

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
export MODULE="${MODULE:-mariadb}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
mariadb_env_vars=(
    ALLOW_EMPTY_PASSWORD
    MARIADB_AUTHENTICATION_PLUGIN
    MARIADB_ROOT_USER
    MARIADB_ROOT_PASSWORD
    MARIADB_USER
    MARIADB_PASSWORD
    MARIADB_DATABASE
    MARIADB_MASTER_HOST
    MARIADB_MASTER_PORT_NUMBER
    MARIADB_MASTER_ROOT_USER
    MARIADB_MASTER_ROOT_PASSWORD
    MARIADB_MASTER_DELAY
    MARIADB_REPLICATION_USER
    MARIADB_REPLICATION_PASSWORD
    MARIADB_PORT_NUMBER
    MARIADB_REPLICATION_MODE
    MARIADB_REPLICATION_SLAVE_DUMP
    MARIADB_EXTRA_FLAGS
    MARIADB_INIT_SLEEP_TIME
    MARIADB_CHARACTER_SET
    MARIADB_COLLATE
    MARIADB_BIND_ADDRESS
    MARIADB_SQL_MODE
    MARIADB_UPGRADE
    MARIADB_SKIP_TEST_DB
    MARIADB_CLIENT_ENABLE_SSL
    MARIADB_CLIENT_SSL_CA_FILE
    MARIADB_CLIENT_SSL_CERT_FILE
    MARIADB_CLIENT_SSL_KEY_FILE
    MARIADB_CLIENT_EXTRA_FLAGS
    MARIADB_STARTUP_WAIT_RETRIES
    MARIADB_STARTUP_WAIT_SLEEP_TIME
    MARIADB_ENABLE_SLOW_QUERY
    MARIADB_LONG_QUERY_TIME
    DB_ENABLE_SLOW_QUERY
    DB_LONG_QUERY_TIME
)
for env_var in "${mariadb_env_vars[@]}"; do
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
unset mariadb_env_vars
export DB_FLAVOR="mariadb"

# Paths
export DB_BASE_DIR="${BITNAMI_ROOT_DIR}/mariadb"
export DB_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/mariadb"
export DB_DATA_DIR="${DB_VOLUME_DIR}/data"
export DB_BIN_DIR="${DB_BASE_DIR}/bin"
export DB_SBIN_DIR="${DB_BASE_DIR}/sbin"
export DB_CONF_DIR="${DB_BASE_DIR}/conf"
export DB_DEFAULT_CONF_DIR="${DB_BASE_DIR}/conf.default"
export DB_LOGS_DIR="${DB_BASE_DIR}/logs"
export DB_TMP_DIR="${DB_BASE_DIR}/tmp"
export DB_CONF_FILE="${DB_CONF_DIR}/my.cnf"
export DB_PID_FILE="${DB_TMP_DIR}/mysqld.pid"
export DB_SOCKET_FILE="${DB_TMP_DIR}/mysql.sock"
export PATH="${DB_SBIN_DIR}:${DB_BIN_DIR}:/opt/bitnami/common/bin:${PATH}"

# System users (when running with a privileged user)
export DB_DAEMON_USER="mysql"
export DB_DAEMON_GROUP="mysql"

# Default configuration (build-time)
export MARIADB_DEFAULT_PORT_NUMBER="3306"
export DB_DEFAULT_PORT_NUMBER="$MARIADB_DEFAULT_PORT_NUMBER" # only used at build time
export MARIADB_DEFAULT_CHARACTER_SET="utf8mb4"
export DB_DEFAULT_CHARACTER_SET="$MARIADB_DEFAULT_CHARACTER_SET" # only used at build time
export MARIADB_DEFAULT_BIND_ADDRESS="0.0.0.0"
export DB_DEFAULT_BIND_ADDRESS="$MARIADB_DEFAULT_BIND_ADDRESS" # only used at build time

# MariaDB authentication.
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"
export MARIADB_AUTHENTICATION_PLUGIN="${MARIADB_AUTHENTICATION_PLUGIN:-}"
export DB_AUTHENTICATION_PLUGIN="$MARIADB_AUTHENTICATION_PLUGIN"
export MARIADB_ROOT_USER="${MARIADB_ROOT_USER:-root}"
export DB_ROOT_USER="$MARIADB_ROOT_USER" # only used during the first initialization
export MARIADB_ROOT_PASSWORD="${MARIADB_ROOT_PASSWORD:-}"
export DB_ROOT_PASSWORD="$MARIADB_ROOT_PASSWORD" # only used during the first initialization
export MARIADB_USER="${MARIADB_USER:-}"
export DB_USER="$MARIADB_USER" # only used during the first initialization
export MARIADB_PASSWORD="${MARIADB_PASSWORD:-}"
export DB_PASSWORD="$MARIADB_PASSWORD" # only used during the first initialization
export MARIADB_DATABASE="${MARIADB_DATABASE:-}"
export DB_DATABASE="$MARIADB_DATABASE" # only used during the first initialization
export MARIADB_MASTER_HOST="${MARIADB_MASTER_HOST:-}"
export DB_MASTER_HOST="$MARIADB_MASTER_HOST" # only used during the first initialization
export MARIADB_MASTER_PORT_NUMBER="${MARIADB_MASTER_PORT_NUMBER:-3306}"
export DB_MASTER_PORT_NUMBER="$MARIADB_MASTER_PORT_NUMBER" # only used during the first initialization
export MARIADB_MASTER_ROOT_USER="${MARIADB_MASTER_ROOT_USER:-root}"
export DB_MASTER_ROOT_USER="$MARIADB_MASTER_ROOT_USER" # only used during the first initialization
export MARIADB_MASTER_ROOT_PASSWORD="${MARIADB_MASTER_ROOT_PASSWORD:-}"
export DB_MASTER_ROOT_PASSWORD="$MARIADB_MASTER_ROOT_PASSWORD" # only used during the first initialization
export MARIADB_MASTER_DELAY="${MARIADB_MASTER_DELAY:-0}"
export DB_MASTER_DELAY="$MARIADB_MASTER_DELAY" # only used during the first initialization
export MARIADB_REPLICATION_USER="${MARIADB_REPLICATION_USER:-}"
export DB_REPLICATION_USER="$MARIADB_REPLICATION_USER" # only used during the first initialization
export MARIADB_REPLICATION_PASSWORD="${MARIADB_REPLICATION_PASSWORD:-}"
export DB_REPLICATION_PASSWORD="$MARIADB_REPLICATION_PASSWORD" # only used during the first initialization

# Settings
export MARIADB_PORT_NUMBER="${MARIADB_PORT_NUMBER:-}"
export DB_PORT_NUMBER="$MARIADB_PORT_NUMBER"
export MARIADB_REPLICATION_MODE="${MARIADB_REPLICATION_MODE:-}"
export DB_REPLICATION_MODE="$MARIADB_REPLICATION_MODE"
export MARIADB_REPLICATION_SLAVE_DUMP="${MARIADB_REPLICATION_SLAVE_DUMP:-false}"
export DB_REPLICATION_SLAVE_DUMP="$MARIADB_REPLICATION_SLAVE_DUMP"
export MARIADB_EXTRA_FLAGS="${MARIADB_EXTRA_FLAGS:-}"
export DB_EXTRA_FLAGS="$MARIADB_EXTRA_FLAGS"
export MARIADB_INIT_SLEEP_TIME="${MARIADB_INIT_SLEEP_TIME:-}"
export DB_INIT_SLEEP_TIME="$MARIADB_INIT_SLEEP_TIME"
export MARIADB_CHARACTER_SET="${MARIADB_CHARACTER_SET:-}"
export DB_CHARACTER_SET="$MARIADB_CHARACTER_SET"
# MARIADB_COLLATION is deprecated in favor of MARIADB_COLLATE
MARIADB_COLLATE="${MARIADB_COLLATE:-"${MARIADB_COLLATION:-}"}"
export MARIADB_COLLATE="${MARIADB_COLLATE:-}"
export DB_COLLATE="$MARIADB_COLLATE"
export MARIADB_BIND_ADDRESS="${MARIADB_BIND_ADDRESS:-}"
export DB_BIND_ADDRESS="$MARIADB_BIND_ADDRESS"
export MARIADB_SQL_MODE="${MARIADB_SQL_MODE:-}"
export DB_SQL_MODE="$MARIADB_SQL_MODE"
export MARIADB_UPGRADE="${MARIADB_UPGRADE:-AUTO}"
export DB_UPGRADE="$MARIADB_UPGRADE"
export MARIADB_SKIP_TEST_DB="${MARIADB_SKIP_TEST_DB:-no}"
export DB_SKIP_TEST_DB="$MARIADB_SKIP_TEST_DB"
export MARIADB_CLIENT_ENABLE_SSL="${MARIADB_CLIENT_ENABLE_SSL:-no}"
export DB_CLIENT_ENABLE_SSL="$MARIADB_CLIENT_ENABLE_SSL"
export MARIADB_CLIENT_SSL_CA_FILE="${MARIADB_CLIENT_SSL_CA_FILE:-}"
export DB_CLIENT_SSL_CA_FILE="$MARIADB_CLIENT_SSL_CA_FILE"
export MARIADB_CLIENT_SSL_CERT_FILE="${MARIADB_CLIENT_SSL_CERT_FILE:-}"
export DB_CLIENT_SSL_CERT_FILE="$MARIADB_CLIENT_SSL_CERT_FILE"
export MARIADB_CLIENT_SSL_KEY_FILE="${MARIADB_CLIENT_SSL_KEY_FILE:-}"
export DB_CLIENT_SSL_KEY_FILE="$MARIADB_CLIENT_SSL_KEY_FILE"
export MARIADB_CLIENT_EXTRA_FLAGS="${MARIADB_CLIENT_EXTRA_FLAGS:-no}"
export DB_CLIENT_EXTRA_FLAGS="$MARIADB_CLIENT_EXTRA_FLAGS"
export MARIADB_STARTUP_WAIT_RETRIES="${MARIADB_STARTUP_WAIT_RETRIES:-300}"
export DB_STARTUP_WAIT_RETRIES="$MARIADB_STARTUP_WAIT_RETRIES"
export MARIADB_STARTUP_WAIT_SLEEP_TIME="${MARIADB_STARTUP_WAIT_SLEEP_TIME:-2}"
export DB_STARTUP_WAIT_SLEEP_TIME="$MARIADB_STARTUP_WAIT_SLEEP_TIME"
MARIADB_ENABLE_SLOW_QUERY="${MARIADB_ENABLE_SLOW_QUERY:-"${DB_ENABLE_SLOW_QUERY:-}"}"
export MARIADB_ENABLE_SLOW_QUERY="${MARIADB_ENABLE_SLOW_QUERY:-0}"
export DB_ENABLE_SLOW_QUERY="$MARIADB_ENABLE_SLOW_QUERY"
MARIADB_LONG_QUERY_TIME="${MARIADB_LONG_QUERY_TIME:-"${DB_LONG_QUERY_TIME:-}"}"
export MARIADB_LONG_QUERY_TIME="${MARIADB_LONG_QUERY_TIME:-10.0}"
export DB_LONG_QUERY_TIME="$MARIADB_LONG_QUERY_TIME"

# Custom environment variables may be defined below
