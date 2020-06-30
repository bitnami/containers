#!/bin/bash
#
# Environment configuration for ejbca

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-ejbca}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
ejbca_env_vars=(
    EJBCA_SERVER_CERT_FILE
    EJBCA_SERVER_CERT_PASSWORD
    EJBCA_HTTP_PORT_NUMBER
    EJBCA_HTTPS_PORT_NUMBER
    EJBCA_ADMIN_USERNAME
    EJBCA_ADMIN_PASSWORD
    EJBCA_DATABASE_HOST
    EJBCA_DATABASE_PORT
    EJBCA_DATABASE_NAME
    EJBCA_DATABASE_USERNAME
    EJBCA_DATABASE_PASSWORD
    EJBCA_CA_NAME
    JAVA_OPTS

)
for env_var in "${ejbca_env_vars[@]}"; do
    file_env_var="${env_var}_FILE"
    if [[ -n "${!file_env_var:-}" ]]; then
        export "${env_var}=$(< "${!file_env_var}")"
        unset "${file_env_var}"
    fi
done
unset ejbca_env_vars

# Paths
export BITNAMI_VOLUME_DIR="/bitnami"
export EJBCA_BASE_DIR="/opt/bitnami/ejbca"
export EJBCA_BIN_DIR="${EJBCA_BASE_DIR}/bin"
export EJBCA_TMP_DIR="${EJBCA_BASE_DIR}/tmp"
export EJBCA_DATABASE_SCRIPTS_DIR="${EJBCA_BASE_DIR}/sql-scripts"

# Persitence
export EJBCA_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/ejbca"
export EJBCA_DATA_DIR="${EJBCA_VOLUME_DIR}/tls"

# DB scripts
export EJBCA_DB_SCRIPT_INDEXES="${EJBCA_DATABASE_SCRIPTS_DIR}/create-index-ejbca.sql"
export EJBCA_DB_SCRIPT_TABLES="${EJBCA_DATABASE_SCRIPTS_DIR}/create-tables-ejbca-mysql.sql"

# EJBA deployment
export EJBCA_EAR_FILE="${EJBCA_BASE_DIR}/dist/ejbca.ear"

# Keystores
export EJBCA_KEYSTORE_FILE="${EJBCA_DATA_DIR}/keystore.jks"
export EJBCA_KEYSTORE_PASSWORD_FILE="${EJBCA_DATA_DIR}/keystore.pwd"
export EJBCA_TRUSTSTORE_FILE="${EJBCA_DATA_DIR}/truststore.jks"
export EJBCA_TRUSTSTORE_PASSWORD_FILE="${EJBCA_DATA_DIR}/truststore.pwd"
export EJBCA_WILDFLY_ADMIN_PASSWORD_FILE="${EJBCA_DATA_DIR}/wildfly_admin.pwd"
export EJBCA_TEMP_KEYSTORE_FILE="${EJBCA_TMP_DIR}/keystore.jks"
export EJBCA_TEMP_TRUSTSTORE_FILE="${EJBCA_TMP_DIR}/truststore.jks"
export EJBCA_SERVER_CERT_FILE="${EJBCA_SERVER_CERT_FILE:-}"
export EJBCA_SERVER_CERT_PASSWORD="${EJBCA_SERVER_CERT_PASSWORD:-}"
export EJBCA_TEMP_CERT="${EJBCA_TMP_DIR}/cacert.der"

# Wildfly
export EJBCA_WILDFLY_BASE_DIR="/opt/bitnami/wildfly"
export EJBCA_WILDFLY_BIN_DIR="${EJBCA_WILDFLY_BASE_DIR}/bin"
export EJBCA_WILDFLY_PID_DIR="${EJBCA_TMP_DIR}"
export EJBCA_WILDFLY_PID_FILE="${EJBCA_WILDFLY_PID_DIR}/wildfly.pid"
export EJBCA_WILDFLY_DEPLOY_DIR="${EJBCA_WILDFLY_BASE_DIR}/standalone/deployments"
export EJBCA_WILDFLY_ADMIN_USER="admin"
export EJBCA_WILDFLY_TRUSTSTORE_FILE="${EJBCA_WILDFLY_BASE_DIR}/standalone/configuration/truststore.jks"
export EJBCA_WILDFLY_KEYSTORE_FILE="${EJBCA_WILDFLY_BASE_DIR}/standalone/configuration/keystore.jks"

# Users
export EJBCA_DAEMON_USER="wildfly"
export EJBCA_DAEMON_GROUP="wildfly"

# Settings
export EJBCA_HTTP_PORT_NUMBER="${EJBCA_HTTP_PORT_NUMBER:-8080}"
export EJBCA_HTTPS_PORT_NUMBER="${EJBCA_HTTPS_PORT_NUMBER:-8443}"
export EJBCA_ADMIN_USERNAME="${EJBCA_ADMIN_USERNAME:-superadmin}"
export EJBCA_ADMIN_PASSWORD="${EJBCA_ADMIN_PASSWORD:-Bitnami1234}"
export EJBCA_DATABASE_HOST="${EJBCA_DATABASE_HOST:-}"
export EJBCA_DATABASE_PORT="${EJBCA_DATABASE_PORT:-3306}"
export EJBCA_DATABASE_NAME="${EJBCA_DATABASE_NAME:-}"
export EJBCA_DATABASE_USERNAME="${EJBCA_DATABASE_USERNAME:-}"
export EJBCA_DATABASE_PASSWORD="${EJBCA_DATABASE_PASSWORD:-}"
export EJBCA_CA_NAME="${EJBCA_CA_NAME:-ManagementCA}"
export JAVA_OPTS="${JAVA_OPTS:--Xms2048m -Xmx2048m -XX:MetaspaceSize=192M -XX:MaxMetaspaceSize=256m -Djava.net.preferIPv4Stack=true -Dhibernate.dialect=org.hibernate.dialect.MySQL5Dialect -Dhibernate.dialect.storage_engine=innodb}"

# EJBCA environment variables.
export EJBCA_HOME="${EJBCA_BASE_DIR}"
export JAVA_HOME="/opt/bitnami/java"
export JBOSS_HOME="${EJBCA_WILDFLY_BASE_DIR}"
export LAUNCH_JBOSS_IN_BACKGROUND="true"
export JBOSS_PIDFILE="${EJBCA_WILDFLY_PID_FILE}"

# Custom environment variables may be defined below
