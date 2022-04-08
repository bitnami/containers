#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

# Load libraries
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libopenldap.sh

# Load LDAP environment variables
eval "$(ldap_env)"

# Ensure non-root user has write permissions on a set of directories
for dir in "$LDAP_SHARE_DIR" "$LDAP_DATA_DIR" "$LDAP_ONLINE_CONF_DIR" "${LDAP_BASE_DIR}/var" "/docker-entrypoint-initdb.d"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# Symlinks to normalize directories
ln -sf "$LDAP_ONLINE_CONF_DIR" "${LDAP_CONF_DIR}/slapd.d"
ln -sf "$LDAP_DATA_DIR" "${LDAP_BASE_DIR}/var/data"
