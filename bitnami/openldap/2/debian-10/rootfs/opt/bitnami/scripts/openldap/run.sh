#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libopenldap.sh

# Load LDAP environment variables
eval "$(ldap_env)"

readonly command="$(command -v slapd)"
# Add "@" so users can add extra command line flags
flags=("-h" "ldap://:${LDAP_PORT_NUMBER}/ ldapi:///" "-F" "${LDAP_CONF_DIR}/slapd.d" "-d" "256" "$@")

info "** Starting slapd **"
am_i_root && flags=("-u" "$LDAP_DAEMON_USER" "${flags[@]}")
exec "${command}" "${flags[@]}"

