#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for wordpress

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
export MODULE="${MODULE:-wordpress}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
wordpress_env_vars=(
    WORDPRESS_DATA_TO_PERSIST
    WORDPRESS_ENABLE_HTTPS
    WORDPRESS_BLOG_NAME
    WORDPRESS_SCHEME
    WORDPRESS_HTACCESS_OVERRIDE_NONE
    WORDPRESS_ENABLE_HTACCESS_PERSISTENCE
    WORDPRESS_RESET_DATA_PERMISSIONS
    WORDPRESS_TABLE_PREFIX
    WORDPRESS_PLUGINS
    WORDPRESS_EXTRA_INSTALL_ARGS
    WORDPRESS_EXTRA_CLI_ARGS
    WORDPRESS_EXTRA_WP_CONFIG_CONTENT
    WORDPRESS_SKIP_BOOTSTRAP
    WORDPRESS_AUTO_UPDATE_LEVEL
    WORDPRESS_AUTH_KEY
    WORDPRESS_SECURE_AUTH_KEY
    WORDPRESS_LOGGED_IN_KEY
    WORDPRESS_NONCE_KEY
    WORDPRESS_AUTH_SALT
    WORDPRESS_SECURE_AUTH_SALT
    WORDPRESS_LOGGED_IN_SALT
    WORDPRESS_NONCE_SALT
    WORDPRESS_ENABLE_REVERSE_PROXY
    WORDPRESS_ENABLE_XML_RPC
    WORDPRESS_USERNAME
    WORDPRESS_PASSWORD
    WORDPRESS_EMAIL
    WORDPRESS_FIRST_NAME
    WORDPRESS_LAST_NAME
    WORDPRESS_ENABLE_MULTISITE
    WORDPRESS_MULTISITE_NETWORK_TYPE
    WORDPRESS_MULTISITE_EXTERNAL_HTTP_PORT_NUMBER
    WORDPRESS_MULTISITE_EXTERNAL_HTTPS_PORT_NUMBER
    WORDPRESS_MULTISITE_HOST
    WORDPRESS_MULTISITE_ENABLE_NIP_IO_REDIRECTION
    WORDPRESS_MULTISITE_FILEUPLOAD_MAXK
    WORDPRESS_SMTP_HOST
    WORDPRESS_SMTP_PORT_NUMBER
    WORDPRESS_SMTP_USER
    WORDPRESS_SMTP_FROM_EMAIL
    WORDPRESS_SMTP_FROM_NAME
    WORDPRESS_SMTP_PASSWORD
    WORDPRESS_SMTP_PROTOCOL
    WORDPRESS_DATABASE_HOST
    WORDPRESS_DATABASE_PORT_NUMBER
    WORDPRESS_DATABASE_NAME
    WORDPRESS_DATABASE_USER
    WORDPRESS_DATABASE_PASSWORD
    WORDPRESS_ENABLE_DATABASE_SSL
    WORDPRESS_VERIFY_DATABASE_SSL
    WORDPRESS_DATABASE_SSL_CERT_FILE
    WORDPRESS_DATABASE_SSL_KEY_FILE
    WORDPRESS_DATABASE_SSL_CA_FILE
    WORDPRESS_OVERRIDE_DATABASE_SETTINGS
    WORDPRESS_HTACCESS_PERSISTENCE_ENABLED
    WORDPRESS_SKIP_INSTALL
    WORDPRESS_HTTP_PORT
    WORDPRESS_HTTP_PORT_NUMBER
    WORDPRESS_HTTPS_PORT
    WORDPRESS_HTTPS_PORT_NUMBER
    SMTP_HOST
    SMTP_PORT
    WORDPRESS_SMTP_PORT
    SMTP_USER
    SMTP_FROM_EMAIL
    SMTP_FROM_NAME
    SMTP_PASSWORD
    SMTP_PROTOCOL
    MARIADB_HOST
    MARIADB_PORT_NUMBER
    MARIADB_DATABASE_NAME
    MARIADB_DATABASE_USER
    MARIADB_DATABASE_PASSWORD
)
for env_var in "${wordpress_env_vars[@]}"; do
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
unset wordpress_env_vars

