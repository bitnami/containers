#!/bin/bash
# Copyright Broadcom, Inc. All Rights Reserved.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail

# Load libraries
. /opt/bitnami/scripts/liblog.sh

if [[ "$1" = "/opt/bitnami/scripts/openldap/run.sh" ]]; then
    info "** Starting LDAP setup **"
    /opt/bitnami/scripts/openldap/setup.sh
    info "** LDAP setup finished! **"
fi

echo ""
exec "$@"
