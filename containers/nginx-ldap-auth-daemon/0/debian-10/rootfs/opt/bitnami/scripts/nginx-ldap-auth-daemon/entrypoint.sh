#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace # Uncomment this line for debugging purpose

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libnginxldapauthdaemon.sh

# Load NGINX environment variables
eval "$(nginxldap_env)"

print_welcome_page

if [[ "$*" = *"/opt/bitnami/scripts/nginx-ldap-auth-daemon/run.sh"* ]]; then
    info "** Starting NGINX LDAP Auth Daemon setup **"
    /opt/bitnami/scripts/nginx-ldap-auth-daemon/setup.sh
    info "** NGINX LDAP Auth Daemon setup finished! **"
fi

echo ""
exec "$@"
