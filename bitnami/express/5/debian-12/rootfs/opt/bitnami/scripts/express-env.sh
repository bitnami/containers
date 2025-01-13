#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for express

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
export MODULE="${MODULE:-express}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
express_env_vars=(
    EXPRESS_SKIP_DATABASE_WAIT
    EXPRESS_SKIP_DATABASE_MIGRATE
    EXPRESS_SKIP_SAMPLE_CODE
    EXPRESS_SKIP_NPM_INSTALL
    EXPRESS_SKIP_BOWER_INSTALL
    EXPRESS_DATABASE_TYPE
    EXPRESS_DATABASE_HOST
    EXPRESS_DATABASE_PORT_NUMBER
    EXPRESS_DEFAULT_MARIADB_DATABASE_PORT_NUMBER
    EXPRESS_DEFAULT_MONGODB_DATABASE_PORT_NUMBER
    EXPRESS_DEFAULT_MYSQL_DATABASE_PORT_NUMBER
    EXPRESS_DEFAULT_POSTGRESQL_DATABASE_PORT_NUMBER
    SKIP_DB_WAIT
    SKIP_DB_MIGRATE
    SKIP_SAMPLE_CODE
    SKIP_NPM_INSTALL
    SKIP_BOWER_INSTALL
)
for env_var in "${express_env_vars[@]}"; do
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
unset express_env_vars

# Express configuration
EXPRESS_SKIP_DATABASE_WAIT="${EXPRESS_SKIP_DATABASE_WAIT:-"${SKIP_DB_WAIT:-}"}"
export EXPRESS_SKIP_DATABASE_WAIT="${EXPRESS_SKIP_DATABASE_WAIT:-no}"
EXPRESS_SKIP_DATABASE_MIGRATE="${EXPRESS_SKIP_DATABASE_MIGRATE:-"${SKIP_DB_MIGRATE:-}"}"
export EXPRESS_SKIP_DATABASE_MIGRATE="${EXPRESS_SKIP_DATABASE_MIGRATE:-no}"
EXPRESS_SKIP_SAMPLE_CODE="${EXPRESS_SKIP_SAMPLE_CODE:-"${SKIP_SAMPLE_CODE:-}"}"
export EXPRESS_SKIP_SAMPLE_CODE="${EXPRESS_SKIP_SAMPLE_CODE:-no}"
EXPRESS_SKIP_NPM_INSTALL="${EXPRESS_SKIP_NPM_INSTALL:-"${SKIP_NPM_INSTALL:-}"}"
export EXPRESS_SKIP_NPM_INSTALL="${EXPRESS_SKIP_NPM_INSTALL:-no}"
EXPRESS_SKIP_BOWER_INSTALL="${EXPRESS_SKIP_BOWER_INSTALL:-"${SKIP_BOWER_INSTALL:-}"}"
export EXPRESS_SKIP_BOWER_INSTALL="${EXPRESS_SKIP_BOWER_INSTALL:-no}"

# Database configuration
export EXPRESS_DATABASE_TYPE="${EXPRESS_DATABASE_TYPE:-}"
export EXPRESS_DATABASE_HOST="${EXPRESS_DATABASE_HOST:-}"
export EXPRESS_DATABASE_PORT_NUMBER="${EXPRESS_DATABASE_PORT_NUMBER:-}"
export EXPRESS_DEFAULT_MARIADB_DATABASE_PORT_NUMBER="${EXPRESS_DEFAULT_MARIADB_DATABASE_PORT_NUMBER:-3306}"
export EXPRESS_DEFAULT_MONGODB_DATABASE_PORT_NUMBER="${EXPRESS_DEFAULT_MONGODB_DATABASE_PORT_NUMBER:-27017}"
export EXPRESS_DEFAULT_MYSQL_DATABASE_PORT_NUMBER="${EXPRESS_DEFAULT_MYSQL_DATABASE_PORT_NUMBER:-3306}"
export EXPRESS_DEFAULT_POSTGRESQL_DATABASE_PORT_NUMBER="${EXPRESS_DEFAULT_POSTGRESQL_DATABASE_PORT_NUMBER:-5432}"

# Custom environment variables may be defined below
