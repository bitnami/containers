#!/bin/bash
#
# Bitnami Pgpool postunpack

# shellcheck disable=SC1091

# Load libraries
. /libfs.sh
. /libpgpool.sh

# Load Pgpool env. variables
eval "$(pgpool_env)"

for dir in "$PGPOOL_INITSCRIPTS_DIR" "$PGPOOL_TMP_DIR" "$PGPOOL_LOG_DIR" "$PGPOOL_CONF_DIR" "$PGPOOL_ETC_DIR" "$PGPOOL_DATA_DIR"; do
    ensure_dir_exists "$dir"
    chmod -R g+rwX "$dir"
done

# Copying LDAP files
openldap_conf=""
case "$OS_FLAVOUR" in
    debian-*) openldap_conf="/etc/ldap/ldap.conf" ;;
    centos-*|rhel-*|ol-*|photon-*) openldap_conf="/etc/openldap/ldap.conf" ;;
    *) ;;
esac
mv /ldap.conf "$openldap_conf"
mv /nslcd.conf /etc/nslcd.conf

# Redirect all logging to stdout
ln -sf /dev/stdout "$PGPOOL_LOG_FILE"
