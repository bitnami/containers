#!/bin/bash

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
# Ensure 'daemon' user exists when running as 'root'
am_i_root && ensure_user_exists "$LDAP_DAEMON_USER" --group "$LDAP_DAEMON_GROUP"
# Ensure Open LDAP server is initialize
ldap_initialize
