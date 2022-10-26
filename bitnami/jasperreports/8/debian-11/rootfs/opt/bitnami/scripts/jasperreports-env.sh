#!/bin/bash
#
# Environment configuration for jasperreports

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
export MODULE="${MODULE:-jasperreports}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
jasperreports_env_vars=(
    JASPERREPORTS_DATA_TO_PERSIST
    JASPERREPORTS_HOST
    JASPERREPORTS_SKIP_BOOTSTRAP
    JASPERREPORTS_USE_ROOT_URL
    JASPERREPORTS_USERNAME
    JASPERREPORTS_PASSWORD
    JASPERREPORTS_EMAIL
    JASPERREPORTS_SMTP_HOST
    JASPERREPORTS_SMTP_PORT_NUMBER
    JASPERREPORTS_SMTP_USER
    JASPERREPORTS_SMTP_PASSWORD
    JASPERREPORTS_SMTP_PROTOCOL
    JASPERREPORTS_SMTP_EMAIL
    JASPERREPORTS_DATABASE_TYPE
    JASPERREPORTS_DATABASE_HOST
    JASPERREPORTS_DATABASE_PORT_NUMBER
    JASPERREPORTS_DATABASE_NAME
    JASPERREPORTS_DATABASE_USER
    JASPERREPORTS_DATABASE_PASSWORD
    SMTP_HOST
    SMTP_PORT
    JASPERREPORTS_SMTP_PORT
    SMTP_USER
    SMTP_PASSWORD
    SMTP_PROTOCOL
    SMTP_EMAIL
    JASPERREPORTS_SMTP_USER
    MARIADB_HOST
    MARIADB_PORT_NUMBER
    MARIADB_DATABASE_NAME
    MARIADB_DATABASE_USER
    MARIADB_DATABASE_PASSWORD
)
for env_var in "${jasperreports_env_vars[@]}"; do
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
unset jasperreports_env_vars

# Paths
export JASPERREPORTS_BASE_DIR="${BITNAMI_ROOT_DIR}/jasperreports"
export JASPERREPORTS_CONF_DIR="${JASPERREPORTS_BASE_DIR}/buildomatic"
export JASPERREPORTS_LOGS_DIR="${JASPERREPORTS_BASE_DIR}/WEB-INF/logs"
export JASPERREPORTS_LOG_FILE="${JASPERREPORTS_LOGS_DIR}/jasperserver.log"
export JASPERREPORTS_CONF_FILE="${JASPERREPORTS_CONF_DIR}/default_master.properties"
export PATH="${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# JasperReports persistence configuration
export JASPERREPORTS_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/jasperreports"
export JASPERREPORTS_DATA_TO_PERSIST="${JASPERREPORTS_DATA_TO_PERSIST:-buildomatic/default_master.properties buildomatic/conf_source/db/mysql/db.template.properties buildomatic/conf_source/db/postgresql/db.template.properties .jrsks .jrsksp}"

# System users (when running with a privileged user)
export JASPERREPORTS_DAEMON_USER="tomcat"
export JASPERREPORTS_DAEMON_GROUP="tomcat"

# JasperReports configuration
export JASPERREPORTS_HOST="${JASPERREPORTS_HOST:-localhost}" # only used during the first initialization
export JASPERREPORTS_SKIP_BOOTSTRAP="${JASPERREPORTS_SKIP_BOOTSTRAP:-no}" # only used during the first initialization
export JASPERREPORTS_USE_ROOT_URL="${JASPERREPORTS_USE_ROOT_URL:-false}" # only used during the first initialization

# JasperReports credentials
export JASPERREPORTS_USERNAME="${JASPERREPORTS_USERNAME:-jasperadmin}" # only used during the first initialization
export JASPERREPORTS_PASSWORD="${JASPERREPORTS_PASSWORD:-bitnami}" # only used during the first initialization
export JASPERREPORTS_EMAIL="${JASPERREPORTS_EMAIL:-user@example.com}" # only used during the first initialization

