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

# Ensure OpenSearch environment variables settings are valid
elasticsearch_validate
# Ensure OpenSearch is stopped when this script ends and we clean up temporary files
trap "elasticsearch_stop; cleanup_credentials" EXIT
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$DB_DAEMON_USER" --group "$DB_DAEMON_GROUP"
# Ensure OpenSearch is initialized
elasticsearch_initialize
# Ensure kernel settings are valid
elasticsearch_validate_kernel
# Install OpenSearch plugins
elasticsearch_install_plugins
# Ensure custom initialization scripts are executed
elasticsearch_custom_init_scripts