# Paths
export WORDPRESS_BASE_DIR="${BITNAMI_ROOT_DIR}/wordpress"
export WORDPRESS_CONF_FILE="${WORDPRESS_BASE_DIR}/wp-config.php"
export WP_CLI_BASE_DIR="${BITNAMI_ROOT_DIR}/wp-cli"
export WP_CLI_BIN_DIR="${WP_CLI_BASE_DIR}/bin"
export WP_CLI_CONF_DIR="${WP_CLI_BASE_DIR}/conf"
export WP_CLI_CONF_FILE="${WP_CLI_CONF_DIR}/wp-cli.yml"
export PATH="${BITNAMI_ROOT_DIR}/common/bin:${BITNAMI_ROOT_DIR}/mysql/bin:${PATH}"

# WordPress persistence configuration
export WORDPRESS_VOLUME_DIR="${BITNAMI_VOLUME_DIR}/wordpress"
export WORDPRESS_DATA_TO_PERSIST="${WORDPRESS_DATA_TO_PERSIST:-wp-config.php wp-content}"

# WordPress configuration
export WORDPRESS_ENABLE_HTTPS="${WORDPRESS_ENABLE_HTTPS:-no}" # only used during the first initialization
export WORDPRESS_BLOG_NAME="${WORDPRESS_BLOG_NAME:-"User's blog"}" # only used during the first initialization
export WORDPRESS_SCHEME="${WORDPRESS_SCHEME:-http}" # only used during the first initialization
export WORDPRESS_HTACCESS_OVERRIDE_NONE="${WORDPRESS_HTACCESS_OVERRIDE_NONE:-yes}" # only used during the first initialization
WORDPRESS_ENABLE_HTACCESS_PERSISTENCE="${WORDPRESS_ENABLE_HTACCESS_PERSISTENCE:-"${WORDPRESS_HTACCESS_PERSISTENCE_ENABLED:-}"}"
export WORDPRESS_ENABLE_HTACCESS_PERSISTENCE="${WORDPRESS_ENABLE_HTACCESS_PERSISTENCE:-no}" # only used during the first initialization
export WORDPRESS_RESET_DATA_PERMISSIONS="${WORDPRESS_RESET_DATA_PERMISSIONS:-no}"
export WORDPRESS_TABLE_PREFIX="${WORDPRESS_TABLE_PREFIX:-wp_}" # only used during the first initialization
export WORDPRESS_PLUGINS="${WORDPRESS_PLUGINS:-none}" # only used during the first initialization
export WORDPRESS_EXTRA_INSTALL_ARGS="${WORDPRESS_EXTRA_INSTALL_ARGS:-}" # only used during the first initialization
export WORDPRESS_EXTRA_CLI_ARGS="${WORDPRESS_EXTRA_CLI_ARGS:-}" # only used during the first initialization
export WORDPRESS_EXTRA_WP_CONFIG_CONTENT="${WORDPRESS_EXTRA_WP_CONFIG_CONTENT:-}" # only used during the first initialization
WORDPRESS_SKIP_BOOTSTRAP="${WORDPRESS_SKIP_BOOTSTRAP:-"${WORDPRESS_SKIP_INSTALL:-}"}"
export WORDPRESS_SKIP_BOOTSTRAP="${WORDPRESS_SKIP_BOOTSTRAP:-no}" # only used during the first initialization
export WORDPRESS_AUTO_UPDATE_LEVEL="${WORDPRESS_AUTO_UPDATE_LEVEL:-none}" # only used during the first initialization
export WORDPRESS_AUTH_KEY="${WORDPRESS_AUTH_KEY:-}"
export WORDPRESS_SECURE_AUTH_KEY="${WORDPRESS_SECURE_AUTH_KEY:-}"
export WORDPRESS_LOGGED_IN_KEY="${WORDPRESS_LOGGED_IN_KEY:-}"
export WORDPRESS_NONCE_KEY="${WORDPRESS_NONCE_KEY:-}"
export WORDPRESS_AUTH_SALT="${WORDPRESS_AUTH_SALT:-}"
export WORDPRESS_SECURE_AUTH_SALT="${WORDPRESS_SECURE_AUTH_SALT:-}"
export WORDPRESS_LOGGED_IN_SALT="${WORDPRESS_LOGGED_IN_SALT:-}"
export WORDPRESS_NONCE_SALT="${WORDPRESS_NONCE_SALT:-}"
export WORDPRESS_ENABLE_REVERSE_PROXY="${WORDPRESS_ENABLE_REVERSE_PROXY:-no}" # only used during the first initialization
export WORDPRESS_ENABLE_XML_RPC="${WORDPRESS_ENABLE_XML_RPC:-no}" # only used during the first initialization

