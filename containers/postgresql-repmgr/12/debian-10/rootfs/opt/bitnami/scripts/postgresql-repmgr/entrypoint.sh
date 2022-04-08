#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libpostgresql.sh
. /opt/bitnami/scripts/librepmgr.sh

# Load PostgreSQL & repmgr environment variables
. /opt/bitnami/scripts/postgresql-env.sh
export MODULE=postgresql-repmgr

print_welcome_page

# Enable the nss_wrapper settings
postgresql_enable_nss_wrapper

if [[ "$*" = *"/opt/bitnami/scripts/postgresql-repmgr/run.sh"* ]]; then
    info "** Starting PostgreSQL with Replication Manager setup **"
    /opt/bitnami/scripts/postgresql-repmgr/setup.sh
    touch "$POSTGRESQL_TMP_DIR"/.initialized
    info "** PostgreSQL with Replication Manager setup finished! **"
fi

echo ""
exec "$@"
