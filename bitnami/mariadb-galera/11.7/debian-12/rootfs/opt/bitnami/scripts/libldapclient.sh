#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0
#
# Bitnami LDAP library

# shellcheck disable=SC1090,SC1091

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh

########################
# Loads global variables used on LDAP configuration.
# Globals:
#   LDAP_*
# Arguments:
#   None
# Returns:
#   Series of exports to be used as 'eval' arguments
#########################
ldap_env() {
    cat <<"EOF"
export LDAP_NSLCD_USER="nslcd"
export LDAP_URI="${LDAP_URI:-}"
export LDAP_BASE="${LDAP_BASE:-}"
export LDAP_BIND_DN="${LDAP_BIND_DN:-}"
export LDAP_BIND_PASSWORD="${LDAP_BIND_PASSWORD:-}"
export LDAP_BASE_LOOKUP="${LDAP_BASE_LOOKUP:-}"
export LDAP_NSS_INITGROUPS_IGNOREUSERS="${LDAP_NSS_INITGROUPS_IGNOREUSERS:-root,nslcd}"
export LDAP_SCOPE="${LDAP_SCOPE:-}"
export LDAP_TLS_REQCERT="${LDAP_TLS_REQCERT:-}"
export LDAP_SEARCH_FILTER="${LDAP_SEARCH_FILTER:-}"
export LDAP_SEARCH_MAP="${LDAP_SEARCH_MAP:-}"

EOF
    if [[ "$OS_FLAVOUR" =~ ^debian-.*$ ]]; then
        cat <<"EOF"
export LDAP_NSLCD_GROUP="nslcd"
EOF
    elif [[ "$OS_FLAVOUR" =~ ^(photon)-.*$ ]]; then
        cat <<"EOF"
export LDAP_NSLCD_GROUP="ldap"
EOF
    fi
}

########################
# Return LDAP config file path depending on distro
# Globals:
#   OS_FLAVOUR
# Arguments:
#   None
# Returns:
#   (String) LDAP config file path
#########################
ldap_openldap_config_path() {
    local openldap_config
    case "$OS_FLAVOUR" in
    debian-* | ubuntu-*) openldap_config=/etc/ldap/ldap.conf ;;
    photon-* | redhatubi-*) openldap_config=/etc/openldap/ldap.conf ;;
    *) error "Unsupported OS flavor ${OS_FLAVOUR}" && exit 1 ;;
    esac
    echo "$openldap_config"
}

########################
# Configure LDAP permissions (to be used at postunpack leve).
# Globals:
#   LDAP_*
# Arguments:
#   None
# Returns:
#   None
#########################
ldap_configure_permissions() {
    ensure_dir_exists "/var/run/nslcd" && configure_permissions_ownership "/var/run/nslcd" -u "root" -g "root" -d "775"
    # The nslcd.conf file may not exist in distros like UBI, so we need to create it first
    touch "/etc/nslcd.conf"
    configure_permissions_ownership "/etc/nslcd.conf" -u "root" -g "root" -f "660"
    configure_permissions_ownership "$(ldap_openldap_config_path)" -u "root" -g "root" -f "660"
}

########################
# Create nslcd.conf file
# Globals:
#   LDAP_*
# Arguments:
#   None
# Returns:
#   None
#########################
ldap_create_nslcd_config() {
    if am_i_root; then
        chown "root:${LDAP_NSLCD_GROUP}" "/etc/nslcd.conf"
        chown -R "${LDAP_NSLCD_USER}:${LDAP_NSLCD_GROUP}" "/var/run/nslcd"
        cat >"/etc/nslcd.conf" <<EOF
# The user and group nslcd should run as
uid $LDAP_NSLCD_USER
gid $LDAP_NSLCD_GROUP
EOF
    else
        cat >"/etc/nslcd.conf" <<EOF
# Comment out uid,gid to avoid attempting change user/group to run as
# uid
# gid
EOF
    fi
    cat >>"/etc/nslcd.conf" <<EOF
nss_initgroups_ignoreusers $LDAP_NSS_INITGROUPS_IGNOREUSERS

# The location at which the LDAP server(s) should be reachable.
uri $LDAP_URI
# The search base that will be used for all queries
base $LDAP_BASE
# The DN to bind with for normal lookups
binddn $LDAP_BIND_DN
bindpw $LDAP_BIND_PASSWORD
EOF
    if [[ -n "${LDAP_BASE_LOOKUP}" ]]; then
        cat >>"/etc/nslcd.conf" <<EOF
base passwd $LDAP_BASE_LOOKUP
EOF
    fi
    if [[ -n "${LDAP_SCOPE}" ]]; then
        cat >>"/etc/nslcd.conf" <<EOF
# The search scope
scope $LDAP_SCOPE
EOF
    fi
    if [[ -n "${LDAP_SEARCH_FILTER}" ]]; then
        cat >>"/etc/nslcd.conf" <<EOF
# LDAP search filter to use for posix users
filter passwd (objectClass=$LDAP_SEARCH_FILTER)
EOF
    fi
    if [[ -n "${LDAP_SEARCH_MAP}" ]]; then
        cat >>"/etc/nslcd.conf" <<EOF
# Used for lookup of custom attributes
map passwd uid $LDAP_SEARCH_MAP
EOF
    fi
    if [[ -n "${LDAP_TLS_REQCERT}" ]]; then
        cat >>"/etc/nslcd.conf" <<EOF
# TLS options
tls_reqcert $LDAP_TLS_REQCERT
EOF
    fi
    if am_i_root; then
        chmod "600" "/etc/nslcd.conf"
    fi
}

########################
# Create ldap.conf file
# Globals:
#   LDAP_*
# Arguments:
#   None
# Returns:
#   None
#########################
ldap_create_openldap_config() {
    cat >>"$(ldap_openldap_config_path)" <<EOF
BASE $LDAP_BASE
URI $LDAP_URI

TLS_CACERTDIR   /etc/openldap/certs

# Turning this off breaks GSSAPI used with krb5 when rdns = false
SASL_NOCANON    on
EOF
}

########################
# Create PAM configuration file
# Globals:
#   LDAP_*
# Arguments:
#   filename - PAM configuration file name
# Returns:
#   None
#########################
ldap_create_pam_config() {
    local filename="${1:?ip is missing}"
    cat >"/etc/pam.d/${filename}" <<EOF
auth     required  pam_ldap.so  try_first_pass debug
account  required  pam_ldap.so  debug
EOF
}

########################
# Initialize LDAP services
# Globals:
#   LDAP_*
# Arguments:
#   None
# Returns:
#   None
#########################
ldap_initialize() {
    if [[ -n "${LDAP_URI}" && "${LDAP_BASE}" && "${LDAP_BIND_DN}" && "${LDAP_BIND_PASSWORD}" ]]; then
        info "Configuring LDAP connection"
        ldap_create_nslcd_config
        ldap_create_openldap_config
    else
        info "Missing LDAP settings. Skipping LDAP initialization"
    fi
}

########################
# Start nslcd in background
# Arguments:
#   None
# Returns:
#   None
#########################
ldap_start_nslcd_bg() {
    info "Starting nslcd in background"
    nslcd
}
