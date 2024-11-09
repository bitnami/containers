#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

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

declare -a flags
declare -A flags_map

# Drop privileges if we start as root
am_i_root && flags_map["-u"]="${LDAP_DAEMON_USER}"

# Set config dir
flags_map["-F"]="${LDAP_CONF_DIR}/slapd.d"

# Enable debug with desired level
flags_map["-d"]="${LDAP_LOGLEVEL}"

# The LDAP IPC is always on
flags_map["-h"]+="${flags_map["-h"]:+" "}ldapi:///"

# Add LDAP URI
# Since 'proxied LDAP' default port number is same as 'LDAP',
# enable LDAP URI when one of the following conditions are met:
# * proxy protocol capability is disabled
# * proxy protocol capability is enabled and proxy protocol port differ
if ! is_boolean_yes "${LDAP_ENABLE_PROXYPROTO}" \
    || [[ "${LDAP_PORT_NUMBER}" -ne "${LDAP_PROXYPROTO_PORT_NUMBER}" ]]
then
    flags_map["-h"]+="${flags_map["-h"]:+" "}ldap://:${LDAP_PORT_NUMBER}/"
fi

# Add LDAPS URI when TLS is enabled
# Since 'proxied LDAP over SSL' default port number is same as 'LDAP over SSL',
# enable LDAPS URI when one of the following conditions are met:
# * proxy protocol capability is disabled
# * proxy protocol capability is enabled and proxy protocol tls port differ
if is_boolean_yes "${LDAP_ENABLE_TLS}" \
    && { ! is_boolean_yes "${LDAP_ENABLE_PROXYPROTO}" \
        || [[ "${LDAP_LDAPS_PORT_NUMBER}" -ne "${LDAP_PROXYPROTO_LDAPS_PORT_NUMBER}" ]]; }
then
    flags_map["-h"]+="${flags_map["-h"]:+" "}ldaps://:${LDAP_LDAPS_PORT_NUMBER}/"
fi

# Add PLDAP URI when proxy protocol capability is enabled
if is_boolean_yes "${LDAP_ENABLE_PROXYPROTO}"; then
    flags_map["-h"]+="${flags_map["-h"]:+" "}pldap://:${LDAP_PROXYPROTO_PORT_NUMBER}/"
    # Also add PLDAPS URI when TLS is enabled
    is_boolean_yes "${LDAP_ENABLE_TLS}" \
        && flags_map["-h"]+="${flags_map["-h"]:+" "}pldaps://:${LDAP_PROXYPROTO_LDAPS_PORT_NUMBER}/"
fi

# Build flags list
for flag in "${!flags_map[@]}"; do
    flags+=("${flag}" "${flags_map[${flag}]}")
done

# Add "@" so users can add extra command line flags
flags+=("$@")

info "** Starting slapd **"
debug "Startup cmd: ${command}" "${flags[*]}"
exec "${command}" "${flags[@]}"
