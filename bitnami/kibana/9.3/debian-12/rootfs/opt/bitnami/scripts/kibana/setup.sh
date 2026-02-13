#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libkibana.sh
. /opt/bitnami/scripts/libos.sh

# Load environment
. /opt/bitnami/scripts/kibana-env.sh

# Ensure kibana environment variables are valid
kibana_validate

# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$SERVER_DAEMON_USER" --group "$SERVER_DAEMON_GROUP"

# Ensure kibana is initialized
kibana_initialize

# Create kibana_system user, if necessary
is_boolean_yes "$KIBANA_CREATE_USER" && kibana_create_system_user

# Ensure custom initialization scripts are executed
kibana_custom_init_scripts