# WordPress credentials
export WORDPRESS_USERNAME="${WORDPRESS_USERNAME:-user}" # only used during the first initialization
export WORDPRESS_PASSWORD="${WORDPRESS_PASSWORD:-bitnami}" # only used during the first initialization
export WORDPRESS_EMAIL="${WORDPRESS_EMAIL:-user@example.com}" # only used during the first initialization
export WORDPRESS_FIRST_NAME="${WORDPRESS_FIRST_NAME:-UserName}" # only used during the first initialization
export WORDPRESS_LAST_NAME="${WORDPRESS_LAST_NAME:-LastName}" # only used during the first initialization

# WordPress Multisite inputs
export WORDPRESS_ENABLE_MULTISITE="${WORDPRESS_ENABLE_MULTISITE:-no}" # only used during the first initialization
export WORDPRESS_MULTISITE_NETWORK_TYPE="${WORDPRESS_MULTISITE_NETWORK_TYPE:-subdomain}" # only used during the first initialization
WORDPRESS_MULTISITE_EXTERNAL_HTTP_PORT_NUMBER="${WORDPRESS_MULTISITE_EXTERNAL_HTTP_PORT_NUMBER:-"${WORDPRESS_HTTP_PORT:-}"}"
WORDPRESS_MULTISITE_EXTERNAL_HTTP_PORT_NUMBER="${WORDPRESS_MULTISITE_EXTERNAL_HTTP_PORT_NUMBER:-"${WORDPRESS_HTTP_PORT_NUMBER:-}"}"
export WORDPRESS_MULTISITE_EXTERNAL_HTTP_PORT_NUMBER="${WORDPRESS_MULTISITE_EXTERNAL_HTTP_PORT_NUMBER:-80}" # only used during the first initialization
WORDPRESS_MULTISITE_EXTERNAL_HTTPS_PORT_NUMBER="${WORDPRESS_MULTISITE_EXTERNAL_HTTPS_PORT_NUMBER:-"${WORDPRESS_HTTPS_PORT:-}"}"
WORDPRESS_MULTISITE_EXTERNAL_HTTPS_PORT_NUMBER="${WORDPRESS_MULTISITE_EXTERNAL_HTTPS_PORT_NUMBER:-"${WORDPRESS_HTTPS_PORT_NUMBER:-}"}"
export WORDPRESS_MULTISITE_EXTERNAL_HTTPS_PORT_NUMBER="${WORDPRESS_MULTISITE_EXTERNAL_HTTPS_PORT_NUMBER:-443}" # only used during the first initialization
export WORDPRESS_MULTISITE_HOST="${WORDPRESS_MULTISITE_HOST:-}" # only used during the first initialization
export WORDPRESS_MULTISITE_ENABLE_NIP_IO_REDIRECTION="${WORDPRESS_MULTISITE_ENABLE_NIP_IO_REDIRECTION:-no}" # only used during the first initialization
export WORDPRESS_MULTISITE_FILEUPLOAD_MAXK="${WORDPRESS_MULTISITE_FILEUPLOAD_MAXK:-81920}" # only used during the first initialization

