#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for ejbca

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
export MODULE="${MODULE:-ejbca}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
ejbca_env_vars=(
    EJBCA_WILDFLY_ADMIN_USER
    EJBCA_WILDFLY_ADMIN_PASSWORD
    EJBCA_SERVER_CERT_FILE
    EJBCA_SERVER_CERT_PASSWORD
    EJBCA_HTTP_PORT_NUMBER
    EJBCA_HTTPS_PORT_NUMBER
    EJBCA_HTTPS_ADVERTISED_PORT_NUMBER
    EJBCA_ADMIN_USERNAME
    EJBCA_ADMIN_PASSWORD
    EJBCA_DATABASE_FLAVOR
    EJBCA_DATABASE_HOST
    EJBCA_DATABASE_PORT
    EJBCA_DATABASE_NAME
    EJBCA_DATABASE_USERNAME
    EJBCA_DATABASE_PASSWORD
    EJBCA_CA_NAME
    JAVA_OPTS
    EJBCA_SMTP_HOST
    EJBCA_SMTP_PORT
    EJBCA_SMTP_FROM_ADDRESS
    EJBCA_SMTP_TLS
    EJBCA_SMTP_USERNAME
    EJBCA_SMTP_PASSWORD
)
for env_var in "${ejbca_env_vars[@]}"; do
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
unset ejbca_env_vars

# Paths
export BITNAMI_VOLUME_DIR="/bitnami"
export EJBCA_BASE_DIR="${BITNAMI_ROOT_DIR}/ejbca"
export EJBCA_BIN_DIR="${EJBCA_BASE_DIR}/bin"
export EJBCA_CONF_DIR="${EJBCA_BASE_DIR}/conf"
export EJBCA_DEFAULT_CONF_DIR="${EJBCA_BASE_DIR}/conf.default"
export EJBCA_TMP_DIR="${EJBCA_BASE_DIR}/tmp"
export EJBCA_INITSCRIPTS_DIR="/docker-entrypoint-initdb.d"
export EJBCA_DATABASE_SCRIPTS_DIR="${EJBCA_BASE_DIR}/sql-scripts"

# Persistence
export EJBCA_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/ejbca"
export EJBCA_WILDFLY_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/wildfly"
export EJBCA_DATA_DIR="${EJBCA_VOLUME_DIR}/tls"

# DB scripts
export EJBCA_DB_SCRIPT_INDEXES="${EJBCA_DATABASE_SCRIPTS_DIR}/create-index-ejbca.sql"
export EJBCA_DB_SCRIPT_TABLES="${EJBCA_DATABASE_SCRIPTS_DIR}/create-tables-ejbca-mysql.sql"

# EJBA deployment
export EJBCA_EAR_FILE="${EJBCA_BASE_DIR}/dist/ejbca.ear"

# Wildfly
export EJBCA_WILDFLY_BASE_DIR="${BITNAMI_ROOT_DIR}/wildfly"
export EJBCA_WILDFLY_STANDALONE_DIR="${EJBCA_WILDFLY_BASE_DIR}/standalone"
export EJBCA_WILDFLY_DEFAULT_STANDALONE_DIR="${EJBCA_WILDFLY_BASE_DIR}/standalone.default"
export EJBCA_WILDFLY_DOMAIN_DIR="${EJBCA_WILDFLY_BASE_DIR}/domain"
export EJBCA_WILDFLY_DEFAULT_DOMAIN_DIR="${EJBCA_WILDFLY_BASE_DIR}/domain.default"
export EJBCA_WILDFLY_TMP_DIR="${EJBCA_WILDFLY_BASE_DIR}/tmp"
export EJBCA_WILDFLY_BIN_DIR="${EJBCA_WILDFLY_BASE_DIR}/bin"
export EJBCA_WILDFLY_CONF_DIR="${EJBCA_WILDFLY_STANDALONE_DIR}/configuration"
export EJBCA_WILDFLY_PID_DIR="${EJBCA_TMP_DIR}"
export EJBCA_WILDFLY_PID_FILE="${EJBCA_WILDFLY_PID_DIR}/wildfly.pid"
export EJBCA_WILDFLY_DEPLOY_DIR="${EJBCA_WILDFLY_STANDALONE_DIR}/deployments"
export EJBCA_WILDFLY_ADMIN_USER="${EJBCA_WILDFLY_ADMIN_USER:-admin}"
export EJBCA_WILDFLY_ADMIN_PASSWORD="${EJBCA_WILDFLY_ADMIN_PASSWORD:-}"
export EJBCA_WILDFLY_TRUSTSTORE_FILE="${EJBCA_WILDFLY_CONF_DIR}/truststore.jks"
export EJBCA_WILDFLY_KEYSTORE_FILE="${EJBCA_WILDFLY_CONF_DIR}/keystore.jks"
export EJBCA_WILDFLY_STANDALONE_CONF_FILE="${EJBCA_WILDFLY_BIN_DIR}/standalone.conf"
export EJBCA_WILDFLY_STANDALONE_XML_FILE="${EJBCA_WILDFLY_CONF_DIR}/standalone.xml"