# JasperReports SMTP credentials
JASPERREPORTS_SMTP_HOST="${JASPERREPORTS_SMTP_HOST:-"${SMTP_HOST:-}"}"
export JASPERREPORTS_SMTP_HOST="${JASPERREPORTS_SMTP_HOST:-}" # only used during the first initialization
JASPERREPORTS_SMTP_PORT_NUMBER="${JASPERREPORTS_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
JASPERREPORTS_SMTP_PORT_NUMBER="${JASPERREPORTS_SMTP_PORT_NUMBER:-"${JASPERREPORTS_SMTP_PORT:-}"}"
export JASPERREPORTS_SMTP_PORT_NUMBER="${JASPERREPORTS_SMTP_PORT_NUMBER:-}" # only used during the first initialization
JASPERREPORTS_SMTP_USER="${JASPERREPORTS_SMTP_USER:-"${SMTP_USER:-}"}"
export JASPERREPORTS_SMTP_USER="${JASPERREPORTS_SMTP_USER:-}" # only used during the first initialization
JASPERREPORTS_SMTP_PASSWORD="${JASPERREPORTS_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export JASPERREPORTS_SMTP_PASSWORD="${JASPERREPORTS_SMTP_PASSWORD:-}" # only used during the first initialization
JASPERREPORTS_SMTP_PROTOCOL="${JASPERREPORTS_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
export JASPERREPORTS_SMTP_PROTOCOL="${JASPERREPORTS_SMTP_PROTOCOL:-smtp}" # only used during the first initialization
JASPERREPORTS_SMTP_EMAIL="${JASPERREPORTS_SMTP_EMAIL:-"${SMTP_EMAIL:-}"}"
JASPERREPORTS_SMTP_EMAIL="${JASPERREPORTS_SMTP_EMAIL:-"${JASPERREPORTS_SMTP_USER:-}"}"
export JASPERREPORTS_SMTP_EMAIL="${JASPERREPORTS_SMTP_EMAIL:-fromuser@example.com}" # only used during the first initialization

# Database configuration
export JASPERREPORTS_DATABASE_TYPE="${JASPERREPORTS_DATABASE_TYPE:-mariadb}" # only used during the first initialization
export JASPERREPORTS_DEFAULT_DATABASE_HOST="mariadb" # only used at build time
JASPERREPORTS_DATABASE_HOST="${JASPERREPORTS_DATABASE_HOST:-"${MARIADB_HOST:-}"}"
export JASPERREPORTS_DATABASE_HOST="${JASPERREPORTS_DATABASE_HOST:-$JASPERREPORTS_DEFAULT_DATABASE_HOST}" # only used during the first initialization
JASPERREPORTS_DATABASE_PORT_NUMBER="${JASPERREPORTS_DATABASE_PORT_NUMBER:-"${MARIADB_PORT_NUMBER:-}"}"
export JASPERREPORTS_DATABASE_PORT_NUMBER="${JASPERREPORTS_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
JASPERREPORTS_DATABASE_NAME="${JASPERREPORTS_DATABASE_NAME:-"${MARIADB_DATABASE_NAME:-}"}"
export JASPERREPORTS_DATABASE_NAME="${JASPERREPORTS_DATABASE_NAME:-bitnami_jasperreports}" # only used during the first initialization
JASPERREPORTS_DATABASE_USER="${JASPERREPORTS_DATABASE_USER:-"${MARIADB_DATABASE_USER:-}"}"
export JASPERREPORTS_DATABASE_USER="${JASPERREPORTS_DATABASE_USER:-bn_jasperreports}" # only used during the first initialization
JASPERREPORTS_DATABASE_PASSWORD="${JASPERREPORTS_DATABASE_PASSWORD:-"${MARIADB_DATABASE_PASSWORD:-}"}"
export JASPERREPORTS_DATABASE_PASSWORD="${JASPERREPORTS_DATABASE_PASSWORD:-}" # only used during the first initialization

# Custom environment variables may be defined below