# WordPress SMTP credentials
WORDPRESS_SMTP_HOST="${WORDPRESS_SMTP_HOST:-"${SMTP_HOST:-}"}"
export WORDPRESS_SMTP_HOST="${WORDPRESS_SMTP_HOST:-}" # only used during the first initialization
WORDPRESS_SMTP_PORT_NUMBER="${WORDPRESS_SMTP_PORT_NUMBER:-"${SMTP_PORT:-}"}"
WORDPRESS_SMTP_PORT_NUMBER="${WORDPRESS_SMTP_PORT_NUMBER:-"${WORDPRESS_SMTP_PORT:-}"}"
export WORDPRESS_SMTP_PORT_NUMBER="${WORDPRESS_SMTP_PORT_NUMBER:-}" # only used during the first initialization
WORDPRESS_SMTP_USER="${WORDPRESS_SMTP_USER:-"${SMTP_USER:-}"}"
export WORDPRESS_SMTP_USER="${WORDPRESS_SMTP_USER:-}" # only used during the first initialization
WORDPRESS_SMTP_FROM_EMAIL="${WORDPRESS_SMTP_FROM_EMAIL:-"${SMTP_FROM_EMAIL:-}"}"
export WORDPRESS_SMTP_FROM_EMAIL="${WORDPRESS_SMTP_FROM_EMAIL:-${WORDPRESS_SMTP_USER}}" # only used during the first initialization
WORDPRESS_SMTP_FROM_NAME="${WORDPRESS_SMTP_FROM_NAME:-"${SMTP_FROM_NAME:-}"}"
export WORDPRESS_SMTP_FROM_NAME="${WORDPRESS_SMTP_FROM_NAME:-${WORDPRESS_FIRST_NAME} ${WORDPRESS_LAST_NAME}}" # only used during the first initialization
WORDPRESS_SMTP_PASSWORD="${WORDPRESS_SMTP_PASSWORD:-"${SMTP_PASSWORD:-}"}"
export WORDPRESS_SMTP_PASSWORD="${WORDPRESS_SMTP_PASSWORD:-}" # only used during the first initialization
WORDPRESS_SMTP_PROTOCOL="${WORDPRESS_SMTP_PROTOCOL:-"${SMTP_PROTOCOL:-}"}"
export WORDPRESS_SMTP_PROTOCOL="${WORDPRESS_SMTP_PROTOCOL:-}" # only used during the first initialization

# Database configuration
export WORDPRESS_DEFAULT_DATABASE_HOST="mariadb" # only used at build time
WORDPRESS_DATABASE_HOST="${WORDPRESS_DATABASE_HOST:-"${MARIADB_HOST:-}"}"
export WORDPRESS_DATABASE_HOST="${WORDPRESS_DATABASE_HOST:-$WORDPRESS_DEFAULT_DATABASE_HOST}" # only used during the first initialization
WORDPRESS_DATABASE_PORT_NUMBER="${WORDPRESS_DATABASE_PORT_NUMBER:-"${MARIADB_PORT_NUMBER:-}"}"
export WORDPRESS_DATABASE_PORT_NUMBER="${WORDPRESS_DATABASE_PORT_NUMBER:-3306}" # only used during the first initialization
WORDPRESS_DATABASE_NAME="${WORDPRESS_DATABASE_NAME:-"${MARIADB_DATABASE_NAME:-}"}"
export WORDPRESS_DATABASE_NAME="${WORDPRESS_DATABASE_NAME:-bitnami_wordpress}" # only used during the first initialization
WORDPRESS_DATABASE_USER="${WORDPRESS_DATABASE_USER:-"${MARIADB_DATABASE_USER:-}"}"
export WORDPRESS_DATABASE_USER="${WORDPRESS_DATABASE_USER:-bn_wordpress}" # only used during the first initialization
WORDPRESS_DATABASE_PASSWORD="${WORDPRESS_DATABASE_PASSWORD:-"${MARIADB_DATABASE_PASSWORD:-}"}"
export WORDPRESS_DATABASE_PASSWORD="${WORDPRESS_DATABASE_PASSWORD:-}" # only used during the first initialization
export WORDPRESS_ENABLE_DATABASE_SSL="${WORDPRESS_ENABLE_DATABASE_SSL:-no}" # only used during the first initialization
export WORDPRESS_VERIFY_DATABASE_SSL="${WORDPRESS_VERIFY_DATABASE_SSL:-yes}" # only used during the first initialization
export WORDPRESS_DATABASE_SSL_CERT_FILE="${WORDPRESS_DATABASE_SSL_CERT_FILE:-}" # only used during the first initialization
export WORDPRESS_DATABASE_SSL_KEY_FILE="${WORDPRESS_DATABASE_SSL_KEY_FILE:-}" # only used during the first initialization
export WORDPRESS_DATABASE_SSL_CA_FILE="${WORDPRESS_DATABASE_SSL_CA_FILE:-}" # only used during the first initialization
export WORDPRESS_OVERRIDE_DATABASE_SETTINGS="${WORDPRESS_OVERRIDE_DATABASE_SETTINGS:-no}"

# PHP configuration
export PHP_DEFAULT_MEMORY_LIMIT="512M" # only used at build time
export PHP_DEFAULT_POST_MAX_SIZE="80M" # only used at build time
export PHP_DEFAULT_UPLOAD_MAX_FILESIZE="80M" # only used at build time

# System users (when running with a privileged user)
export WP_CLI_DAEMON_USER="daemon"
export WP_CLI_DAEMON_GROUP="daemon"

# Custom environment variables may be defined below