# Users
export EJBCA_DAEMON_USER="wildfly"
export EJBCA_DAEMON_GROUP="wildfly"

# Keystores
export EJBCA_WILDFLY_KEYSTORE_PASSWORD_FILE="${EJBCA_WILDFLY_TMP_DIR}/keystore.pwd"
export EJBCA_WILDFLY_TRUSTSTORE_PASSWORD_FILE="${EJBCA_WILDFLY_TMP_DIR}/truststore.pwd"
export EJBCA_WILDFLY_ADMIN_PASSWORD_FILE="${EJBCA_WILDFLY_TMP_DIR}/wildfly_admin.pwd"
export EJBCA_SERVER_CERT_FILE="${EJBCA_SERVER_CERT_FILE:-}"
export EJBCA_SERVER_CERT_PASSWORD="${EJBCA_SERVER_CERT_PASSWORD:-}"
export EJBCA_TEMP_CERT="${EJBCA_TMP_DIR}/cacert.der"

# Settings
export EJBCA_HTTP_PORT_NUMBER="${EJBCA_HTTP_PORT_NUMBER:-8080}"
export EJBCA_HTTPS_PORT_NUMBER="${EJBCA_HTTPS_PORT_NUMBER:-8443}"
export EJBCA_HTTPS_ADVERTISED_PORT_NUMBER="${EJBCA_HTTPS_ADVERTISED_PORT_NUMBER:-$EJBCA_HTTPS_PORT_NUMBER}"
export EJBCA_ADMIN_USERNAME="${EJBCA_ADMIN_USERNAME:-superadmin}"
export EJBCA_ADMIN_PASSWORD="${EJBCA_ADMIN_PASSWORD:-Bitnami1234}"
export EJBCA_DATABASE_FLAVOR="${EJBCA_DATABASE_FLAVOR:-mariadb}"
export EJBCA_DATABASE_HOST="${EJBCA_DATABASE_HOST:-}"
export EJBCA_DATABASE_PORT="${EJBCA_DATABASE_PORT:-3306}"
export EJBCA_DATABASE_NAME="${EJBCA_DATABASE_NAME:-}"
export EJBCA_DATABASE_USERNAME="${EJBCA_DATABASE_USERNAME:-}"
export EJBCA_DATABASE_PASSWORD="${EJBCA_DATABASE_PASSWORD:-}"
export EJBCA_CA_NAME="${EJBCA_CA_NAME:-ManagementCA}"
export JAVA_OPTS="${JAVA_OPTS:--Xms2048m -Xmx2048m -Djava.net.preferIPv4Stack=true -Dhibernate.dialect=org.hibernate.dialect.MySQLDialect -Dhibernate.dialect.storage_engine=innodb}"
export EJBCA_SMTP_HOST="${EJBCA_SMTP_HOST:-localhost}"
export EJBCA_SMTP_PORT="${EJBCA_SMTP_PORT:-25}"
export EJBCA_SMTP_FROM_ADDRESS="${EJBCA_SMTP_FROM_ADDRESS:-user@example.com}"
export EJBCA_SMTP_TLS="${EJBCA_SMTP_TLS:-false}"
export EJBCA_SMTP_USERNAME="${EJBCA_SMTP_USERNAME:-}"
export EJBCA_SMTP_PASSWORD="${EJBCA_SMTP_PASSWORD:-}"

# EJBCA environment variables.
export EJBCA_HOME="${EJBCA_BASE_DIR}"
export JAVA_HOME="/opt/bitnami/java"
export JBOSS_HOME="${EJBCA_WILDFLY_BASE_DIR}"
export LAUNCH_JBOSS_IN_BACKGROUND="true"
export JBOSS_PIDFILE="${EJBCA_WILDFLY_PID_FILE}"
export EJBCA_WILDFLY_DATA_TO_PERSIST="${EJBCA_WILDFLY_CONF_DIR},${EJBCA_WILDFLY_ADMIN_PASSWORD_FILE},${EJBCA_WILDFLY_BASE_DIR}/standalone/data,${EJBCA_WILDFLY_KEYSTORE_PASSWORD_FILE},${EJBCA_WILDFLY_TRUSTSTORE_PASSWORD_FILE}"

# Custom environment variables may be defined below
