#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# shellcheck disable=SC1091

# Load libraries
. /liblog.sh
. /libbitnami.sh
. /libpostgresql.sh
. /librepmgr.sh

# Load PostgreSQL & repmgr environment variables
eval "$(repmgr_env)"
eval "$(postgresql_env)"
export MODULE=postgresql-repmgr

print_welcome_page

# Enable the nss_wrapper settings
postgresql_enable_nss_wrapper

if [[ "$*" = *"/run.sh"* ]]; then
    info "** Starting PostgreSQL with Replication Manager setup **"
    /setup.sh
    touch "$POSTGRESQL_TMP_DIR"/.initialized
    info "** PostgreSQL with Replication Manager setup finished! **"
fi

echo ""
exec "$@"
