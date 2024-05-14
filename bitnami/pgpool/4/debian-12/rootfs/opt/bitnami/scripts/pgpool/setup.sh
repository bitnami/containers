#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami Pgpool setup

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/libldapclient.sh
. /opt/bitnami/scripts/libpgpool.sh

# Load Pgpool env. variables
eval "$(pgpool_env)"
# Load LDAP environment variables
eval "$(ldap_env)"

# Ensure Pgpool environment variables are valid
pgpool_validate
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$PGPOOL_DAEMON_USER" --group "$PGPOOL_DAEMON_GROUP"
am_i_root && ensure_user_exists "$LDAP_NSLCD_USER" --group "$LDAP_NSLCD_GROUP"
# Ensure Pgpool is initialized
pgpool_initialize
# Ensure LDAP is initialized
is_boolean_yes "$PGPOOL_ENABLE_LDAP" && ldap_initialize
# Allow running custom initialization scripts
pgpool_custom_init_scripts
