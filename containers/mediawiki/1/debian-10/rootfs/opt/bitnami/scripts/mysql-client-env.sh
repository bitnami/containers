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
    MYSQL_CLIENT_DATABASE_AUTHENTICATION_PLUGIN
    MYSQL_CLIENT_DATABASE_HOST
    MYSQL_CLIENT_DATABASE_PORT_NUMBER
    MYSQL_CLIENT_DATABASE_ROOT_USER
    MYSQL_CLIENT_DATABASE_ROOT_PASSWORD
    MYSQL_CLIENT_CREATE_DATABASE_NAME
    MYSQL_CLIENT_CREATE_DATABASE_USER
    MYSQL_CLIENT_CREATE_DATABASE_PASSWORD
    MYSQL_CLIENT_CREATE_DATABASE_CHARACTER_SET
    MYSQL_CLIENT_CREATE_DATABASE_COLLATE
    MYSQL_CLIENT_TLS_ENABLED

)
for env_var in "${mysql_env_vars[@]}"; do
    file_env_var="${env_var}_FILE"
    if [[ -n "${!file_env_var:-}" ]]; then
        export "${env_var}=$(< "${!file_env_var}")"
        unset "${file_env_var}"
    fi
done
unset mysql_env_vars
export DB_FLAVOR="mariadb"

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
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"
export MYSQL_CLIENT_DATABASE_AUTHENTICATION_PLUGIN="${MYSQL_CLIENT_DATABASE_AUTHENTICATION_PLUGIN:-}"
export DB_DATABASE_AUTHENTICATION_PLUGIN="$MYSQL_CLIENT_DATABASE_AUTHENTICATION_PLUGIN"
export MYSQL_CLIENT_DATABASE_HOST="${MYSQL_CLIENT_DATABASE_HOST:-mariadb}"
export DB_DATABASE_HOST="$MYSQL_CLIENT_DATABASE_HOST"
export MYSQL_CLIENT_DATABASE_PORT_NUMBER="${MYSQL_CLIENT_DATABASE_PORT_NUMBER:-3306}"
export DB_DATABASE_PORT_NUMBER="$MYSQL_CLIENT_DATABASE_PORT_NUMBER"
export MYSQL_CLIENT_DATABASE_ROOT_USER="${MYSQL_CLIENT_DATABASE_ROOT_USER:-root}" # only used during the first initialization
export DB_ROOT_USER="$MYSQL_CLIENT_DATABASE_ROOT_USER"
export MYSQL_CLIENT_DATABASE_ROOT_PASSWORD="${MYSQL_CLIENT_DATABASE_ROOT_PASSWORD:-}" # only used during the first initialization
export DB_ROOT_PASSWORD="$MYSQL_CLIENT_DATABASE_ROOT_PASSWORD"
export MYSQL_CLIENT_CREATE_DATABASE_NAME="${MYSQL_CLIENT_CREATE_DATABASE_NAME:-}" # only used during the first initialization
export DB_CREATE_DATABASE_NAME="$MYSQL_CLIENT_CREATE_DATABASE_NAME"
export MYSQL_CLIENT_CREATE_DATABASE_USER="${MYSQL_CLIENT_CREATE_DATABASE_USER:-}"
export DB_CREATE_DATABASE_USER="$MYSQL_CLIENT_CREATE_DATABASE_USER"
export MYSQL_CLIENT_CREATE_DATABASE_PASSWORD="${MYSQL_CLIENT_CREATE_DATABASE_PASSWORD:-}"
export DB_CREATE_DATABASE_PASSWORD="$MYSQL_CLIENT_CREATE_DATABASE_PASSWORD"
export MYSQL_CLIENT_CREATE_DATABASE_CHARACTER_SET="${MYSQL_CLIENT_CREATE_DATABASE_CHARACTER_SET:-}"
export DB_CREATE_DATABASE_CHARACTER_SET="$MYSQL_CLIENT_CREATE_DATABASE_CHARACTER_SET"
export MYSQL_CLIENT_CREATE_DATABASE_COLLATE="${MYSQL_CLIENT_CREATE_DATABASE_COLLATE:-}"
export DB_CREATE_DATABASE_COLLATE="$MYSQL_CLIENT_CREATE_DATABASE_COLLATE"
export MYSQL_CLIENT_TLS_ENABLED="${MYSQL_CLIENT_TLS_ENABLED:-no}"
export DB_TLS_ENABLED="$MYSQL_CLIENT_TLS_ENABLED"

# Custom environment variables may be defined below
