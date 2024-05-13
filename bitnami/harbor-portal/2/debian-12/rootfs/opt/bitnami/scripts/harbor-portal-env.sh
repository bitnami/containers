#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for harbor-portal

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
export MODULE="${MODULE:-harbor-portal}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# Paths
export HARBOR_PORTAL_BASE_DIR="${BITNAMI_ROOT_DIR}/harbor"
export HARBOR_PORTAL_NGINX_CONF_DIR="${HARBOR_PORTAL_BASE_DIR}/nginx-conf"
export HARBOR_PORTAL_NGINX_CONF_FILE="${HARBOR_PORTAL_NGINX_CONF_DIR}/nginx.conf"

# System users
export HARBOR_PORTAL_DAEMON_USER="harbor"
export HARBOR_PORTAL_DAEMON_GROUP="harbor"

# Custom environment variables may be defined below
