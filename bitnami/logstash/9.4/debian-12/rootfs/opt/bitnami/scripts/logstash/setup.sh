#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load libraries
. /opt/bitnami/scripts/liblogstash.sh

# Load Logstash environment variables
. /opt/bitnami/scripts/logstash-env.sh

# Ensure Logstash environment variables are valid
logstash_validate

# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$LOGSTASH_DAEMON_USER" --group "$LOGSTASH_DAEMON_GROUP"

# Ensure Logstash is initialized
logstash_initialize
# Install Logstash plugins
logstash_install_plugins
