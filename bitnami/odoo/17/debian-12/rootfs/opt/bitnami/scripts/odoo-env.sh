#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for odoo

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
export MODULE="${MODULE:-odoo}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
odoo_env_vars=(
    ODOO_DATA_TO_PERSIST
    ODOO_PORT_NUMBER
    ODOO_LONGPOLLING_PORT_NUMBER
    ODOO_SKIP_BOOTSTRAP
    ODOO_SKIP_MODULES_UPDATE
    ODOO_LOAD_DEMO_DATA
    ODOO_LIST_DB
    ODOO_EMAIL
    ODOO_PASSWORD
    ODOO_SMTP_HOST
    ODOO_SMTP_PORT_NUMBER
    ODOO_SMTP_USER
    ODOO_SMTP_PASSWORD
    ODOO_SMTP_PROTOCOL
    ODOO_DATABASE_HOST
    ODOO_DATABASE_PORT_NUMBER
    ODOO_DATABASE_NAME
    ODOO_DATABASE_USER
    ODOO_DATABASE_PASSWORD
    ODOO_DATABASE_FILTER
    SMTP_HOST
    SMTP_PORT
    ODOO_SMTP_PORT
    SMTP_USER
    SMTP_PASSWORD
    SMTP_PROTOCOL
    POSTGRESQL_HOST
    POSTGRESQL_PORT_NUMBER
    POSTGRESQL_DATABASE_NAME
    POSTGRESQL_DATABASE_USER
    POSTGRESQL_DATABASE_USERNAME
    POSTGRESQL_DATABASE_PASSWORD
)
for env_var in "${odoo_env_vars[@]}"; do
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
unset odoo_env_vars

# Paths
export ODOO_BASE_DIR="${BITNAMI_ROOT_DIR}/odoo"
export ODOO_BIN_DIR="${ODOO_BASE_DIR}/bin"
export ODOO_CONF_DIR="${ODOO_BASE_DIR}/conf"
export ODOO_CONF_FILE="${ODOO_CONF_DIR}/odoo.conf"
export ODOO_DATA_DIR="${ODOO_BASE_DIR}/data"
export ODOO_ADDONS_DIR="${ODOO_ADDONS_DIR:-${ODOO_BASE_DIR}/addons}"
export ODOO_TMP_DIR="${ODOO_BASE_DIR}/tmp"
export ODOO_PID_FILE="${ODOO_TMP_DIR}/odoo.pid"
export ODOO_LOGS_DIR="${ODOO_BASE_DIR}/log"
export ODOO_LOG_FILE="${ODOO_LOGS_DIR}/odoo-server.log"

# Odoo persistence configuration
export ODOO_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/odoo"
export ODOO_DATA_TO_PERSIST="${ODOO_DATA_TO_PERSIST:-${ODOO_ADDONS_DIR} ${ODOO_CONF_DIR} ${ODOO_DATA_DIR}}"

# System users (when running with a privileged user)
export ODOO_DAEMON_USER="odoo"
export ODOO_DAEMON_GROUP="odoo"

# Odoo configuration
export ODOO_PORT_NUMBER="${ODOO_PORT_NUMBER:-8069}" # only used during the first initialization
export ODOO_LONGPOLLING_PORT_NUMBER="${ODOO_LONGPOLLING_PORT_NUMBER:-8072}" # only used during the first initialization
export ODOO_SKIP_BOOTSTRAP="${ODOO_SKIP_BOOTSTRAP:-no}" # only used during the first initialization
export ODOO_SKIP_MODULES_UPDATE="${ODOO_SKIP_MODULES_UPDATE:-no}" # only used during the first initialization
export ODOO_LOAD_DEMO_DATA="${ODOO_LOAD_DEMO_DATA:-no}" # only used during the first initialization
export ODOO_LIST_DB="${ODOO_LIST_DB:-no}" # only used during the first initialization

# Odoo credentials
export ODOO_EMAIL="${ODOO_EMAIL:-user@example.com}" # only used during the first initialization
export ODOO_PASSWORD="${ODOO_PASSWORD:-bitnami}" # only used during the first initialization

# Odoo SMTP credentials
ODOO_SMTP_HOST="${ODOO_SMTP_HOST:-"${SMTP_HOST:-}"}"
export ODOO_SMTP_HOST="${ODOO_SMTP_HOST:-}" # only used during the first initialization
ODOO_SMTP_PORT_NUMBER="${ODOO_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
ODOO_SMTP_PORT_NUMBER="${ODOO_SMTP_PORT_NUMBER:-"${ODOO_SMTP_PORT:-}"}"
export ODOO_SMTP_PORT_NUMBER="${ODOO_SMTP_PORT_NUMBER:-}" # only used during the first initialization
ODOO_SMTP_USER="${ODOO_SMTP_USER:-"${SMTP_USER:-}"}"
export ODOO_SMTP_USER="${ODOO_SMTP_USER:-}" # only used during the first initialization
ODOO_SMTP_PASSWORD="${ODOO_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export ODOO_SMTP_PASSWORD="${ODOO_SMTP_PASSWORD:-}" # only used during the first initialization
ODOO_SMTP_PROTOCOL="${ODOO_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
export ODOO_SMTP_PROTOCOL="${ODOO_SMTP_PROTOCOL:-}" # only used during the first initialization

# Database configuration
export ODOO_DEFAULT_DATABASE_HOST="postgresql" # only used at build time
ODOO_DATABASE_HOST="${ODOO_DATABASE_HOST:-"${POSTGRESQL_HOST:-}"}"
export ODOO_DATABASE_HOST="${ODOO_DATABASE_HOST:-$ODOO_DEFAULT_DATABASE_HOST}" # only used during the first initialization
ODOO_DATABASE_PORT_NUMBER="${ODOO_DATABASE_PORT_NUMBER:-"${POSTGRESQL_PORT_NUMBER:-}"}"
export ODOO_DATABASE_PORT_NUMBER="${ODOO_DATABASE_PORT_NUMBER:-5432}" # only used during the first initialization
ODOO_DATABASE_NAME="${ODOO_DATABASE_NAME:-"${POSTGRESQL_DATABASE_NAME:-}"}"
export ODOO_DATABASE_NAME="${ODOO_DATABASE_NAME:-bitnami_odoo}" # only used during the first initialization
ODOO_DATABASE_USER="${ODOO_DATABASE_USER:-"${POSTGRESQL_DATABASE_USER:-}"}"
ODOO_DATABASE_USER="${ODOO_DATABASE_USER:-"${POSTGRESQL_DATABASE_USERNAME:-}"}"
export ODOO_DATABASE_USER="${ODOO_DATABASE_USER:-bn_odoo}" # only used during the first initialization
ODOO_DATABASE_PASSWORD="${ODOO_DATABASE_PASSWORD:-"${POSTGRESQL_DATABASE_PASSWORD:-}"}"
export ODOO_DATABASE_PASSWORD="${ODOO_DATABASE_PASSWORD:-}" # only used during the first initialization
export ODOO_DATABASE_FILTER="${ODOO_DATABASE_FILTER:-}" # only used during the first initialization

# Custom environment variables may be defined below
