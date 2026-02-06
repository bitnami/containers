#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Environment configuration for kubescape

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
export MODULE="${MODULE:-kubescape}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# Paths
export KUBESCAPE_BASE_DIR="${BITNAMI_ROOT_DIR}/kubescape"
export KUBESCAPE_CACHE_DIR="${KUBESCAPE_BASE_DIR}/.cache"
export KUBESCAPE_ARTIFACTS_DIR="${KUBESCAPE_BASE_DIR}/.kubescape"
export TANZU_APPLICATION_CATALOG_FILE="${KUBESCAPE_BASE_DIR}/bitnami-catalog.json"

# Custom environment variables may be defined below
