#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

# Load libraries
. /opt/bitnami/scripts/liblog.sh

if [[ "$*" = "/opt/bitnami/scripts/openldap/run.sh" ]]; then
    info "** Starting LDAP setup **"
    /opt/bitnami/scripts/openldap/setup.sh
    info "** LDAP setup finished! **"
fi

echo ""
exec "$@"
