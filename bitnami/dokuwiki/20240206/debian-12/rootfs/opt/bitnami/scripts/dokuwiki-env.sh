#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for dokuwiki

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
export MODULE="${MODULE:-dokuwiki}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
dokuwiki_env_vars=(
    DOKUWIKI_DATA_TO_PERSIST
    DOKUWIKI_USERNAME
    DOKUWIKI_FULL_NAME
    DOKUWIKI_EMAIL
    DOKUWIKI_PASSWORD
    DOKUWIKI_WIKI_NAME
)
for env_var in "${dokuwiki_env_vars[@]}"; do
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
unset dokuwiki_env_vars

# Paths
export DOKUWIKI_BASE_DIR="${BITNAMI_ROOT_DIR}/dokuwiki"

# DokuWiki persistence configuration
export DOKUWIKI_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/dokuwiki"
export DOKUWIKI_DATA_TO_PERSIST="${DOKUWIKI_DATA_TO_PERSIST:-data conf lib/plugins lib/tpl lib/images/smileys/local lib/images/interwiki}"

# DokuWiki configuration
export DOKUWIKI_USERNAME="${DOKUWIKI_USERNAME:-user}"
export DOKUWIKI_FULL_NAME="${DOKUWIKI_FULL_NAME:-FirstName LastName}"
export DOKUWIKI_EMAIL="${DOKUWIKI_EMAIL:-user@example.com}"
export DOKUWIKI_PASSWORD="${DOKUWIKI_PASSWORD:-bitnami1}"
export DOKUWIKI_WIKI_NAME="${DOKUWIKI_WIKI_NAME:-Bitnami DokuWiki}"

# PHP configuration
export PHP_DEFAULT_MEMORY_LIMIT="256M" # only used at build time

# Custom environment variables may be defined below
