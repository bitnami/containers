#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libopenldap.sh

# Load LDAP environment variables
eval "$(ldap_env)"

command="$(command -v slapd)"

# Reduce maximum number of open file descriptors
# https://github.com/docker/docker/issues/8231
ulimit -n "$LDAP_ULIMIT_NOFILES"

flags=("-h" "ldap://:${LDAP_PORT_NUMBER}/ ldapi:///")

# Add LDAPS URI when TLS is enabled
is_boolean_yes "$LDAP_ENABLE_TLS" && flags=("-h" "ldap://:${LDAP_PORT_NUMBER}/ ldaps://:${LDAP_LDAPS_PORT_NUMBER}/ ldapi:///")

# Add "@" so users can add extra command line flags
flags+=("-F" "${LDAP_CONF_DIR}/slapd.d" "-d" "$LDAP_LOGLEVEL" "$@")

info "** Starting slapd **"
am_i_root && flags=("-u" "$LDAP_DAEMON_USER" "${flags[@]}")
exec "${command}" "${flags[@]}"
