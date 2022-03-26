#!/bin/bash
#
# Environment configuration for reportserver

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
export MODULE="${MODULE:-reportserver}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
reportserver_env_vars=(
    REPORTSERVER_INSTALL_DEMO_DATA
    REPORTSERVER_USERNAME
    REPORTSERVER_PASSWORD
    REPORTSERVER_EMAIL
    REPORTSERVER_FIRST_NAME
    REPORTSERVER_LAST_NAME
    REPORTSERVER_SMTP_HOST
    REPORTSERVER_SMTP_PORT_NUMBER
    REPORTSERVER_SMTP_USER
    REPORTSERVER_SMTP_PASSWORD
    REPORTSERVER_SMTP_PROTOCOL
    REPORTSERVER_DATABASE_HOST
    REPORTSERVER_DATABASE_PORT_NUMBER
    REPORTSERVER_DATABASE_NAME
    REPORTSERVER_DATABASE_USER
    REPORTSERVER_DATABASE_PASSWORD
    TOMCAT_EXTRA_JAVA_OPTS
    REPORTSERVER_INSTALLDEMODATA
    SMTP_HOST
    SMTP_PORT
    REPORTSERVER_SMTP_PORT
    SMTP_USER
    SMTP_PASSWORD
    SMTP_PROTOCOL
    MARIADB_HOST
    MARIADB_PORT_NUMBER
    MARIADB_DATABASE_NAME
    MARIADB_DATABASE_USER
    MARIADB_DATABASE_PASSWORD
)
for env_var in "${reportserver_env_vars[@]}"; do
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
unset reportserver_env_vars

# Paths
export REPORTSERVER_BASE_DIR="${BITNAMI_ROOT_DIR}/reportserver"
export REPORTSERVER_CONF_DIR="${REPORTSERVER_BASE_DIR}/WEB-INF/classes"
export REPORTSERVER_CONF_FILE="${REPORTSERVER_CONF_DIR}/reportserver.properties"

# System users (when running with a privileged user)
export REPORTSERVER_DAEMON_USER="tomcat"
export REPORTSERVER_DAEMON_GROUP="tomcat"

# ReportServer configuration
REPORTSERVER_INSTALL_DEMO_DATA="${REPORTSERVER_INSTALL_DEMO_DATA:-"${REPORTSERVER_INSTALLDEMODATA:-}"}"
export REPORTSERVER_INSTALL_DEMO_DATA="${REPORTSERVER_INSTALL_DEMO_DATA:-no}" # only used during the first initialization

# ReportServer credentials
export REPORTSERVER_USERNAME="${REPORTSERVER_USERNAME:-user}" # only used during the first initialization
export REPORTSERVER_PASSWORD="${REPORTSERVER_PASSWORD:-bitnami}" # only used during the first initialization
export REPORTSERVER_EMAIL="${REPORTSERVER_EMAIL:-user@example.com}" # only used during the first initialization
export REPORTSERVER_FIRST_NAME="${REPORTSERVER_FIRST_NAME:-FirstName}" # only used during the first initialization
export REPORTSERVER_LAST_NAME="${REPORTSERVER_LAST_NAME:-LastName}" # only used during the first initialization

# ReportServer SMTP credentials
REPORTSERVER_SMTP_HOST="${REPORTSERVER_SMTP_HOST:-"${SMTP_HOST:-}"}"
export REPORTSERVER_SMTP_HOST="${REPORTSERVER_SMTP_HOST:-}"
REPORTSERVER_SMTP_PORT_NUMBER="${REPORTSERVER_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
REPORTSERVER_SMTP_PORT_NUMBER="${REPORTSERVER_SMTP_PORT_NUMBER:-"${REPORTSERVER_SMTP_PORT:-}"}"
export REPORTSERVER_SMTP_PORT_NUMBER="${REPORTSERVER_SMTP_PORT_NUMBER:-}"
REPORTSERVER_SMTP_USER="${REPORTSERVER_SMTP_USER:-"${SMTP_USER:-}"}"
export REPORTSERVER_SMTP_USER="${REPORTSERVER_SMTP_USER:-}"
REPORTSERVER_SMTP_PASSWORD="${REPORTSERVER_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export REPORTSERVER_SMTP_PASSWORD="${REPORTSERVER_SMTP_PASSWORD:-}"
REPORTSERVER_SMTP_PROTOCOL="${REPORTSERVER_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
export REPORTSERVER_SMTP_PROTOCOL="${REPORTSERVER_SMTP_PROTOCOL:-tls}"

# Database configuration
export REPORTSERVER_DEFAULT_DATABASE_HOST="mariadb" # only used at build time
REPORTSERVER_DATABASE_HOST="${REPORTSERVER_DATABASE_HOST:-"${MARIADB_HOST:-}"}"
export REPORTSERVER_DATABASE_HOST="${REPORTSERVER_DATABASE_HOST:-$REPORTSERVER_DEFAULT_DATABASE_HOST}" # only used during the first initialization
REPORTSERVER_DATABASE_PORT_NUMBER="${REPORTSERVER_DATABASE_PORT_NUMBER:-"${MARIADB_PORT_NUMBER:-}"}"
export REPORTSERVER_DATABASE_PORT_NUMBER="${REPORTSERVER_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
REPORTSERVER_DATABASE_NAME="${REPORTSERVER_DATABASE_NAME:-"${MARIADB_DATABASE_NAME:-}"}"
export REPORTSERVER_DATABASE_NAME="${REPORTSERVER_DATABASE_NAME:-bitnami_reportserver}" # only used during the first initialization
REPORTSERVER_DATABASE_USER="${REPORTSERVER_DATABASE_USER:-"${MARIADB_DATABASE_USER:-}"}"
export REPORTSERVER_DATABASE_USER="${REPORTSERVER_DATABASE_USER:-bn_reportserver}" # only used during the first initialization
REPORTSERVER_DATABASE_PASSWORD="${REPORTSERVER_DATABASE_PASSWORD:-"${MARIADB_DATABASE_PASSWORD:-}"}"
export REPORTSERVER_DATABASE_PASSWORD="${REPORTSERVER_DATABASE_PASSWORD:-}" # only used during the first initialization

# Tomcat extra options
export TOMCAT_EXTRA_JAVA_OPTS="${TOMCAT_EXTRA_JAVA_OPTS:-$TOMCAT_EXTRA_JAVA_OPTS -Drs.configdir=${REPORTSERVER_CONF_DIR}}"

# Custom environment variables may be defined below
