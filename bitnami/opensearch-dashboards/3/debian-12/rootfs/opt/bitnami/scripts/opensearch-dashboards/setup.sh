#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libopensearchdashboards.sh
. /opt/bitnami/scripts/libos.sh

# Load environment
. /opt/bitnami/scripts/opensearch-dashboards-env.sh

# Ensure opensearch-dashboards environment variables are valid
kibana_validate

# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$SERVER_DAEMON_USER" --group "$SERVER_DAEMON_GROUP"

# Ensure opensearch-dashboards is initialized
kibana_initialize

# Ensure custom initialization scripts are executed
kibana_custom_init_scripts
