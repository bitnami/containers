#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/libopensearch.sh

# Load environment
. /opt/bitnami/scripts/opensearch-env.sh

if [[ "$APP_VERSION" =~ ^1\. ]]; then
  export OPENSEARCH_SECURITY_CONF_DIR="${OPENSEARCH_SECURITY_DIR}/securityconfig"
fi

# Ensure Opensearch environment variables settings are valid
elasticsearch_validate
# Ensure Opensearch is stopped when this script ends
trap "elasticsearch_stop" EXIT
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$DB_DAEMON_USER" --group "$DB_DAEMON_GROUP"
# Ensure Opensearch is initialized
elasticsearch_initialize
# Ensure kernel settings are valid
elasticsearch_validate_kernel
# Install Opensearch plugins
elasticsearch_install_plugins
# Ensure custom initialization scripts are executed
elasticsearch_custom_init_scripts
