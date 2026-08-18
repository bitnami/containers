#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

# Load libraries
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libopenldap.sh

# Load LDAP environment variables
eval "$(ldap_env)"

# Ensure Open LDAP environment variables are valid
ldap_validate
# Ensure OpenLDAP is stopped when this script ends
trap "ldap_stop" EXIT
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$LDAP_DAEMON_USER" --group "$LDAP_DAEMON_GROUP"
# Ensure Open LDAP server is initialize
ldap_initialize
# Allow running custom initialization scripts
ldap_custom_init_scripts
