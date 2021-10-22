#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/libpostgresql.sh

# Load PostgreSQL environment variables
. /opt/bitnami/scripts/postgresql-env.sh

print_welcome_page

# Enable the nss_wrapper settings
postgresql_enable_nss_wrapper

if [[ "$*" = *"/opt/bitnami/scripts/postgresql/run.sh"* ]]; then
    info "** Starting PostgreSQL setup **"
    /opt/bitnami/scripts/postgresql/setup.sh
    touch "$POSTGRESQL_TMP_DIR"/.initialized
    info "** PostgreSQL setup finished! **"
fi

echo ""
exec "$@"
