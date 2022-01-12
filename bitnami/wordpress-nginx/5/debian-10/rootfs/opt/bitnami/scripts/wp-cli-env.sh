#!/bin/bash
#
# Environment configuration for wp-cli

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

# Load logging library
. /opt/bitnami/scripts/liblog.sh

export BITNAMI_ROOT_DIR="/opt/bitnami"
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-wp-cli}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# Paths
export WP_CLI_BASE_DIR="${BITNAMI_ROOT_DIR}/wp-cli"
export WP_CLI_BIN_DIR="${WP_CLI_BASE_DIR}/bin"
export WP_CLI_CONF_DIR="${WP_CLI_BASE_DIR}/conf"
export WP_CLI_CONF_FILE="${WP_CLI_CONF_DIR}/wp-cli.yml"
export PATH="${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# System users (when running with a privileged user)
export WP_CLI_DAEMON_USER="daemon"
export WP_CLI_DAEMON_GROUP="daemon"

# Custom environment variables may be defined below
