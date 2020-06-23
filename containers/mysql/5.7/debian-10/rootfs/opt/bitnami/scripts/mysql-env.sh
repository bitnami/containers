#!/bin/bash
#
# Environment configuration for mysql

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-mysql}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
mysql_env_vars=(
    ALLOW_EMPTY_PASSWORD
    MYSQL_AUTHENTICATION_PLUGIN
    MYSQL_ROOT_USER
    MYSQL_ROOT_PASSWORD
    MYSQL_USER
    MYSQL_PASSWORD
    MYSQL_DATABASE
    MYSQL_MASTER_HOST
    MYSQL_MASTER_PORT_NUMBER
    MYSQL_MASTER_ROOT_USER
    MYSQL_MASTER_ROOT_PASSWORD
    MYSQL_REPLICATION_USER
    MYSQL_REPLICATION_PASSWORD
    MYSQL_PORT_NUMBER
    MYSQL_REPLICATION_MODE
    MYSQL_EXTRA_FLAGS
    MYSQL_INIT_SLEEP_TIME
    MYSQL_CHARACTER_SET
    MYSQL_COLLATE
    MYSQL_BIND_ADDRESS
    MYSQL_SQL_MODE
    MYSQL_IS_DEDICATED_SERVER

)
for env_var in "${mysql_env_vars[@]}"; do
    file_env_var="${env_var}_FILE"
    if [[ -n "${!file_env_var:-}" ]]; then
        export "${env_var}=$(< "${!file_env_var}")"
        unset "${file_env_var}"
    fi
done
unset mysql_env_vars
export DB_FLAVOR="mysql"

# Paths
export DB_BASE_DIR="${BITNAMI_ROOT_DIR}/mysql"
export DB_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/mysql"
export DB_DATA_DIR="${DB_VOLUME_DIR}/data"
export DB_BIN_DIR="${DB_BASE_DIR}/bin"
export DB_SBIN_DIR="${DB_BASE_DIR}/bin"
export DB_CONF_DIR="${DB_BASE_DIR}/conf"
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
export MYSQL_DEFAULT_PORT_NUMBER="3306" # only used at build time
export DB_DEFAULT_PORT_NUMBER="$MYSQL_DEFAULT_PORT_NUMBER"
export MYSQL_DEFAULT_CHARACTER_SET="utf8" # only used at build time
export DB_DEFAULT_CHARACTER_SET="$MYSQL_DEFAULT_CHARACTER_SET"
export MYSQL_DEFAULT_COLLATE="utf8_general_ci" # only used at build time
export DB_DEFAULT_COLLATE="$MYSQL_DEFAULT_COLLATE"
export MYSQL_DEFAULT_BIND_ADDRESS="0.0.0.0" # only used at build time
export DB_DEFAULT_BIND_ADDRESS="$MYSQL_DEFAULT_BIND_ADDRESS"

# MySQL authentication.
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"
export MYSQL_AUTHENTICATION_PLUGIN="${MYSQL_AUTHENTICATION_PLUGIN:-}"
export DB_AUTHENTICATION_PLUGIN="$MYSQL_AUTHENTICATION_PLUGIN"
export MYSQL_ROOT_USER="${MYSQL_ROOT_USER:-root}" # only used during the first initialization
export DB_ROOT_USER="$MYSQL_ROOT_USER"
export MYSQL_ROOT_PASSWORD="${MYSQL_ROOT_PASSWORD:-}" # only used during the first initialization
export DB_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD"
export MYSQL_USER="${MYSQL_USER:-}" # only used during the first initialization
export DB_USER="$MYSQL_USER"
export MYSQL_PASSWORD="${MYSQL_PASSWORD:-}" # only used during the first initialization
export DB_PASSWORD="$MYSQL_PASSWORD"
export MYSQL_DATABASE="${MYSQL_DATABASE:-}" # only used during the first initialization
export DB_DATABASE="$MYSQL_DATABASE"
export MYSQL_MASTER_HOST="${MYSQL_MASTER_HOST:-}" # only used during the first initialization
export DB_MASTER_HOST="$MYSQL_MASTER_HOST"
export MYSQL_MASTER_PORT_NUMBER="${MYSQL_MASTER_PORT_NUMBER:-3306}" # only used during the first initialization
export DB_MASTER_PORT_NUMBER="$MYSQL_MASTER_PORT_NUMBER"
export MYSQL_MASTER_ROOT_USER="${MYSQL_MASTER_ROOT_USER:-root}" # only used during the first initialization
export DB_MASTER_ROOT_USER="$MYSQL_MASTER_ROOT_USER"
export MYSQL_MASTER_ROOT_PASSWORD="${MYSQL_MASTER_ROOT_PASSWORD:-}" # only used during the first initialization
export DB_MASTER_ROOT_PASSWORD="$MYSQL_MASTER_ROOT_PASSWORD"
export MYSQL_REPLICATION_USER="${MYSQL_REPLICATION_USER:-}" # only used during the first initialization
export DB_REPLICATION_USER="$MYSQL_REPLICATION_USER"
export MYSQL_REPLICATION_PASSWORD="${MYSQL_REPLICATION_PASSWORD:-}" # only used during the first initialization
export DB_REPLICATION_PASSWORD="$MYSQL_REPLICATION_PASSWORD"

# Settings
export MYSQL_PORT_NUMBER="${MYSQL_PORT_NUMBER:-}"
export DB_PORT_NUMBER="$MYSQL_PORT_NUMBER"
export MYSQL_REPLICATION_MODE="${MYSQL_REPLICATION_MODE:-}"
export DB_REPLICATION_MODE="$MYSQL_REPLICATION_MODE"
export MYSQL_EXTRA_FLAGS="${MYSQL_EXTRA_FLAGS:-}"
export DB_EXTRA_FLAGS="$MYSQL_EXTRA_FLAGS"
export MYSQL_INIT_SLEEP_TIME="${MYSQL_INIT_SLEEP_TIME:-}"
export DB_INIT_SLEEP_TIME="$MYSQL_INIT_SLEEP_TIME"
export MYSQL_CHARACTER_SET="${MYSQL_CHARACTER_SET:-}"
export DB_CHARACTER_SET="$MYSQL_CHARACTER_SET"
# MYSQL_COLLATION is deprecated in favor of MYSQL_COLLATE
MYSQL_COLLATE="${MYSQL_COLLATE:-"${MYSQL_COLLATION:-}"}"
export MYSQL_COLLATE="${MYSQL_COLLATE:-}"
export DB_COLLATE="$MYSQL_COLLATE"
export MYSQL_BIND_ADDRESS="${MYSQL_BIND_ADDRESS:-}"
export DB_BIND_ADDRESS="$MYSQL_BIND_ADDRESS"
export MYSQL_SQL_MODE="${MYSQL_SQL_MODE:-}"
export DB_SQL_MODE="$MYSQL_SQL_MODE"
export MYSQL_IS_DEDICATED_SERVER="${MYSQL_IS_DEDICATED_SERVER:-}"
export DB_IS_DEDICATED_SERVER="$MYSQL_IS_DEDICATED_SERVER"

# Custom environment variables may be defined below
